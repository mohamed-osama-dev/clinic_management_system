import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

import '../../../../shared/data/models/appointment_model.dart';

class ScheduleAppointmentCard extends StatelessWidget {
  const ScheduleAppointmentCard({
    required this.appointment,
    super.key,
  });

  // التعديل 2: استخدام AppointmentModel
  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = _statusInfo(appointment.status);

    // استخراج الوقت من الـ DateTime وتنسيقه (ص / م)
    String period = appointment.dateTime.hour >= 12 ? 'م' : 'ص';
    int hour12 = appointment.dateTime.hour > 12
        ? appointment.dateTime.hour - 12
        : (appointment.dateTime.hour == 0 ? 12 : appointment.dateTime.hour);
    String timeString = '$hour12:${appointment.dateTime.minute.toString().padLeft(2, '0')} $period';

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
                        // بياخد أول حرف من اسم المريض
                        appointment.patientName.isNotEmpty ? appointment.patientName.substring(0, 1) : 'م',
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
                            appointment.patientName, // الاسم الحقيقي
                            style: AppTextStyles.labelLarge,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                appointment.type, // نوع الكشف الحقيقي
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
                                '${appointment.durationMinutes} د', // المدة الحقيقية
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
                            // التعديل 3: حل تحذير الـ Opacity هنا
                            color: statusColor.withValues(alpha: 0.1),
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
                          timeString,
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

  // التعديل 4: استخدام AppointmentStatus الحقيقي
  (String, Color) _statusInfo(AppointmentStatus status) => switch (status) {
    AppointmentStatus.confirmed => ('مؤكد', AppColors.success),
    AppointmentStatus.pending => ('قيد الانتظار', AppColors.warning),
    AppointmentStatus.cancelled => ('ملغى', AppColors.error),
    AppointmentStatus.completed => ('مكتمل', Colors.blue),
  };
}