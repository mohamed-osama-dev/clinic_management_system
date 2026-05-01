import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';

String? roleBasedRedirect({
  required AuthState authState,
  required String location,
}) {
  final isAuthPage =
      location == AppRoutes.login ||
      location == AppRoutes.register ||
      location == AppRoutes.onboarding ||
      location == AppRoutes.roleSelection ||
      location == AppRoutes.otpVerification;

  if (authState is AuthInitial || authState is AuthLoading) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }

  if (authState is AuthUnauthenticated || authState is AuthError) {
    return isAuthPage ? null : AppRoutes.login;
  }

  if (authState is AuthAuthenticated) {
    final userRole = authState.user.role;

    if (isAuthPage || location == AppRoutes.splash) {
      return _homeByRole(userRole);
    }

    if (userRole == UserRole.patient && location.startsWith('/doctor')) {
      return AppRoutes.patientHome;
    }

    if (userRole == UserRole.doctor && location.startsWith('/patient')) {
      return AppRoutes.doctorDashboard;
    }
  }

  return null;
}

String _homeByRole(UserRole role) {
  return role == UserRole.doctor
      ? AppRoutes.doctorDashboard
      : AppRoutes.patientHome;
}
