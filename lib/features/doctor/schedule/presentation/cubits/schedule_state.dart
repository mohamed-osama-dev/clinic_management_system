// Path: lib/features/doctor/schedule/presentation/cubits/schedule_state.dart

import 'package:equatable/equatable.dart';
// TODO: اعمل import لمسار الـ AppointmentModel الصح بتاعك
import '../../../../shared/data/models/appointment_model.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleLoaded extends ScheduleState {
  final List<AppointmentModel> appointments;
  final DateTime selectedDate;

  const ScheduleLoaded({
    required this.appointments,
    required this.selectedDate,
  });

  // بنفلتر المواعيد عشان نعرض مواعيد اليوم المتحدد بس في الشاشة
  List<AppointmentModel> get todayAppointments {
    return appointments.where((app) =>
    app.dateTime.year == selectedDate.year &&
        app.dateTime.month == selectedDate.month &&
        app.dateTime.day == selectedDate.day
    ).toList();
  }

  @override
  List<Object> get props => [appointments, selectedDate];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object> get props => [message];
}