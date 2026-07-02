import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/features/doctor/schedule/presentation/cubits/schedule_state.dart';

class ScheduleAppointmentCard extends StatelessWidget {
  const ScheduleAppointmentCard({
    required this.appointment,
    super.key,
  });

  final ScheduleAppointment appointment;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = _statusInfo(appointment.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.radiusM),
                  bottomRight: Radius.circular(AppDimensions.radiusM),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Row(
                  children: [
                    // Patient avatar
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

                    // Name + type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            appointment.patientName,
                            style: AppTextStyles.labelLarge,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                appointment.type,
                                style: AppTextStyles.bodySmall,
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.location_on_outlined,
                                size: AppDimensions.iconS,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${appointment.durationMinutes} د',
                                style: AppTextStyles.captionText,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.timelapse_rounded,
                                size: AppDimensions.iconS,
                                color: AppColors.textHint,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingM),

                    // Time + status
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusLabel,
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: statusColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appointment.time,
                          style: AppTextStyles.h4
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _statusInfo(ScheduleStatus status) => switch (status) {
        ScheduleStatus.confirmed => ('مؤكد', AppColors.success),
        ScheduleStatus.pending => ('قيد الانتظار', AppColors.warning),
        ScheduleStatus.cancelled => ('ملغى', AppColors.error),
      };
}
