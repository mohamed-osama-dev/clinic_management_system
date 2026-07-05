// Path: lib/features/patient/visit_rating/presentation/screens/visit_rating_screen.dart

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/patient/doctor_profile/domain/entities/doctor_entity.dart';
import 'package:flutter/material.dart';

class VisitRatingScreen extends StatefulWidget {
  final DoctorEntity doctor;
  const VisitRatingScreen({super.key, required this.doctor});

  @override
  State<VisitRatingScreen> createState() => _VisitRatingScreenState();
}

class _VisitRatingScreenState extends State<VisitRatingScreen> {
  int _rating = 4;
  final Set<String> _selectedTags = {'الالتزام بالموعد'};
  final _commentController = TextEditingController();

  static const List<String> _ratingLabels = ['', 'سيئ', 'مقبول', 'جيد', 'جيد جداً', 'ممتاز'];
  static const List<String> _tags = ['اللطف', 'الشرح الواضح', 'الالتزام بالموعد', 'النظافة', 'الاحترافية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('تقييم الزيارة', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 52),
            ),
            const SizedBox(height: 12),
            Text(widget.doctor.name, style: AppTextStyles.h3),
            Text(widget.doctor.specialty, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 28),
            const Text('كيف كانت تجربتك مع الطبيب؟', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final star = i + 1;
                return GestureDetector(
                  onTap: () => setState(() => _rating = star),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      star <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(_rating > 0 ? _ratingLabels[_rating] : '',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerRight, child: Text('ما الذي أعجبك؟', style: AppTextStyles.h4)),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selected) _selectedTags.remove(tag);
                    else _selectedTags.add(tag);
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(tag,
                        style: AppTextStyles.labelMedium.copyWith(
                            color: selected ? AppColors.primary : AppColors.textSecondary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerRight, child: Text('اكتب تعليقك', style: AppTextStyles.h4)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'الدكتور رائع جداً وشرحه واضح، أنصح به.',
                  hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Call RatingCubit/Repository to submit data
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إرسال التقييم', style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
