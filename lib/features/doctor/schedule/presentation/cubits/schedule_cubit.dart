import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: اعمل import لملف appointments_repository.dart و appointment_model.dart بالمسار بتاعك
import '../../../../shared/data/repositories/appointments_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  // أخدنا نسخة من الـ Repo عشان نكلم فايربيز
  final AppointmentsRepository _repository = AppointmentsRepository();
  StreamSubscription? _subscription;

  ScheduleCubit() : super(ScheduleInitial());

  // ضفنا المتغير هنا
  void loadSchedule(String doctorId) {
    emit(const ScheduleLoading());
    try {
      _subscription?.cancel();
      // باصينا المتغير الحقيقي للـ Repository
      _subscription = _repository.getDoctorAppointments(doctorId).listen(
              (appointments) {
            emit(ScheduleLoaded(
              appointments: appointments,
              selectedDate: DateTime.now(),
            ));
          },
          onError: (error) {
            emit(ScheduleError('حصلت مشكلة في جلب المواعيد: $error'));
          }
      );
    } catch (e) {
      emit(ScheduleError('خطأ غير متوقع: $e'));
    }
  }

  // دالة عشان لما الدكتور يختار يوم تاني من الكاليندر
  void selectDate(DateTime date) {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      emit(ScheduleLoaded(
        appointments: currentState.appointments,
        selectedDate: date,
      ));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel(); // لازم نقفل الـ Stream عشان الـ Memory leak
    return super.close();
  }
}