import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/widgets/app_button.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.user.role == UserRole.patient) {
              context.go(AppRoutes.patientHome);
            } else {
              context.go(AppRoutes.doctorDashboard);
            }
          }

          if (state is EmailNotVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'لم يتم التحقق بعد، تفقد بريدك',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final String email = context.read<AuthCubit>().currentUser?.email ?? '';
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  const Text(
                    'تحقق من بريدك الإلكتروني',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'أرسلنا رابط التحقق إلى\n$email',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    label: 'تم التحقق ✓',
                    onTap: () => context.read<AuthCubit>().checkEmailVerified(),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  TextButton(
                    onPressed: () {
                      context.read<AuthCubit>().sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تم إرسال الرابط مجدداً',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    child: const Text('إعادة إرسال الرابط'),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      textStyle: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    child: const Text('العودة لتسجيل الدخول'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
