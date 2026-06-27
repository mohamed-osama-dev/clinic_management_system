// Placeholder stub for doctor patients state.
import 'package:equatable/equatable.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class PatientModel extends Equatable {
  const PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.condition,
    required this.lastVisit,
    required this.visitsCount,
    this.imageUrl,
  });

  final String id;
  final String name;
  final int age;
  final String condition;
  final String lastVisit;
  final int visitsCount;
  final String? imageUrl;

  @override
  List<Object?> get props =>
      [id, name, age, condition, lastVisit, visitsCount];
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class PatientsState extends Equatable {
  const PatientsState();

  @override
  List<Object?> get props => [];
}

class PatientsInitial extends PatientsState {
  const PatientsInitial();
}

class PatientsLoading extends PatientsState {
  const PatientsLoading();
}

class PatientsLoaded extends PatientsState {
  const PatientsLoaded({
    required this.patients,
    required this.filteredPatients,
    required this.searchQuery,
  });

  final List<PatientModel> patients;
  final List<PatientModel> filteredPatients;
  final String searchQuery;

  PatientsLoaded copyWith({
    List<PatientModel>? patients,
    List<PatientModel>? filteredPatients,
    String? searchQuery,
  }) =>
      PatientsLoaded(
        patients: patients ?? this.patients,
        filteredPatients: filteredPatients ?? this.filteredPatients,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object?> get props => [patients, filteredPatients, searchQuery];
}

class PatientsError extends PatientsState {
  const PatientsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
