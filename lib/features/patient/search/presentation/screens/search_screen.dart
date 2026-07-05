// Path: lib/features/patient/search/presentation/screens/search_screen.dart

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/patient/doctor_profile/presentation/screens/doctor_profile_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedSpecialty = 'الكل';
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with data from SearchCubit
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'طبيب قلب...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Connect Specialty Filter with SearchCubit
            Expanded(
              child: Center(
                child: Text('ابحث عن طبيبك المفضل', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
