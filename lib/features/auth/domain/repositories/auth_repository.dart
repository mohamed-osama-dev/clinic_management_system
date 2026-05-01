import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser?>> getCurrentUser();

  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();
}
