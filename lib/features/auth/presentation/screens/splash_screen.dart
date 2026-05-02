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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final authState = context.read<AuthCubit>().state;
        if (authState is AuthAuthenticated) {
          if (authState.user.role == UserRole.patient) {
            context.go(AppRoutes.patientHome);
          } else {
            context.go(AppRoutes.doctorDashboard);
          }
        } else {
          context.go(AppRoutes.login);
        }
      }
    });
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