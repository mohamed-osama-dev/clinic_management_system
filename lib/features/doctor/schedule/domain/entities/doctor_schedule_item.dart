import 'package:equatable/equatable.dart';

class DoctorScheduleItem extends Equatable {
  const DoctorScheduleItem({
    required this.id,
    required this.patientName,
    required this.slotIso,
  });

  final String id;
  final String patientName;
  final String slotIso;

  @override
  List<Object?> get props => [id, patientName, slotIso];
}
