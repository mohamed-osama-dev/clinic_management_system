// Path: lib/features/patient/main_shell.dart

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/features/patient/appointments/presentation/screens/my_appointments_screen.dart';
import 'package:clinic_management_system/features/patient/profile/presentation/screens/patient_profile_screen.dart'; // شيلنا الـ hide
import 'package:clinic_management_system/features/shared/chat/presentation/screens/chat_screen.dart'; // المسار الصحيح للشات
import 'package:flutter/material.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../common/chat/presentation/pages/chat_screen.dart';
import 'home/presentation/screens/patient_home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PatientHomeScreen(),
    const MyAppointmentsScreen(),
    const ChatScreen(),
    const PatientProfileScreen(), // دلوقتي هتقرأ الشاشة الحقيقية
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: PatientBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}