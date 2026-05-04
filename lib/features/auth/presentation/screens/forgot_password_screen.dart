import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/utils/validators.dart';
import 'package:clinic_management_system/core/widgets/app_button.dart';
import 'package:clinic_management_system/core/widgets/app_text_field.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<AuthCubit>().sendPasswordReset(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is PasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم إرسال رابط إعادة التعيين، تحقق من بريدك',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            );
            await Future<void>.delayed(const Duration(seconds: 2));
            if (!context.mounted) {
              return;
            }
            context.go(AppRoutes.login);
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
                      'نسيت كلمة المرور؟',
                      style: AppTextStyles.h1,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    const Text(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    AppTextField(
                      label: 'البريد الإلكتروني',
                      hint: 'example@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                        size: AppDimensions.iconM,
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    AppButton(
                      label: 'إرسال رابط إعادة التعيين',
                      isLoading: state is AuthLoading,
                      onTap: state is AuthLoading ? null : _onSend,
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
