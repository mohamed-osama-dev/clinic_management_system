// Placeholder stub for doctor schedule state.
import 'package:equatable/equatable.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class ScheduleAppointment extends Equatable {
  const ScheduleAppointment({
    required this.id,
    required this.patientName,
    required this.time,
    required this.type,
    required this.durationMinutes,
    required this.status,
    this.patientImageUrl,
  });

  final String id;
  final String patientName;
  final String time;
  final String type;
  final int durationMinutes;
  final ScheduleStatus status;
  final String? patientImageUrl;

  @override
  List<Object?> get props =>
      [id, patientName, time, type, durationMinutes, status];
}

enum ScheduleStatus { confirmed, pending, cancelled }

// ── States ────────────────────────────────────────────────────────────────────

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleLoaded extends ScheduleState {
  const ScheduleLoaded({
    required this.selectedDate,
    required this.appointments,
  });

  final DateTime selectedDate;
  final List<ScheduleAppointment> appointments;

  ScheduleLoaded copyWith({
    DateTime? selectedDate,
    List<ScheduleAppointment>? appointments,
  }) =>
      ScheduleLoaded(
        selectedDate: selectedDate ?? this.selectedDate,
        appointments: appointments ?? this.appointments,
      );

  @override
  List<Object?> get props => [selectedDate, appointments];
}

class ScheduleError extends ScheduleState {
  const ScheduleError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
