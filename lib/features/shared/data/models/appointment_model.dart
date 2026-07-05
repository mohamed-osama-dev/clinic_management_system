// Path: lib/features/shared/data/models/appointment_model.dart

enum AppointmentStatus { pending, confirmed, completed, cancelled }

class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? notes;

  // الحقول الجديدة للعرض المباشر في الـ UI
  final String patientName;
  final String type;
  final int durationMinutes;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    this.status = AppointmentStatus.pending,
    this.notes,
    required this.patientName,
    this.type = 'كشف عام',
    this.durationMinutes = 30,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'dateTime': dateTime.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'patientName': patientName,
      'type': type,
      'durationMinutes': durationMinutes,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AppointmentModel(
      id: documentId,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      status: AppointmentStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      notes: map['notes'],
      patientName: map['patientName'] ?? 'مريض غير معروف',
      type: map['type'] ?? 'كشف عام',
      durationMinutes: map['durationMinutes'] ?? 30,
    );
  }
}