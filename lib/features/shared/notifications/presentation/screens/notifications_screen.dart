// Path: lib/features/shared/notifications/presentation/screens/notifications_screen.dart

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // سيتم جلب البيانات لاحقاً من الـ NotificationsCubit
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('الإشعارات', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('تعليم الكل كمقروء',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          SizedBox(height: 20),
          Center(
            child: Text('لا توجد إشعارات جديدة', style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}