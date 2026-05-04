import 'dart:io';

import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser?>> getCurrentUser();

  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    File? avatarFile,
  });

  Future<Either<Failure, AppUser>> completeDoctorProfile({
    required String userId,
    required String specialty,
    required int yearsOfExperience,
    required String licenseNumber,
  });

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, bool>> checkEmailVerified();

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, Unit>> signOut();
}
