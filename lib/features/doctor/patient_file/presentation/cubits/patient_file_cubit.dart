import 'package:flutter_bloc/flutter_bloc.dart';
import 'patient_file_state.dart';

class PatientFileCubit extends Cubit<PatientFileState> {
  PatientFileCubit() : super(const PatientFileInitial());

  // ── Dummy Data (Developer 4 replaces with Firestore) ──────────────────────

  static const _dummyPatient = PatientFileInfo(
    id: '1',
    name: 'فاطمة الشمري',
    age: 42,
    gender: 'أنثى',
    lastVisit: '15 أبريل 2026',
    visitsCount: 8,
    prescriptionsCount: 12,
    testsCount: 5,
    healthCondition: HealthCondition(
      bloodPressure: '130/85',
      bloodSugar: 'mg/dL 110',
      weight: 'كجم 68',
      allergies: 'البنسلين',
    ),
    previousVisits: [
      PreviousVisit(
        id: '1',
        title: 'متابعة ضغط الدم',
        date: '15 أبريل 2026 - الخميس، مدة ملحوظة',
        type: VisitType.followUp,
      ),
      PreviousVisit(
        id: '2',
        title: 'كشف دوري',
        date: '02 مارس 2026 - ثلاثاء قيمة طبيعية',
        type: VisitType.checkup,
      ),
      PreviousVisit(
        id: '3',
        title: 'استشارة',
        date: '18 يناير 2026 - وصف، علاج',
        type: VisitType.consultation,
      ),
    ],
  );

  // ── Methods ───────────────────────────────────────────────────────────────

  Future<void> loadPatientFile({String? patientId}) async {
    emit(const PatientFileLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    // Developer 4 will replace with Firestore fetch by patientId
    emit(const PatientFileLoaded(patient: _dummyPatient));
  }
}
