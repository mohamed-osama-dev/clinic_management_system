import 'dart:async';

import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/login_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/register_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/splash_screen.dart';
import 'package:clinic_management_system/features/doctor/dashboard/presentation/screens/doctor_dashboard_screen.dart';
import 'package:clinic_management_system/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final location = state.matchedLocation;

      if (location == AppRoutes.splash) return null;

      if (authState is! AuthAuthenticated) {
        return AppRoutes.login;
      }

      if (authState.user.role == UserRole.patient) {
        if (location.startsWith('/doctor')) return AppRoutes.patientHome;
      } else if (authState.user.role == UserRole.doctor) {
        if (location.startsWith('/patient')) return AppRoutes.doctorDashboard;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OtpVerificationScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.patientHome,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PatientHomeScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.doctorDashboard,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DoctorDashboardScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      // Stub routes
      GoRoute(path: AppRoutes.patientSearch, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.doctorProfile, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.booking, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.bookingConfirm, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.myAppointments, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.patientProfile, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.doctorSchedule, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.doctorPatients, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.prescription, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.chat, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.videoCall, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const SizedBox()),
    ],
    errorBuilder: (context, state) => const Center(child: Text('الصفحة غير موجودة')),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}