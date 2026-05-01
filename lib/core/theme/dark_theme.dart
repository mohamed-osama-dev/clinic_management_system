import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DarkTheme {
  const DarkTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
    );
  }
}
