// Placeholder stub for medicine card widget.
import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/features/doctor/prescription/presentation/cubits/prescription_state.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({
    required this.medicine,
    required this.onDelete,
    super.key,
  });

  final MedicineModel medicine;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Medicine name row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingM,
              AppDimensions.paddingM,
              AppDimensions.paddingM,
              AppDimensions.paddingS,
            ),
            child: Row(
              children: [
                // Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: AppDimensions.iconM,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                const Spacer(),

                // Medicine name + dose
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      medicine.name,
                      style: AppTextStyles.labelLarge,
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      medicine.dose,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),

                const SizedBox(width: AppDimensions.paddingS),

                // Medicine icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: const Icon(
                    Icons.medication_rounded,
                    color: AppColors.primary,
                    size: AppDimensions.iconM,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Frequency + Duration
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                // Duration
                Expanded(
                  child: _InfoChip(
                    label: 'المدة',
                    value: '${medicine.durationDays} أيام',
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                // Frequency
                Expanded(
                  child: _InfoChip(
                    label: 'التكرار',
                    value: medicine.frequency,
                    icon: Icons.repeat_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyles.labelMedium,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(label, style: AppTextStyles.captionText),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: AppDimensions.iconS, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
