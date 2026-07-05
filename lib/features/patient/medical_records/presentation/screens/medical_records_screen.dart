
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('السجلات الطبية', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.6,
              children: const [
                _CategoryCard(icon: Icons.science_outlined, label: 'التحاليل', count: 8, color: Color(0xFF06B6D4)),
                _CategoryCard(icon: Icons.image_outlined, label: 'الأشعة', count: 3, color: Color(0xFF8B5CF6)),
                _CategoryCard(icon: Icons.description_outlined, label: 'الوصفات', count: 12, color: Color(0xFFF59E0B)),
                _CategoryCard(icon: Icons.article_outlined, label: 'تقارير', count: 5, color: Color(0xFF10B981)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('الملفات الأخيرة', style: AppTextStyles.h4),
          ),
          const SizedBox(height: 12),
          // تم الاعتماد هنا على الـ Entity الخاص بالملفات الطبية
          // ...medicalFiles.map((f) => Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: _FileItem(file: f),
          // )),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_outlined, color: AppColors.textSecondary),
            label: const Text('رفع ملف جديد', style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _CategoryCard({required this.icon, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelLarge),
          Text('$count ملف', style: AppTextStyles.captionText),
        ],
      ),
    );
  }
}
