import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/core/usecases/usecase.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SendPasswordResetUseCase implements UseCase<void, SendPasswordResetParams> {
  SendPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(SendPasswordResetParams params) {
    return _repository.sendPasswordResetEmail(email: params.email);
  }
}

class SendPasswordResetParams extends Equatable {
  const SendPasswordResetParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
