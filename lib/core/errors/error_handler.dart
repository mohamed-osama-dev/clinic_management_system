import 'package:clinic_management_system/core/errors/exceptions.dart';
import 'package:clinic_management_system/core/errors/failures.dart';

class ErrorHandler {
  const ErrorHandler._();

  static Failure mapToFailure(Object error) {
    if (error is AuthException) {
      return AuthFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
