import 'package:clinic_management_system/core/errors/failures.dart';
import 'package:clinic_management_system/core/usecases/usecase.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SendEmailVerificationUseCase implements UseCase<void, NoParams> {
  SendEmailVerificationUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.sendEmailVerification();
  }
}
