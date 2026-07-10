import 'package:clinic_management_system/features/patient/doctor_profile/domain/entities/doctor_entity.dart';
import 'package:clinic_management_system/features/patient/doctor_profile/presentation/screens/doctor_profile_screen.dart';
import 'package:clinic_management_system/features/patient/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            SliverToBoxAdapter(child: _buildFeaturedDoctors(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          String patientName = 'مريض';
          String firstLetter = 'م';

          if (state is AuthAuthenticated) {
            patientName = state.user.name;
            firstLetter = patientName.isNotEmpty ? patientName.substring(0, 1) : 'م';
          } else {
            // Fallback عشان لو الستيت مش Authenticated يقرأ برضه صح
            final fallbackUser = context.read<AuthCubit>().currentUser;
            if (fallbackUser != null) {
              patientName = fallbackUser.name;
              firstLetter = patientName.isNotEmpty ? patientName.substring(0, 1) : 'م';
            }
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('مرحباً 👋', style: AppTextStyles.bodyMedium),
                      Text(patientName, style: AppTextStyles.h3),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: Text(firstLetter, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textHint, size: 20),
              const SizedBox(width: 8),
              Text('ابحث عن طبيب...', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedDoctors(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text('أطباء مميزون', style: AppTextStyles.h3),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'doctor')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('لا يوجد أطباء متاحين حالياً', style: AppTextStyles.bodyMedium)
                );
              }

              final docs = snapshot.data!.docs;
              final doctors = docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return DoctorEntity(
                  id: doc.id,
                  name: 'د. ${data['name'] ?? 'طبيب'}',
                  specialty: data['specialization'] ?? 'تخصص عام',
                  location: 'عيادة أمل',
                  price: 200.0,
                  bio: data['bio'] ?? 'طبيب متخصص ومتميز في مجاله.',
                  experience: (data['yearsOfExperience'] as num?)?.toInt() ?? 5,
                  imageUrl: data['avatarUrl'] ?? '',
                  patients: 120,
                  rating: 4.8,
                  reviewCount: 45,
                  sessionMinutes: 30,
                );
              }).toList();

              return ListView.separated(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: doctors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _DoctorCard(doctor: doctors[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctor))),
      child: Container(
        width: 160,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Container(
                height: 100,
                decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                ),
                child: const Icon(Icons.person, size: 50, color: AppColors.primary)
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(doctor.name, style: AppTextStyles.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(doctor.specialty, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}