import 'dart:async';
import 'package:flutter/foundation.dart'; // عشان نستخدم debugPrint
import 'package:flutter_bloc/flutter_bloc.dart';

// ── التعديل الأول: استخدام المسارات الكاملة بدل النسبية ──
import 'package:clinic_management_system/features/shared/data/models/appointment_model.dart';
// اتأكد إن مسار الريبوزيتوري ده مطابق للمكان اللي حطيته فيه

import '../../../../shared/data/repositories/appointments_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AppointmentsRepository _repository = AppointmentsRepository();
  StreamSubscription? _subscription;

  DashboardCubit() : super(const DashboardInitial());

  void loadDashboard(String doctorId, String doctorName) {
    emit(const DashboardLoading());

    try {
      _subscription?.cancel();

      _subscription = _repository.getDoctorAppointments(doctorId).listen(
              (appointments) {
            final now = DateTime.now();

            final todayAppointments = appointments.where((app) =>
            app.dateTime.year == now.year &&
                app.dateTime.month == now.month &&
                app.dateTime.day == now.day &&
                (app.status == AppointmentStatus.confirmed || app.status == AppointmentStatus.completed)
            ).toList();

            final newRequests = appointments.where((app) =>
            app.status == AppointmentStatus.pending
            ).toList();

            final todayCount = todayAppointments.length;
            final uniquePatients = todayAppointments.map((e) => e.patientId).toSet().length;
            final revenue = todayCount * 200.0;

            emit(DashboardLoaded(
              doctorName: 'د. $doctorName',
              stats: DashboardStats(
                revenue: revenue,
                appointments: todayCount,
                todayPatients: uniquePatients,
              ),
              todaySchedule: todayAppointments,
              newRequests: newRequests,
            ));
          },
          onError: (error) {
            debugPrint('Error loading dashboard: $error');
          }
      );
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }
  }

  Future<void> acceptRequest(String appointmentId) async {
    try {
      await _repository.updateAppointmentStatus(appointmentId, AppointmentStatus.confirmed);
    } catch (e) {
      debugPrint('Error accepting request: $e');
    }
  }

  Future<void> rejectRequest(String appointmentId) async {
    try {
      await _repository.updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
    } catch (e) {
      debugPrint('Error rejecting request: $e');
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}