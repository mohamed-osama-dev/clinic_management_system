class MedicalRecordModel {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final String diagnosis;
  final String prescription;

  MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.diagnosis,
    required this.prescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'prescription': prescription,
    };
  }

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicalRecordModel(
      id: documentId,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      date: DateTime.parse(map['date']),
      diagnosis: map['diagnosis'] ?? '',
      prescription: map['prescription'] ?? '',
    );
  }
}