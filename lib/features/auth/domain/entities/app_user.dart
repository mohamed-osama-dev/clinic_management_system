import 'package:equatable/equatable.dart';

enum UserRole { patient, doctor }

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.isEmailVerified = false,
    this.phone,
    this.avatarUrl,
    this.specialization, // تم التعديل هنا
    this.licenseNumber,
    this.yearsOfExperience,
    this.isProfileComplete = false,
    this.createdAt,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool isEmailVerified;
  final String? phone;
  final String? avatarUrl;
  final String? specialization; // تم التعديل هنا
  final String? licenseNumber;
  final int? yearsOfExperience;
  final bool isProfileComplete;
  final DateTime? createdAt;

  AppUser copyWith({
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
    return AppUser(
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

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    isEmailVerified,
    phone,
    avatarUrl,
    specialization, // تم التعديل هنا
    licenseNumber,
    yearsOfExperience,
    isProfileComplete,
    createdAt,
  ];
}