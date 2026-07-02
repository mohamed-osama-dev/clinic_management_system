// Placeholder stub for doctor patients cubit.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_patients_state.dart';

class DoctorPatientsCubit extends Cubit<PatientsState> {
  DoctorPatientsCubit() : super(const PatientsInitial());

  // ── Dummy Data (Developer 4 replaces with Firestore) ──────────────────────

  static const _dummyPatients = [
    PatientModel(
      id: '1',
      name: 'فاطمة الشمري',
      age: 42,
      condition: 'متابعة ضغط الدم',
      lastVisit: '27 أبريل 2026',
      visitsCount: 8,
    ),
    PatientModel(
      id: '2',
      name: 'محمد العتيبي',
      age: 35,
      condition: 'كشف أولي',
      lastVisit: '20 أبريل 2026',
      visitsCount: 1,
    ),
    PatientModel(
      id: '3',
      name: 'نورة القحطاني',
      age: 28,
      condition: 'تحاليل دم',
      lastVisit: '15 أبريل 2026',
      visitsCount: 4,
    ),
    PatientModel(
      id: '4',
      name: 'خالد السبيعي',
      age: 56,
      condition: 'استشارة',
      lastVisit: '10 أبريل 2026',
      visitsCount: 12,
    ),
    PatientModel(
      id: '5',
      name: 'ريم الدوسري',
      age: 31,
      condition: 'متابعة سكري',
      lastVisit: '5 أبريل 2026',
      visitsCount: 6,
    ),
    PatientModel(
      id: '6',
      name: 'سارة المطيري',
      age: 45,
      condition: 'استشارة',
      lastVisit: '1 أبريل 2026',
      visitsCount: 3,
    ),
  ];

  // ── Methods ───────────────────────────────────────────────────────────────

  Future<void> loadPatients() async {
    emit(const PatientsLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    emit(const PatientsLoaded(
      patients: _dummyPatients,
      filteredPatients: _dummyPatients,
      searchQuery: '',
    ));
  }

  void search(String query) {
    final current = state;
    if (current is! PatientsLoaded) return;

    final filtered = query.isEmpty
        ? current.patients
        : current.patients
            .where((p) => p.name.contains(query) || p.condition.contains(query))
            .toList();

    emit(current.copyWith(
      filteredPatients: filtered,
      searchQuery: query,
    ));
  }
}
