enum UserRole { patient, doctor }

class AppUserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  // بيانات خاصة بالدكتور
  final String? specialization;
  final double? consultationFee;

  // بيانات خاصة بالمريض
  final String? bloodType;
  final double? weight;
  final int? age;

  AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.specialization,
    this.consultationFee,
    this.bloodType,
    this.weight,
    this.age,
  });

  // تحويل البيانات لـ Map عشان نرفعها لـ Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'specialization': specialization,
      'consultationFee': consultationFee,
      'bloodType': bloodType,
      'weight': weight,
      'age': age,
    };
  }

  // تحويل البيانات اللي جاية من Firebase لـ Object
  factory AppUserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
      specialization: map['specialization'],
      consultationFee: map['consultationFee']?.toDouble(),
      bloodType: map['bloodType'],
      weight: map['weight']?.toDouble(),
      age: map['age']?.toInt(),
    );
  }
}