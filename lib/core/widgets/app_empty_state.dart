import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.message,
    required this.icon,
    this.subtitle,
    this.action,
    super.key,
  });

  final String message;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16.0),
            Text(message, style: AppTextStyles.h3, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8.0),
              Text(subtitle!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            ],
            if (action != null) ...[
              const SizedBox(height: 32.0),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}