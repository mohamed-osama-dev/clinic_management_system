import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';

import '../../../dashboard/presentation/cubits/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubits/dashboard_state.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('جدول المواعيد', style: AppTextStyles.h3),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            // هنا الفلترة الحقيقية اللي إنت بتشتكي منها
            final filteredAppointments = state.todaySchedule.where((app) {
              return app.dateTime.year == _selectedDate.year &&
                  app.dateTime.month == _selectedDate.month &&
                  app.dateTime.day == _selectedDate.day;
            }).toList();

            return Column(
              children: [
                _buildCalendarHeader(),
                Expanded(
                  child: filteredAppointments.isEmpty
                      ? const Center(child: Text('لا توجد مواعيد في هذا اليوم'))
                      : ListView.builder(
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final app = filteredAppointments[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(app.patientId), // أو الاسم لو متاح في الموديل
                          subtitle: Text("${app.dateTime.hour}:${app.dateTime.minute}"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('حدث خطأ في تحميل البيانات'));
        },
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 14, // أسبوعين مثلاً
          itemBuilder: (context, index) {
            final dayDate = DateTime.now().add(Duration(days: index));
            final isSelected = _selectedDate.day == dayDate.day;
            return GestureDetector(
              onTap: () => setState(() => _selectedDate = dayDate),
              child: Container(
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${dayDate.day}', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}