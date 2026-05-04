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

class DoctorSpecialtyScreen extends StatefulWidget {
  const DoctorSpecialtyScreen({super.key});

  @override
  State<DoctorSpecialtyScreen> createState() => _DoctorSpecialtyScreenState();
}

class _DoctorSpecialtyScreenState extends State<DoctorSpecialtyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  String? _selectedSpecialty;

  static const List<_SpecialtyItem> _specialties = <_SpecialtyItem>[
    _SpecialtyItem('طب القلب', Icons.favorite_outline, Color(0xFFEF4444)),
    _SpecialtyItem('طب الأطفال', Icons.child_care_outlined, Color(0xFF3B82F6)),
    _SpecialtyItem('الجلدية', Icons.auto_awesome_outlined, Color(0xFF8B5CF6)),
    _SpecialtyItem('الأسنان', Icons.sentiment_satisfied_outlined, Color(0xFFF59E0B)),
    _SpecialtyItem('العظام', Icons.accessibility_new_outlined, Color(0xFF6366F1)),
    _SpecialtyItem('العيون', Icons.visibility_outlined, Color(0xFF06B6D4)),
    _SpecialtyItem('الأعصاب', Icons.psychology_outlined, Color(0xFF10B981)),
    _SpecialtyItem('الباطنة', Icons.medical_services_outlined, Color(0xFF00B09B)),
  ];

  @override
  void dispose() {
    _experienceController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
    if (_selectedSpecialty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار تخصصك',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final AuthState authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return;
    }

    await context.read<AuthCubit>().completeDoctorProfile(
      userId: authState.user.id,
      specialty: _selectedSpecialty!,
      yearsOfExperience: int.parse(_experienceController.text.trim()),
      licenseNumber: _licenseController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated && state.user.isProfileComplete) {
              if (state.user.role == UserRole.doctor) {
                if (state.user.isEmailVerified) {
                  context.go(AppRoutes.doctorDashboard);
                } else {
                  context.go(AppRoutes.emailVerification);
                }
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
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingL,
                  48,
                  AppDimensions.paddingL,
                  AppDimensions.paddingL,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: AppDimensions.iconM,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'الخطوة 2 من 2',
                            style: AppTextStyles.captionText.copyWith(
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      const Text(
                        'اختر تخصصك',
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      const Text(
                        'حدّد تخصصك الرئيسي ليتمكن المرضى من الوصول إليك بسهولة',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppDimensions.paddingS,
                          mainAxisSpacing: AppDimensions.paddingS,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: _specialties.length,
                        itemBuilder: (context, index) {
                          final _SpecialtyItem item = _specialties[index];
                          final bool isSelected = _selectedSpecialty == item.name;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedSpecialty = item.name),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryLight : AppColors.background,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? item.color.withValues(alpha: 0.15)
                                              : item.color.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusM,
                                          ),
                                        ),
                                        child: Icon(item.icon, color: item.color, size: 28),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDimensions.paddingS),
                                  Text(
                                    item.name,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      fontFamily: 'Cairo',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      AppTextField(
                        label: 'سنوات الخبرة',
                        hint: '12 سنة',
                        controller: _experienceController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(
                          Icons.school_outlined,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconM,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'سنوات الخبرة مطلوبة';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'أدخل رقماً صحيحاً';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      AppTextField(
                        label: 'رقم الترخيص الطبي',
                        hint: 'MED-2024-58392',
                        controller: _licenseController,
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconM,
                        ),
                        validator: (value) =>
                            Validators.requiredField(value, fieldName: 'رقم الترخيص'),
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      AppButton(
                        label: 'إنهاء التسجيل',
                        isLoading: state is AuthLoading,
                        onTap: state is AuthLoading ? null : _onComplete,
                      ),
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

class _SpecialtyItem {
  const _SpecialtyItem(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}
