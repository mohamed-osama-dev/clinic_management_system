// Placeholder stub for schedule appointment tile widget.
import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import '../../../dashboard/presentation/cubits/dashboard_state.dart';

class ScheduleAppointmentTile extends StatelessWidget {
  const ScheduleAppointmentTile({
    required this.appointment,
    super.key,
  });

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
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

          // Info
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
                  appointment.type,
                  style: AppTextStyles.bodySmall,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),

          // Time + Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: AppDimensions.iconS,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    appointment.time,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _StatusBadge(status: appointment.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = switch (status) {
      AppointmentStatus.confirmed => (
          'مؤكد',
          AppColors.success,
          AppColors.success.withOpacity(0.1),
        ),
      AppointmentStatus.pending => (
          'قيد الانتظار',
          AppColors.warning,
          AppColors.warning.withOpacity(0.1),
        ),
      AppointmentStatus.cancelled => (
          'ملغى',
          AppColors.error,
          AppColors.error.withOpacity(0.1),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
