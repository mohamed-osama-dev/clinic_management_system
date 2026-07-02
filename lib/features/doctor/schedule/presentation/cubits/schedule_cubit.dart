// Placeholder stub for doctor schedule cubit.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(const ScheduleInitial());

  // ── Dummy Data (Developer 4 replaces with Firestore) ──────────────────────

  static final _dummyAppointments = {
    // Monday April 27
    '2026-04-27': const [
      ScheduleAppointment(
        id: '1',
        patientName: 'فاطمة الشمري',
        time: '09:00',
        type: 'متابعة ضغط الدم',
        durationMinutes: 30,
        status: ScheduleStatus.confirmed,
      ),
      ScheduleAppointment(
        id: '2',
        patientName: 'محمد العتيبي',
        time: '10:30',
        type: 'كشف أولي',
        durationMinutes: 30,
        status: ScheduleStatus.pending,
      ),
      ScheduleAppointment(
        id: '3',
        patientName: 'نورة القحطاني',
        time: '11:30',
        type: 'نتائج تحاليل',
        durationMinutes: 30,
        status: ScheduleStatus.confirmed,
      ),
      ScheduleAppointment(
        id: '4',
        patientName: 'خالد السبيعي',
        time: '01:00',
        type: 'استشارة',
        durationMinutes: 30,
        status: ScheduleStatus.confirmed,
      ),
      ScheduleAppointment(
        id: '5',
        patientName: 'ريم الدوسري',
        time: '03:30',
        type: 'متابعة',
        durationMinutes: 30,
        status: ScheduleStatus.confirmed,
      ),
    ],
  };

  // ── Methods ───────────────────────────────────────────────────────────────

  Future<void> loadSchedule({DateTime? date}) async {
    final target = date ?? DateTime.now();
    emit(const ScheduleLoading());
    await Future.delayed(const Duration(milliseconds: 600));

    final key =
        '${target.year}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}';

    final appointments = _dummyAppointments[key] ?? [];

    emit(ScheduleLoaded(selectedDate: target, appointments: appointments));
  }

  void selectDate(DateTime date) {
    final current = state;
    if (current is ScheduleLoaded) {
      emit(current.copyWith(selectedDate: date));
      loadSchedule(date: date);
    }
  }
}
