// Placeholder stub for doctor prescription state.
import 'package:equatable/equatable.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class MedicineModel extends Equatable {
  const MedicineModel({
    required this.id,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.durationDays,
    this.notes,
  });

  final String id;
  final String name;
  final String dose;
  final String frequency;
  final int durationDays;
  final String? notes;

  MedicineModel copyWith({
    String? id,
    String? name,
    String? dose,
    String? frequency,
    int? durationDays,
    String? notes,
  }) =>
      MedicineModel(
        id: id ?? this.id,
        name: name ?? this.name,
        dose: dose ?? this.dose,
        frequency: frequency ?? this.frequency,
        durationDays: durationDays ?? this.durationDays,
        notes: notes ?? this.notes,
      );

  @override
  List<Object?> get props => [id, name, dose, frequency, durationDays, notes];
}

class PrescriptionPatient extends Equatable {
  const PrescriptionPatient({
    required this.id,
    required this.name,
    required this.date,
  });

  final String id;
  final String name;
  final String date;

  @override
  List<Object?> get props => [id, name, date];
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class PrescriptionState extends Equatable {
  const PrescriptionState();

  @override
  List<Object?> get props => [];
}

class PrescriptionInitial extends PrescriptionState {
  const PrescriptionInitial();
}

class PrescriptionLoaded extends PrescriptionState {
  const PrescriptionLoaded({
    required this.patient,
    required this.medicines,
    required this.generalNotes,
    required this.isSending,
    required this.isSent,
  });

  final PrescriptionPatient patient;
  final List<MedicineModel> medicines;
  final String generalNotes;
  final bool isSending;
  final bool isSent;

  PrescriptionLoaded copyWith({
    PrescriptionPatient? patient,
    List<MedicineModel>? medicines,
    String? generalNotes,
    bool? isSending,
    bool? isSent,
  }) =>
      PrescriptionLoaded(
        patient: patient ?? this.patient,
        medicines: medicines ?? this.medicines,
        generalNotes: generalNotes ?? this.generalNotes,
        isSending: isSending ?? this.isSending,
        isSent: isSent ?? this.isSent,
      );

  @override
  List<Object?> get props =>
      [patient, medicines, generalNotes, isSending, isSent];
}
