// Placeholder stub for doctor dashboard cubit.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardInitial());

  // ── Dummy Data (Developer 4 will replace with Firestore) ──────────────────

  static const _dummyStats = DashboardStats(
    revenue: 3200,
    appointments: 18,
    todayPatients: 12,
  );

  static const _dummySchedule = [
    AppointmentModel(
      id: '1',
      patientName: 'فاطمة الشمري',
      time: '09:00 ص',
      type: 'متابعة ضغط الدم',
      status: AppointmentStatus.confirmed,
    ),
    AppointmentModel(
      id: '2',
      patientName: 'محمد العتيبي',
      time: '10:30 ص',
      type: 'كشف أولي',
      status: AppointmentStatus.pending,
    ),
    AppointmentModel(
      id: '3',
      patientName: 'نورة القحطاني',
      time: '11:30 ص',
      type: 'نتائج تحاليل',
      status: AppointmentStatus.confirmed,
    ),
  ];

  static const _dummyRequests = [
    AppointmentModel(
      id: '4',
      patientName: 'سارة المطيري',
      time: '02:30 م',
      type: 'استشارة',
      status: AppointmentStatus.pending,
    ),
  ];

  // ── Methods ───────────────────────────────────────────────────────────────

  Future<void> loadDashboard() async {
    emit(const DashboardLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(const DashboardLoaded(
      doctorName: 'د. أحمد العلي',
      stats: _dummyStats,
      todaySchedule: _dummySchedule,
      newRequests: _dummyRequests,
    ));
  }

  void acceptRequest(String appointmentId) {
    final current = state;
    if (current is! DashboardLoaded) return;

    final updatedRequests = current.newRequests
        .where((a) => a.id != appointmentId)
        .toList();

    emit(DashboardLoaded(
      doctorName: current.doctorName,
      stats: current.stats,
      todaySchedule: current.todaySchedule,
      newRequests: updatedRequests,
    ));
  }

  void rejectRequest(String appointmentId) {
    final current = state;
    if (current is! DashboardLoaded) return;

    final updatedRequests = current.newRequests
        .where((a) => a.id != appointmentId)
        .toList();

    emit(DashboardLoaded(
      doctorName: current.doctorName,
      stats: current.stats,
      todaySchedule: current.todaySchedule,
      newRequests: updatedRequests,
    ));
  }
}
