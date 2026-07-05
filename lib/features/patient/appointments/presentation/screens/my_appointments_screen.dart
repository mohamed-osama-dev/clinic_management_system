import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── التعديل الأول: استخدام watch عشان الشاشة تحدث نفسها لو الـ ID اتأخر ──
    final authState = context.watch<AuthCubit>().state;
    final patientId = authState is AuthAuthenticated ? authState.user.id : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('مواعيدي', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: AppColors.border, blurRadius: 4)],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: AppTextStyles.labelLarge,
              unselectedLabelStyle: AppTextStyles.bodyMedium,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'القادمة'),
                Tab(text: 'السابقة'),
                Tab(text: 'الملغاة'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: patientId.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('patientId', isEqualTo: patientId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ في تحميل المواعيد', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)));
                }

                final docs = snapshot.data?.docs ?? [];

                final upcoming = <Map<String, dynamic>>[];
                final past = <Map<String, dynamic>>[];
                final cancelled = <Map<String, dynamic>>[];

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;

                  // ── التعديل التاني: معالجة الحالة أياً كان شكلها ──
                  final status = data['status'].toString().toLowerCase();

                  if (status.contains('pending') || status.contains('confirmed')) {
                    upcoming.add(data);
                  } else if (status.contains('completed')) {
                    past.add(data);
                  } else if (status.contains('cancelled')) {
                    cancelled.add(data);
                  } else {
                    upcoming.add(data); // كاحتياط لو الحالة مش معروفة
                  }
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAppointmentsList(upcoming),
                    _buildAppointmentsList(past),
                    _buildAppointmentsList(cancelled),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<Map<String, dynamic>> appointments) {
    if (appointments.isEmpty) {
      return _EmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = appointments[index];
        final type = data['type'] ?? 'كشف عام';
        final statusString = data['status'].toString().toLowerCase();

        // ── التعديل التالت: قراءة التاريخ بشكل آمن ──
        DateTime date = DateTime.now();
        if (data['dateTime'] != null) {
          if (data['dateTime'] is Timestamp) {
            date = (data['dateTime'] as Timestamp).toDate();
          } else if (data['dateTime'] is String) {
            date = DateTime.tryParse(data['dateTime']) ?? DateTime.now();
          }
        }

        final hour = date.hour;
        final minute = date.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'م' : 'ص';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final timeString = '$displayHour:$minute $period';
        final dateString = '${date.year}/${date.month}/${date.day}';

        Color statusColor = AppColors.warning;
        String statusText = 'قيد الانتظار';
        if (statusString.contains('confirmed')) {
          statusColor = AppColors.success;
          statusText = 'مؤكد';
        } else if (statusString.contains('cancelled')) {
          statusColor = AppColors.error;
          statusText = 'ملغى';
        } else if (statusString.contains('completed')) {
          statusColor = AppColors.primary;
          statusText = 'مكتمل';
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(type, style: AppTextStyles.labelLarge),
                    const SizedBox(height: 4),
                    Text('$dateString • $timeString', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusText, style: AppTextStyles.labelSmall.copyWith(color: statusColor)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 48),
          ),
          const SizedBox(height: 20),
          const Text('لا توجد مواعيد هنا', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          const Text('لم نتمكن من العثور على أي مواعيد في هذه القائمة',
              style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text('احجز موعد الآن', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }
}