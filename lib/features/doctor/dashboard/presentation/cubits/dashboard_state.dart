import 'package:equatable/equatable.dart';

// ── استدعاء الموديل الحقيقي بدل الوهمي ──
import 'package:clinic_management_system/features/shared/data/models/appointment_model.dart';

// ── Models ──────────────────────────────────────────────────────────────

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

// تم حذف AppointmentModel و AppointmentStatus الوهميين من هنا

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