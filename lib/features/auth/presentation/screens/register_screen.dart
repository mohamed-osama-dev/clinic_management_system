import 'dart:io';

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
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  UserRole _role = UserRole.patient;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadSelectedRole();
  }

  Future<void> _loadSelectedRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String roleStr = prefs.getString('selected_role') ?? 'patient';
    if (!mounted) {
      return;
    }
    setState(() {
      _role = roleStr == 'doctor' ? UserRole.doctor : UserRole.patient;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<AuthCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phone: '',
      role: _role,
      avatarFile: _selectedImage,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              if (state.user.role == UserRole.doctor && !state.user.isProfileComplete) {
                context.go(AppRoutes.registerDoctorStep2);
              } else {
                context.go(AppRoutes.emailVerification);
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => context.go(AppRoutes.login),
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: AppDimensions.iconM,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'الخطوة 1 من 2',
                            style: AppTextStyles.captionText.copyWith(
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      const Text(
                        'إنشاء حساب جديد',
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      const Text(
                        'أنشئ حسابك للاستفادة من خدماتنا',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        padding: const EdgeInsets.all(AppDimensions.paddingXS),
                        child: Row(
                          children: [
                            _RoleTab(
                              label: 'مريض',
                              icon: Icons.person_outline_rounded,
                              isSelected: _role == UserRole.patient,
                              onTap: () => setState(() => _role = UserRole.patient),
                            ),
                            _RoleTab(
                              label: 'طبيب',
                              icon: Icons.manage_accounts_outlined,
                              isSelected: _role == UserRole.doctor,
                              onTap: () => setState(() => _role = UserRole.doctor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Center(
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 44,
                                    backgroundColor: AppColors.background,
                                    backgroundImage: _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                        : null,
                                    child: _selectedImage == null
                                        ? const Icon(
                                            Icons.person_outline_rounded,
                                            size: 44,
                                            color: AppColors.textHint,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.paddingS),
                              Text(
                                'إضافة صورة شخصية',
                                style: AppTextStyles.captionText.copyWith(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      AppTextField(
                        label: 'الاسم الكامل',
                        hint: 'مثال: محمد أحمد',
                        controller: _nameController,
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconM,
                        ),
                        validator: (value) => Validators.requiredField(value, fieldName: 'الاسم'),
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
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
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      AppButton(
                        label: 'متابعة ←',
                        isLoading: state is AuthLoading,
                        onTap: state is AuthLoading ? null : _onContinue,
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب؟ ',
                            style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Cairo'),
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.login),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              textStyle: const TextStyle(
                                color: AppColors.primary,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('تسجيل الدخول'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  const _RoleTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
