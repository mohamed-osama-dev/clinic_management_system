// Path: lib/features/patient/profile/presentation/screens/patient_profile_screen.dart

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/patient/medical_records/presentation/screens/medical_records_screen.dart';
import 'package:clinic_management_system/features/shared/notifications/presentation/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_profile_screen.dart'; // أضفنا استدعاء شاشة التعديل

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primary,
                    child: Text('أ', style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32)),
                  ),
                  const SizedBox(height: 12),
                  const Text('أحمد المالكي', style: AppTextStyles.h2),
                  const Text('ahmad@example.com', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    // تم ربط الزر بشاشة التعديل
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditPatientProfileScreen())
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: const Text('تعديل الحساب', style: TextStyle(fontFamily: 'Cairo', color: AppColors.textPrimary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatItem(value: '32', label: 'العمر'),
                  _Divider(),
                  _StatItem(value: '78 كغ', label: 'الوزن'),
                  _Divider(),
                  _StatItem(value: 'O+', label: 'الفصيلة'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.favorite_outline_rounded,
                    label: 'ملفاتي الطبية',
                    iconColor: const Color(0xFFEF4444),
                    iconBg: const Color(0xFFFEE2E2),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalRecordsScreen())),
                  ),
                  _divider(),
                  _MenuItem(
                    icon: Icons.credit_card_outlined,
                    label: 'الدفع والفواتير',
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    onTap: () {},
                  ),
                  _divider(),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'الإشعارات',
                    iconColor: const Color(0xFFF59E0B),
                    iconBg: const Color(0xFFFEF3C7),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                  ),
                  _divider(),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'تسجيل الخروج',
                    iconColor: const Color(0xFFEF4444),
                    iconBg: const Color(0xFFFEE2E2),
                    labelColor: const Color(0xFFEF4444),
                    // تم إضافة دالة تسجيل الخروج هنا
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                    },
                    showArrow: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16);
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3),
        Text(label, style: AppTextStyles.captionText),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.border);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBg;
  final Color? labelColor;
  final VoidCallback onTap;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBg,
    this.labelColor,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: showArrow ? const Icon(Icons.chevron_left_rounded, color: AppColors.textHint) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.labelLarge.copyWith(color: labelColor ?? AppColors.textPrimary)),
          const SizedBox(width: 8),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ],
      ),
    );
  }
}