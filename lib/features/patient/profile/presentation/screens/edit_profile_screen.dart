// Path: lib/features/patient/profile/presentation/screens/edit_patient_profile_screen.dart

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class EditPatientProfileScreen extends StatelessWidget {
  const EditPatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text('تعديل الحساب', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // حقول التعديل هتتضاف هنا
            const TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'الاسم الكامل',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'العمر',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // حفظ البيانات
                  Navigator.pop(context);
                },
                child: const Text('حفظ التعديلات', style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}