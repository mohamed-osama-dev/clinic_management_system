import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/core/usecases/usecase.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CompleteDoctorProfileUseCase
    implements UseCase<AppUser, CompleteDoctorProfileParams> {
  CompleteDoctorProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(CompleteDoctorProfileParams params) {
    return _repository.completeDoctorProfile(
      userId: params.userId,
      specialty: params.specialty,
      yearsOfExperience: params.yearsOfExperience,
      licenseNumber: params.licenseNumber,
    );
  }
}

class CompleteDoctorProfileParams extends Equatable {
  const CompleteDoctorProfileParams({
    required this.userId,
    required this.specialty,
    required this.yearsOfExperience,
    required this.licenseNumber,
  });

  final String userId;
  final String specialty;
  final int yearsOfExperience;
  final String licenseNumber;

  @override
  List<Object?> get props => [userId, specialty, yearsOfExperience, licenseNumber];
}
