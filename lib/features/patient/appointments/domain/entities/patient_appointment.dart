// Path: lib/features/patient/appointments/domain/entities/patient_appointment.dart

import 'package:clinic_management_system/features/patient/doctor_profile/domain/entities/doctor_entity.dart';

class PatientAppointment {
  final String id;
  final DoctorEntity doctor;
  final DateTime dateTime;
  final bool isOnline;
  final String status; // 'confirmed', 'pending', 'cancelled'
  final String location;
  final double price;

  const PatientAppointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.isOnline,
    required this.status,
    required this.location,
    required this.price,
  });
}