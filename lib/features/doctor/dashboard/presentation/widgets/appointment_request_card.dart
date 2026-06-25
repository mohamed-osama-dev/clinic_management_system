// Placeholder stub for appointment request card widget.
import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import '../../../dashboard/presentation/cubits/dashboard_state.dart';

class AppointmentRequestCard extends StatelessWidget {
  const AppointmentRequestCard({
    required this.appointment,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  final AppointmentModel appointment;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Patient info row
          Row(
            children: [
              CircleAvatar(
                radius: AppDimensions.avatarS / 2,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  appointment.patientName.substring(0, 1),
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      appointment.patientName,
                      style: AppTextStyles.labelLarge,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${appointment.type} • ${appointment.time}',
                      style: AppTextStyles.bodySmall,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // Accept / Reject buttons
          Row(
            children: [
              // Reject
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('رفض'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              // Accept
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('قبول'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
