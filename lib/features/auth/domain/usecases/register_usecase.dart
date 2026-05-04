import 'dart:io';

import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/core/usecases/usecase.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class RegisterUseCase implements UseCase<AppUser, RegisterParams> {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      role: params.role,
      avatarFile: params.avatarFile,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.role,
    this.avatarFile,
  });

  final String email;
  final String password;
  final String name;
  final String phone;
  final UserRole role;
  final File? avatarFile;

  @override
  List<Object?> get props => [email, password, name, phone, role, avatarFile];
}
