// Path: lib/features/doctor/doctor_main_shell.dart
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/widgets/app_bottom_nav.dart';
import 'package:clinic_management_system/features/doctor/dashboard/presentation/pages/doctor_dashboard_screen2.dart';
import 'package:clinic_management_system/features/doctor/profile/presentation/pages/doctor_settings_screen.dart';
import 'package:clinic_management_system/features/doctor/schedule/presentation/pages/doctor_schedule_screen2.dart';
import 'package:clinic_management_system/features/doctor/patients/presentation/pages/doctor_patients_screen2.dart';
import 'package:flutter/material.dart';

class DoctorSettingsPlaceholder extends StatelessWidget {
  const DoctorSettingsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الإعدادات'));
  }
}

class DoctorMainShell extends StatefulWidget {
  const DoctorMainShell({super.key});

  @override
  State<DoctorMainShell> createState() => _DoctorMainShellState();
}

class _DoctorMainShellState extends State<DoctorMainShell> {
  int _currentIndex = 0; // هنبدأ باللوحة

  // الترتيب الصحيح حسب الـ Index بتاعك
  final List<Widget> _screens = [
    const DoctorDashboardScreen(),     // Index 0: اللوحة
    const DoctorScheduleScreen(),      // Index 1: الجدول
    const DoctorPatientsScreen(),      // Index 2: المرضى
    const DoctorSettingsScreen(),      // Index 3: الإعدادات (تم التعديل هنا)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: DoctorBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}