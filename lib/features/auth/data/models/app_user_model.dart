import 'package:clinic_management_system/features/auth/domain/entities/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.isEmailVerified = false,
    super.phone,
    super.avatarUrl,
    super.specialization, // تم التعديل هنا
    super.licenseNumber,
    super.yearsOfExperience,
    super.isProfileComplete = false,
    super.createdAt,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      role: (map['role'] as String) == UserRole.doctor.name
          ? UserRole.doctor
          : UserRole.patient,
      isEmailVerified: (map['isEmailVerified'] as bool?) ?? false,
      phone: map['phone'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      specialization: map['specialization'] as String?, // تم التعديل هنا
      licenseNumber: map['licenseNumber'] as String?,
      yearsOfExperience: (map['yearsOfExperience'] as num?)?.toInt(),
      isProfileComplete: (map['isProfileComplete'] as bool?) ?? false,
      createdAt: map['createdAt'] as DateTime?,
    );
  }

  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};

    return AppUserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
      isEmailVerified: data['isEmailVerified'] ?? false,
      phone: data['phone'],
      avatarUrl: data['avatarUrl'],
      specialization: data['specialization'], // تم التعديل هنا
      licenseNumber: data['licenseNumber'],
      yearsOfExperience: (data['yearsOfExperience'] as num?)?.toInt(),
      isProfileComplete: data['isProfileComplete'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'isEmailVerified': isEmailVerified,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'specialization': specialization, // تم التعديل هنا
      'licenseNumber': licenseNumber,
      'yearsOfExperience': yearsOfExperience,
      'isProfileComplete': isProfileComplete,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'name': name,
    'role': role.name,
    'isEmailVerified': isEmailVerified,
    'phone': phone,
    'avatarUrl': avatarUrl,
    'specialization': specialization, // تم التعديل هنا
    'licenseNumber': licenseNumber,
    'yearsOfExperience': yearsOfExperience,
    'isProfileComplete': isProfileComplete,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  @override
  AppUserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    bool? isEmailVerified,
    String? phone,
    String? avatarUrl,
    String? specialization, // تم التعديل هنا
    String? licenseNumber,
    int? yearsOfExperience,
    bool? isProfileComplete,
    DateTime? createdAt,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      specialization: specialization ?? this.specialization, // تم التعديل هنا
      licenseNumber: licenseNumber ?? this.licenseNumber,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}