import 'dart:io';

import 'package:clinic_management_system/core/errors/exceptions.dart';
import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    File? avatarFile,
  }) async {
    try {
      final AppUser user = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
        avatarFile: avatarFile,
      );
      return Right(user);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> completeDoctorProfile({
    required String userId,
    required String specialty,
    required int yearsOfExperience,
    required String licenseNumber,
  }) async {
    try {
      final AppUser user = await _remoteDataSource.completeDoctorProfile(
        userId: userId,
        specialty: specialty,
        yearsOfExperience: yearsOfExperience,
        licenseNumber: licenseNumber,
      );
      return Right(user);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await _remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    try {
      final bool verified = await _remoteDataSource.checkEmailVerified();
      return Right(verified);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return Right(unit);
    } on AuthException catch (exception) {
      return Left(AuthFailure(exception.message));
    }
  }
}
