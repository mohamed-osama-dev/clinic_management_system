import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_strings.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Read auth state before delay to avoid using context across async gap
    final authState = context.read<AuthCubit>().state;
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    
    if (!hasSeenOnboarding) {
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
      return;
    }
    
    if (authState is AuthAuthenticated) {
      if (!mounted) return;
      if (authState.user.role == UserRole.patient) {
        context.go(AppRoutes.patientHome);
      } else {
        context.go(AppRoutes.doctorDashboard);
      }
    } else {
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}