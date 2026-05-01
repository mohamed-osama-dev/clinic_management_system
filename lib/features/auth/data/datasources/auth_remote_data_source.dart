import 'package:clinic_management_system/core/errors/exceptions.dart';
import 'package:clinic_management_system/features/auth/data/models/app_user_model.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:uuid/uuid.dart';

abstract class AuthRemoteDataSource {
  Future<AppUserModel?> getCurrentUser();

  Future<AppUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class InMemoryAuthRemoteDataSource implements AuthRemoteDataSource {
  InMemoryAuthRemoteDataSource();

  final Uuid _uuid = const Uuid();
  AppUserModel? _currentUser;

  @override
  Future<AppUserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    if (password.isEmpty) {
      throw const AuthException('Password is required');
    }

    final role = email.toLowerCase().contains('doctor')
        ? UserRole.doctor
        : UserRole.patient;

    _currentUser = AppUserModel(
      id: _uuid.v4(),
      email: email,
      name: role == UserRole.doctor ? 'Doctor User' : 'Patient User',
      role: role,
    );

    // TODO(migrate): Replace with FirebaseAuth + Firestore.
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
