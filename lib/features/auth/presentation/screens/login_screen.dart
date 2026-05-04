import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/utils/validators.dart';
import 'package:clinic_management_system/core/widgets/app_button.dart';
import 'package:clinic_management_system/core/widgets/app_text_field.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (!state.user.isEmailVerified) {
              context.go(AppRoutes.emailVerification);
              return;
            }
            if (state.user.role == UserRole.patient) {
              context.go(AppRoutes.patientHome);
            } else {
              context.go(AppRoutes.doctorDashboard);
            }
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
          final bool isLoading = state is AuthLoading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: AppDimensions.iconM,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    const Text(
                      'مرحباً بعودتك',
                      style: AppTextStyles.h1,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    const Text(
                      'سجّل دخولك للمتابعة',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    AppTextField(
                      label: 'البريد الإلكتروني',
                      hint: 'ahmad@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                        size: AppDimensions.iconM,
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    AppTextField(
                      label: 'كلمة المرور',
                      hint: '••••••••',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.textSecondary,
                        size: AppDimensions.iconM,
                      ),
                      validator: (value) =>
                          Validators.requiredField(value, fieldName: 'كلمة المرور'),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.forgotPassword),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    AppButton(
                      label: 'تسجيل الدخول',
                      isLoading: isLoading,
                      onTap: isLoading ? null : _onLogin,
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.border),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                          child: Text(
                            'أو سجّل عبر',
                            style: AppTextStyles.captionText.copyWith(fontFamily: 'Cairo'),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.border),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟ ',
                          style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Cairo'),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.register),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            textStyle: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('إنشاء حساب'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
