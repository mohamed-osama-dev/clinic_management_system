// Path: lib/features/patient/doctor_profile/domain/entities/doctor_entity.dart

class DoctorEntity {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int experience;
  final int patients;
  final int sessionMinutes;
  final double price;
  final String location;
  final String bio;
  final String imageUrl;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.patients,
    required this.sessionMinutes,
    required this.price,
    required this.location,
    required this.bio,
    required this.imageUrl,
  });
}