import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/widgets/app_bottom_nav.dart';

import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';
import '../widgets/weekly_calendar_strip.dart';
import '../widgets/schedule_appointment_card.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>().loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: DoctorBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navigate to add appointment
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading || state is ScheduleInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ScheduleError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.bodyMedium),
            );
          }

          if (state is ScheduleLoaded) {
            return _ScheduleBody(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Schedule Body ─────────────────────────────────────────────────────────────

class _ScheduleBody extends StatelessWidget {
  const _ScheduleBody({required this.state});

  final ScheduleLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── App Bar ────────────────────────────────────────────────────────
        _ScheduleAppBar(date: state.selectedDate),

        // ── Weekly Calendar ────────────────────────────────────────────────
        WeeklyCalendarStrip(
          selectedDate: state.selectedDate,
          onDateSelected: (date) =>
              context.read<ScheduleCubit>().selectDate(date),
        ),

        // ── Appointments count ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _formatDate(state.selectedDate),
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                '${state.appointments.length} مواعيد',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),

        // ── Appointments List ──────────────────────────────────────────────
        Expanded(
          child: state.appointments.isEmpty
              ? _EmptySchedule()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  itemCount: state.appointments.length,
                  itemBuilder: (context, i) => ScheduleAppointmentCard(
                    appointment: state.appointments[i],
                  ),
                ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const days = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس',
      'الجمعة', 'السبت', 'الأحد',
    ];
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────

class _ScheduleAppBar extends StatelessWidget {
  const _ScheduleAppBar({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_list_rounded,
                color: AppColors.textSecondary,
              ),
            ),
            Text('جدول المواعيد', style: AppTextStyles.h3),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptySchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'لا توجد مواعيد في هذا اليوم',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
