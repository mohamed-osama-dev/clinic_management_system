import 'package:equatable/equatable.dart';

class PatientAppointment extends Equatable {
  const PatientAppointment({
    required this.id,
    required this.doctorName,
    required this.dateIso,
  });

  final String id;
  final String doctorName;
  final String dateIso;

  @override
  List<Object?> get props => [id, doctorName, dateIso];
}
