import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/features/doctor/patients/presentation/cubits/doctor_patients_state.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    required this.patient,
    required this.onTap,
    super.key,
  });

  final PatientModel patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Visits count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${patient.visitsCount}',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary),
                  ),
                  Text(
                    'زيارة',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppDimensions.paddingM),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    patient.name,
                    style: AppTextStyles.labelLarge,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${patient.age} سنة · ${patient.condition}',
                    style: AppTextStyles.bodySmall,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        patient.lastVisit,
                        style: AppTextStyles.captionText,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.access_time_rounded,
                        size: AppDimensions.iconS,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppDimensions.paddingM),

            // Avatar
            CircleAvatar(
              radius: AppDimensions.avatarM / 2,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                patient.name.substring(0, 1),
                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
