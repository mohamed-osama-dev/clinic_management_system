import 'dart:io';

import 'package:clinic_management_system/core/usecases/usecase.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/complete_doctor_profile_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/get_current_user.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_in.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_out.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentUser getCurrentUser,
    required RegisterUseCase register,
    required CompleteDoctorProfileUseCase completeDoctorProfile,
    required SendEmailVerificationUseCase sendEmailVerification,
    required CheckEmailVerifiedUseCase checkEmailVerified,
    required SendPasswordResetUseCase sendPasswordReset,
    required SignIn signIn,
    required SignOut signOut,
  }) : _getCurrentUser = getCurrentUser,
       _register = register,
       _completeDoctorProfile = completeDoctorProfile,
       _sendEmailVerification = sendEmailVerification,
       _checkEmailVerified = checkEmailVerified,
       _sendPasswordReset = sendPasswordReset,
       _signIn = signIn,
       _signOut = signOut,
       super(const AuthInitial());

  final GetCurrentUser _getCurrentUser;
  final RegisterUseCase _register;
  final CompleteDoctorProfileUseCase _completeDoctorProfile;
  final SendEmailVerificationUseCase _sendEmailVerification;
  final CheckEmailVerifiedUseCase _checkEmailVerified;
  final SendPasswordResetUseCase _sendPasswordReset;
  final SignIn _signIn;
  final SignOut _signOut;
  AppUser? _lastAuthenticatedUser;
  AppUser? get currentUser => _lastAuthenticatedUser;

  void _emitAuthenticated(AppUser user) {
    _lastAuthenticatedUser = user;
    emit(AuthAuthenticated(user));
  }

  Future<void> checkAuthStatus() async {
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        if (user == null) {
          emit(const AuthUnauthenticated());
          return;
        }
        _emitAuthenticated(user);
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _signIn(SignInParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => _emitAuthenticated(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    File? avatarFile,
  }) async {
    emit(const AuthLoading());
    final result = await _register(
      RegisterParams(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
        avatarFile: avatarFile,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => _emitAuthenticated(user),
    );
  }

  Future<void> completeDoctorProfile({
    required String userId,
    required String specialty,
    required int yearsOfExperience,
    required String licenseNumber,
  }) async {
    emit(const AuthLoading());
    final result = await _completeDoctorProfile(
      CompleteDoctorProfileParams(
        userId: userId,
        specialty: specialty,
        yearsOfExperience: yearsOfExperience,
        licenseNumber: licenseNumber,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => _emitAuthenticated(user),
    );
  }

  Future<void> sendEmailVerification() async {
    final result = await _sendEmailVerification(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const EmailVerificationSent()),
    );
  }

  Future<void> checkEmailVerified() async {
    final result = await _checkEmailVerified(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verified) {
        if (!verified) {
          emit(const EmailNotVerified());
          return;
        }
        final AppUser? currentUser = _lastAuthenticatedUser;
        if (currentUser != null) {
          _emitAuthenticated(currentUser.copyWith(isEmailVerified: true));
          return;
        }
        emit(const AuthUnauthenticated());
      },
    );
  }

  Future<void> sendPasswordReset({required String email}) async {
    emit(const AuthLoading());
    final result = await _sendPasswordReset(
      SendPasswordResetParams(email: email),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PasswordResetEmailSent()),
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOut(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        _lastAuthenticatedUser = null;
        emit(const AuthUnauthenticated());
      },
    );
  }
}
