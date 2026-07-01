import 'dart:async';

import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/doctor_specialty_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/login_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/register_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:clinic_management_system/features/auth/presentation/screens/splash_screen.dart';
import 'package:clinic_management_system/features/doctor/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:clinic_management_system/features/doctor/dashboard/presentation/pages/doctor_dashboard_screen.dart';
import 'package:clinic_management_system/features/doctor/schedule/presentation/cubits/schedule_cubit.dart';
import 'package:clinic_management_system/features/doctor/schedule/presentation/pages/doctor_schedule_screen.dart';
import 'package:clinic_management_system/features/doctor/patients/presentation/cubits/doctor_patients_cubit.dart';
import 'package:clinic_management_system/features/doctor/patients/presentation/pages/doctor_patients_screen.dart';
import 'package:clinic_management_system/features/doctor/prescription/presentation/cubits/prescription_cubit.dart';
import 'package:clinic_management_system/features/doctor/prescription/presentation/screens/prescription_screen.dart';
import 'package:clinic_management_system/features/doctor/patient_file/presentation/cubits/patient_file_cubit.dart';
import 'package:clinic_management_system/features/doctor/patient_file/presentation/screens/patient_file_screen.dart';
import 'package:clinic_management_system/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final location = state.matchedLocation;

      if (location == AppRoutes.splash) return null;

      final noAuthRequired = [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.roleSelection,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.registerDoctorStep2,
        AppRoutes.emailVerification,
        AppRoutes.forgotPassword,
        AppRoutes.otpVerification,
      ];
      if (noAuthRequired.contains(location)) return null;

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
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerDoctorStep2,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DoctorSpecialtyScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const EmailVerificationScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OtpVerificationScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.patientHome,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PatientHomeScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      // ── Doctor Routes ─────────────────────────────────────────────────────

      GoRoute(
        path: AppRoutes.doctorDashboard,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => DashboardCubit(),
            child: const DoctorDashboardScreen(),
          ),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.doctorSchedule,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => ScheduleCubit(),
            child: const DoctorScheduleScreen(),
          ),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.doctorPatients,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => DoctorPatientsCubit(),
            child: const DoctorPatientsScreen(),
          ),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.prescription,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => PrescriptionCubit(),
            child: const PrescriptionScreen(),
          ),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.patientFile,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => PatientFileCubit(),
            child: PatientFileScreen(
              patientId: state.pathParameters['patientId'],
            ),
          ),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      // ── Stub Routes ───────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.patientSearch, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.doctorProfile, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.booking, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.bookingConfirm, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.myAppointments, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.patientProfile, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.chat, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.videoCall, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.payment, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.visitRating, builder: (_, __) => const SizedBox()),
      GoRoute(path: AppRoutes.medicalRecords, builder: (_, __) => const SizedBox()),
    ],
    errorBuilder: (context, state) =>
        const Center(child: Text('الصفحة غير موجودة')),
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
