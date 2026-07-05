// Path: lib/features/patient/medical_records/domain/entities/medical_file_entity.dart

class MedicalFileEntity {
  final String id;
  final String name;
  final String type; // 'lab', 'xray', 'report', 'prescription'
  final DateTime date;
  final double sizeMb;

  const MedicalFileEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.date,
    required this.sizeMb,
  });
}