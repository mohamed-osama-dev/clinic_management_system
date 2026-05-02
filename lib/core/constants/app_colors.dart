import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF00B09B);
  static const Color primaryLight = Color(0xFFE8F8F6);
  static const Color primaryDark = Color(0xFF008F7A);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE5E7EB);

  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
}