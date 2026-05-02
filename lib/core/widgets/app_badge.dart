import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

enum AppBadgeType { confirmed, pending, cancelled, custom }

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    required this.type,
    this.customColor,
    super.key,
  });

  final String label;
  final AppBadgeType type;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _bgColor;
    final Color textColor = _textColor;
    final Color dotColor = _dotColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.labelMedium.copyWith(color: textColor)),
          const SizedBox(width: 6.0),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Color get _bgColor {
    switch (type) {
      case AppBadgeType.confirmed:
        return const Color(0xFFE8F8F6);
      case AppBadgeType.pending:
        return const Color(0xFFFEF3C7);
      case AppBadgeType.cancelled:
        return const Color(0xFFFEE2E2);
      case AppBadgeType.custom:
        return customColor ?? AppColors.primaryLight;
    }
  }

  Color get _textColor {
    switch (type) {
      case AppBadgeType.confirmed:
        return const Color(0xFF00B09B);
      case AppBadgeType.pending:
        return const Color(0xFFD97706);
      case AppBadgeType.cancelled:
        return const Color(0xFFEF4444);
      case AppBadgeType.custom:
        return customColor ?? AppColors.primary;
    }
  }

  Color get _dotColor {
    switch (type) {
      case AppBadgeType.confirmed:
        return const Color(0xFF00B09B);
      case AppBadgeType.pending:
        return const Color(0xFFD97706);
      case AppBadgeType.cancelled:
        return const Color(0xFFEF4444);
      case AppBadgeType.custom:
        return customColor ?? AppColors.primary;
    }
  }
}