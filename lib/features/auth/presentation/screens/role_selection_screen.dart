import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/widgets/app_button.dart';
import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.patient;

  Future<void> _onContinue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_role', _selectedRole.name);
    if (!mounted) return;
    context.go(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: AppDimensions.paddingXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('من أنت؟', style: AppTextStyles.h1, textAlign: TextAlign.right),
                      SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        'اختر نوع حسابك للبدء',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: AppDimensions.paddingXL),
                    ],
                  ),
                ),
                _RoleCard(
                  label: 'أنا مريض',
                  description: 'احجز مواعيد واستشر أفضل الأطباء',
                  icon: Icons.person_outline_rounded,
                  isSelected: _selectedRole == UserRole.patient,
                  onTap: () => setState(() => _selectedRole = UserRole.patient),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                _RoleCard(
                  label: 'أنا طبيب',
                  description: 'إدارة المواعيد والمرضى',
                  icon: Icons.manage_accounts_outlined,
                  isSelected: _selectedRole == UserRole.doctor,
                  onTap: () => setState(() => _selectedRole = UserRole.doctor),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.paddingL),
                  child: AppButton(
                    label: '← متابعة',
                    variant: ButtonVariant.primary,
                    isFullWidth: true,
                    onTap: _onContinue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconL,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
