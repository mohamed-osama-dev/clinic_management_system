import 'dart:async';

import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/config/routes/route_guards.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/login_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/register_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/splash_screen.dart';
import 'package:clinic_management_system/features/doctor/dashboard/presentation/screens/doctor_dashboard_screen.dart';
import 'package:clinic_management_system/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) => roleBasedRedirect(
        authState: authCubit.state,
        location: state.matchedLocation,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.roleSelection,
          builder: (context, state) => const RoleSelectionScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.otpVerification,
          builder: (context, state) => const OtpVerificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientHome,
          builder: (context, state) => const PatientHomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.doctorDashboard,
          builder: (context, state) => const DoctorDashboardScreen(),
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
