import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/data/repositories/appointments_repository.dart';
import '../../../../shared/data/models/appointment_model.dart'; // اتأكد إن ده مسار الموديل عندك
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final AppointmentsRepository _repository = AppointmentsRepository();
  StreamSubscription? _subscription;

  // 1. تعريف المتغير على مستوى الكلاس عشان كل الدوال تشوفه
  List<AppointmentModel> _allAppointments = [];

  ScheduleCubit() : super(const ScheduleInitial());

  void loadSchedule(String doctorId) {
    emit(const ScheduleLoading());
    try {
      _subscription?.cancel();
      _subscription = _repository.getDoctorAppointments(doctorId).listen(
              (appointments) {
            // 2. حفظ الداتا في المتغير عند كل تحديث من الفايربيز
            _allAppointments = appointments;

            // 3. عرض مواعيد "اليوم" كحالة أولية
            selectDate(DateTime.now());
          },
          onError: (error) {
            emit(ScheduleError('حصلت مشكلة في جلب المواعيد: $error'));
          }
      );
    } catch (e) {
      emit(ScheduleError('خطأ غير متوقع: $e'));
    }
  }

  void selectDate(DateTime date) {
    // 4. دلوقت الـ _allAppointments معرف وشغال زي الفل
    final filteredAppointments = _allAppointments.where((app) =>
    app.dateTime.year == date.year &&
        app.dateTime.month == date.month &&
        app.dateTime.day == date.day
    ).toList();

    emit(ScheduleLoaded(
      selectedDate: date,
      appointments: filteredAppointments,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}