import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseAuthGateway {
  Stream<User?> authStateChanges();
  User? get currentUser;
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}

class FirebaseAuthGatewayImpl implements FirebaseAuthGateway {
  FirebaseAuthGatewayImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}

abstract class FirestoreGateway {
  FirebaseFirestore get instance;
}

class FirestoreGatewayImpl implements FirestoreGateway {
  FirestoreGatewayImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  FirebaseFirestore get instance => _firestore;
}

abstract class StorageGateway {
  FirebaseStorage get instance;
}

class StorageGatewayImpl implements StorageGateway {
  StorageGatewayImpl(this._storage);

  final FirebaseStorage _storage;

  @override
  FirebaseStorage get instance => _storage;
}

abstract class MessagingGateway {
  FirebaseMessaging get instance;
}

class MessagingGatewayImpl implements MessagingGateway {
  MessagingGatewayImpl(this._messaging);

  final FirebaseMessaging _messaging;

  @override
  FirebaseMessaging get instance => _messaging;
}
