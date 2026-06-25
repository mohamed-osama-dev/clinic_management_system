// Placeholder stub for stats card widget.
import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.iconBgColor,
    super.key,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color iconBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: AppDimensions.iconM),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.captionText),
        ],
      ),
    );
  }
}
