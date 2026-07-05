// Placeholder stub for today schedule list widget.
import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import '../../../../shared/data/models/appointment_model.dart';
import '../../../dashboard/presentation/cubits/dashboard_state.dart';
import 'schedule_appointment_tile.dart';

class TodayScheduleList extends StatelessWidget {
  const TodayScheduleList({
    required this.appointments,
    required this.onViewAll,
    super.key,
  });

  final List<AppointmentModel> appointments;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('عرض الكل', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
              ),
              Text('جدول اليوم', style: AppTextStyles.h4),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),

        // List
        if (appointments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Text(
              'لا توجد مواعيد اليوم',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: Column(
              children: appointments
                  .map((a) => ScheduleAppointmentTile(appointment: a))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
