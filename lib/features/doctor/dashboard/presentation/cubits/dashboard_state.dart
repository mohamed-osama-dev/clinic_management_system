// Placeholder stub for doctor dashboard state.
import 'package:equatable/equatable.dart';

// ── Dummy Models ──────────────────────────────────────────────────────────────

class DashboardStats extends Equatable {
  const DashboardStats({
    required this.revenue,
    required this.appointments,
    required this.todayPatients,
  });

  final double revenue;
  final int appointments;
  final int todayPatients;

  @override
  List<Object?> get props => [revenue, appointments, todayPatients];
}

class AppointmentModel extends Equatable {
  const AppointmentModel({
    required this.id,
    required this.patientName,
    required this.time,
    required this.type,
    required this.status,
    this.patientImageUrl,
  });

  final String id;
  final String patientName;
  final String time;
  final String type;
  final AppointmentStatus status;
  final String? patientImageUrl;

  @override
  List<Object?> get props => [id, patientName, time, type, status];
}

enum AppointmentStatus { confirmed, pending, cancelled }

// ── States ────────────────────────────────────────────────────────────────────

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    required this.doctorName,
    required this.stats,
    required this.todaySchedule,
    required this.newRequests,
  });

  final String doctorName;
  final DashboardStats stats;
  final List<AppointmentModel> todaySchedule;
  final List<AppointmentModel> newRequests;

  @override
  List<Object?> get props => [doctorName, stats, todaySchedule, newRequests];
}

class DashboardError extends DashboardState {
  const DashboardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
