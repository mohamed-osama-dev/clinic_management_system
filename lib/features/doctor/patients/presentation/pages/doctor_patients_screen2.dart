// Path: lib/features/doctor/patients/presentation/pages/doctor_patients_screen2.dart

import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

class DoctorPatientsScreen extends StatelessWidget {
  const DoctorPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('المحادثات', style: AppTextStyles.h3),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              'لا توجد محادثات حالياً',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}