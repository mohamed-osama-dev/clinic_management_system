import 'package:equatable/equatable.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class PatientFileInfo extends Equatable {
  const PatientFileInfo({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.lastVisit,
    required this.visitsCount,
    required this.prescriptionsCount,
    required this.testsCount,
    required this.healthCondition,
    required this.previousVisits,
    this.imageUrl,
  });

  final String id;
  final String name;
  final int age;
  final String gender;
  final String lastVisit;
  final int visitsCount;
  final int prescriptionsCount;
  final int testsCount;
  final HealthCondition healthCondition;
  final List<PreviousVisit> previousVisits;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, age, gender, lastVisit];
}

class HealthCondition extends Equatable {
  const HealthCondition({
    required this.bloodPressure,
    required this.bloodSugar,
    required this.weight,
    required this.allergies,
  });

  final String bloodPressure;
  final String bloodSugar;
  final String weight;
  final String allergies;

  @override
  List<Object?> get props => [bloodPressure, bloodSugar, weight, allergies];
}

class PreviousVisit extends Equatable {
  const PreviousVisit({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
  });

  final String id;
  final String title;
  final String date;
  final VisitType type;

  @override
  List<Object?> get props => [id, title, date, type];
}

enum VisitType { followUp, checkup, consultation }

// ── States ────────────────────────────────────────────────────────────────────

abstract class PatientFileState extends Equatable {
  const PatientFileState();

  @override
  List<Object?> get props => [];
}

class PatientFileInitial extends PatientFileState {
  const PatientFileInitial();
}

class PatientFileLoading extends PatientFileState {
  const PatientFileLoading();
}

class PatientFileLoaded extends PatientFileState {
  const PatientFileLoaded({required this.patient});

  final PatientFileInfo patient;

  @override
  List<Object?> get props => [patient];
}

class PatientFileError extends PatientFileState {
  const PatientFileError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
