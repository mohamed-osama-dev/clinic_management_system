import 'dart:io';

import 'package:clinic_management_system/core/errors/exceptions.dart';
import 'package:clinic_management_system/features/auth/data/models/app_user_model.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AuthRemoteDataSource {
  Future<AppUserModel?> getCurrentUser();

  Future<AppUserModel> signIn({
    required String email,
    required String password,
  });

  Future<AppUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    File? avatarFile,
  });

  Future<AppUserModel> completeDoctorProfile({
    required String userId,
    required String specialty,
    required int yearsOfExperience,
    required String licenseNumber,
  });

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  FirebaseAuthDataSource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _auth = firebaseAuth,
       _firestore = firestore,
       _storage = storage;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<AppUserModel?> getCurrentUser() async {
    try {
      final User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        return null;
      }

      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      return AppUserModel.fromFirestore(doc).copyWith(
        isEmailVerified: firebaseUser.emailVerified,
      );
    } on FirebaseException {
      throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
    }
  }

  @override
  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final String? userId = credential.user?.uid;
      if (userId == null) {
        throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
      }

      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw const AuthException('المستخدم غير موجود');
      }

      return AppUserModel.fromFirestore(doc).copyWith(
        isEmailVerified: credential.user?.emailVerified ?? false,
      );
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_mapFirebaseError(exception.code));
    } on FirebaseException {
      throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
    }
  }

  @override
  Future<AppUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    File? avatarFile,
  }) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final String? userId = credential.user?.uid;
      if (userId == null) {
        throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
      }

      String? avatarUrl;
      if (avatarFile != null) {
        avatarUrl = await uploadAvatar(userId: userId, imageFile: avatarFile);
      }

      await credential.user?.updateDisplayName(name);
      await credential.user?.sendEmailVerification();

      final AppUserModel user = AppUserModel(
        id: userId,
        email: email.trim(),
        name: name,
        role: role,
        isEmailVerified: false,
        phone: phone,
        avatarUrl: avatarUrl,
        isProfileComplete: false,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userId).set(user.toFirestore());

      return user;
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_mapFirebaseError(exception.code));
    } on FirebaseException {
      throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
    }
  }

  @override
  Future<AppUserModel> completeDoctorProfile({
    required String userId,
    required String specialty,
    required int yearsOfExperience,
    required String licenseNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'specialty': specialty,
        'yearsOfExperience': yearsOfExperience,
        'licenseNumber': licenseNumber,
        'isProfileComplete': true,
      });

      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw const AuthException('المستخدم غير موجود');
      }

      return AppUserModel.fromFirestore(doc).copyWith(
        isEmailVerified: _auth.currentUser?.emailVerified ?? false,
      );
    } on FirebaseException {
      throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
    }
  }

  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    final Reference ref = _storage.ref('avatars/$userId.jpg');
    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_mapFirebaseError(exception.code));
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    try {
      await _auth.currentUser?.reload();
      final bool verified = _auth.currentUser?.emailVerified ?? false;
      final String? userId = _auth.currentUser?.uid;
      if (verified && userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'isEmailVerified': true,
        });
      }
      return verified;
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_mapFirebaseError(exception.code));
    } on FirebaseException {
      throw const AuthException('حدث خطأ، يرجى المحاولة مجدداً');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_mapFirebaseError(exception.code));
    }
  }

  @override
  Future<void> signOut() async => _auth.signOut();

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'البريد الإلكتروني غير مسجل';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة';
      case 'too-many-requests':
        return 'محاولات كثيرة، حاول لاحقاً';
      default:
        return 'حدث خطأ، يرجى المحاولة مجدداً';
    }
  }
}
