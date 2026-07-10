import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientBottomNav extends StatelessWidget {
  const PatientBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final Function(int) onTap;

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'مواعيدي'),
    BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'المحادثات'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'البروفايل'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: _items,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }
}

class DoctorBottomNav extends StatelessWidget {
  const DoctorBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final Function(int) onTap;

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'الجدول'),
    BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'المحادثات'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'البروفايل'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: _items,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }
}