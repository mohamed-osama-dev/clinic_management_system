// Placeholder stub for doctor prescription cubit.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  PrescriptionCubit() : super(const PrescriptionInitial());

  static const _uuid = Uuid();

  // ── Dummy Data ────────────────────────────────────────────────────────────

  static const _dummyPatient = PrescriptionPatient(
    id: '1',
    name: 'فاطمة الشمري',
    date: '27 أبريل 2026',
  );

  static final _dummyMedicines = [
    MedicineModel(
      id: _uuid.v4(),
      name: 'باندول إكسرا',
      dose: '500mg',
      frequency: 'كل 6 ساعات',
      durationDays: 5,
    ),
    MedicineModel(
      id: _uuid.v4(),
      name: 'أسرين',
      dose: '100mg',
      frequency: 'مرة يومياً',
      durationDays: 30,
    ),
  ];

  // ── Methods ───────────────────────────────────────────────────────────────

  void loadPrescription({PrescriptionPatient? patient}) {
    emit(PrescriptionLoaded(
      patient: patient ?? _dummyPatient,
      medicines: List.from(_dummyMedicines),
      generalNotes: 'ينصح بتناول الأدوية بعد الوجبات والمتابعة بعد أسبوع.',
      isSending: false,
      isSent: false,
    ));
  }

  void addMedicine(MedicineModel medicine) {
    final current = state;
    if (current is! PrescriptionLoaded) return;
    emit(current.copyWith(
      medicines: [...current.medicines, medicine],
    ));
  }

  void removeMedicine(String medicineId) {
    final current = state;
    if (current is! PrescriptionLoaded) return;
    emit(current.copyWith(
      medicines: current.medicines.where((m) => m.id != medicineId).toList(),
    ));
  }

  void updateNotes(String notes) {
    final current = state;
    if (current is! PrescriptionLoaded) return;
    emit(current.copyWith(generalNotes: notes));
  }

  MedicineModel createEmptyMedicine() => MedicineModel(
        id: _uuid.v4(),
        name: '',
        dose: '',
        frequency: '',
        durationDays: 7,
      );

  Future<void> sendPrescription() async {
    final current = state;
    if (current is! PrescriptionLoaded) return;

    emit(current.copyWith(isSending: true));
    await Future.delayed(const Duration(seconds: 1));
    // Developer 4 will replace with Firestore send logic
    emit(current.copyWith(isSending: false, isSent: true));
  }

  Future<void> printPrescription() async {
    // Developer 4 will implement PDF generation + printing
  }
}
