import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
// تم إضافة الاستدعاء الخاص بحالة تسجيل الدخول
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';

class DoctorSettingsScreen extends StatelessWidget {
  const DoctorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text('الإعدادات', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Header Profile ──
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              String doctorName = 'دكتور';
              String specialization = 'التخصص غير محدد';

              // قراءة البيانات الحقيقية إذا كان مسجل الدخول
              if (state is AuthAuthenticated) {
                doctorName = state.user.name;
                specialization = state.user.specialization ?? specialization;
              }

              return Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('د. $doctorName', style: AppTextStyles.h3),
                        Text(specialization, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // ── Settings Sections ──
          _buildSectionTitle('إدارة العيادة'),
          _buildSettingsContainer([
            _SettingsItem(icon: Icons.access_time_rounded, label: 'مواعيد العمل', onTap: () {}),
            _buildDivider(),
            _SettingsItem(icon: Icons.location_on_outlined, label: 'بيانات العيادة', onTap: () {}),
            _buildDivider(),
            _SettingsItem(icon: Icons.account_balance_wallet_outlined, label: 'الماليات والأرباح', onTap: () {}),
          ]),

          const SizedBox(height: 24),
          _buildSectionTitle('عام'),
          _buildSettingsContainer([
            _SettingsItem(icon: Icons.notifications_outlined, label: 'الإشعارات', onTap: () {}),
            _buildDivider(),
            _SettingsItem(icon: Icons.lock_outline_rounded, label: 'الأمان وكلمة المرور', onTap: () {}),
            _buildDivider(),
            _SettingsItem(icon: Icons.help_outline_rounded, label: 'مركز المساعدة', onTap: () {}),
          ]),

          const SizedBox(height: 24),
          _buildSettingsContainer([
            _SettingsItem(
              icon: Icons.logout_rounded,
              label: 'تسجيل الخروج',
              iconColor: const Color(0xFFEF4444),
              textColor: const Color(0xFFEF4444),
              showArrow: false,
              onTap: () {
                context.read<AuthCubit>().signOut();
              },
            ),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8),
      child: Text(title, style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
    );
  }

  Widget _buildSettingsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16);
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showArrow;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: showArrow ? const Icon(Icons.chevron_left_rounded, color: AppColors.textHint) : null,
      trailing: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 24),
      title: Text(
        label,
        textAlign: TextAlign.right,
        style: AppTextStyles.labelLarge.copyWith(color: textColor ?? AppColors.textPrimary),
      ),
    );
  }
}