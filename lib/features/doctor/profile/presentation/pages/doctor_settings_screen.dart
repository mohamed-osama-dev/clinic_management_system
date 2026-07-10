import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';

class DoctorSettingsScreen extends StatelessWidget {
  const DoctorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نجلب الـ ID من الـ Cubit الحالي
    final authCubit = context.read<AuthCubit>();
    final userId = authCubit.currentUser?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text('البروفايل', style: AppTextStyles.h3),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // جلب البيانات مباشرة من الفايربيز
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          String doctorName = 'دكتور';
          String specialization = 'التخصص غير محدد';
          String experience = 'غير محدد';

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            // تحديث الأسماء لتطابق الفايربيز
            doctorName = data['name'] ?? doctorName;
            specialization = data['specialty'] ?? specialization;

            if (data['yearsOfExperience'] != null) {
              experience = '${data['yearsOfExperience']} سنوات خبرة';
            }
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Header Profile ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
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
                          const SizedBox(height: 4),
                          Text(experience, style: AppTextStyles.captionText.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Logout ──
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListTile(
                  onTap: () => context.read<AuthCubit>().signOut(),
                  leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  title: Text(
                    'تسجيل الخروج',
                    style: AppTextStyles.labelLarge.copyWith(color: const Color(0xFFEF4444)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}