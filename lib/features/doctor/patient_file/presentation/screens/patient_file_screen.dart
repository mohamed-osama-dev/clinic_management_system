import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

import '../cubits/patient_file_cubit.dart';
import '../cubits/patient_file_state.dart';

class PatientFileScreen extends StatefulWidget {
  const PatientFileScreen({this.patientId, super.key});

  final String? patientId;

  @override
  State<PatientFileScreen> createState() => _PatientFileScreenState();
}

class _PatientFileScreenState extends State<PatientFileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientFileCubit>().loadPatientFile(
          patientId: widget.patientId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<PatientFileCubit, PatientFileState>(
        builder: (context, state) {
          if (state is PatientFileLoading || state is PatientFileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is PatientFileError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.bodyMedium),
            );
          }

          if (state is PatientFileLoaded) {
            return _PatientFileBody(patient: state.patient);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _PatientFileBody extends StatelessWidget {
  const _PatientFileBody({required this.patient});

  final PatientFileInfo patient;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────────────────────────────────
        SliverToBoxAdapter(child: _PatientFileAppBar(patient: patient)),

        // ── Stats ────────────────────────────────────────────────────────
        SliverToBoxAdapter(child: _PatientStats(patient: patient)),

        // ── Health Condition ─────────────────────────────────────────────
        SliverToBoxAdapter(child: _HealthConditionSection(patient: patient)),

        // ── Previous Visits ──────────────────────────────────────────────
        SliverToBoxAdapter(child: _PreviousVisitsSection(patient: patient)),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.paddingXL),
        ),
      ],
    );
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────

class _PatientFileAppBar extends StatelessWidget {
  const _PatientFileAppBar({required this.patient});

  final PatientFileInfo patient;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textPrimary,
                    size: AppDimensions.iconM,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                Text('ملف المريض', style: AppTextStyles.h3),
                const Spacer(),
                const SizedBox(width: 24),
              ],
            ),
          ),

          // Patient info
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              children: [
                // Last visit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'آخر زيارة',
                      style: AppTextStyles.captionText,
                    ),
                    Text(
                      patient.lastVisit,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),

                const Spacer(),

                // Name + age + avatar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      patient.name,
                      style: AppTextStyles.h4,
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      '${patient.age} سنة · ${patient.gender}',
                      style: AppTextStyles.bodySmall,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(width: AppDimensions.paddingS),
                CircleAvatar(
                  radius: AppDimensions.avatarM / 2,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    patient.name.substring(0, 1),
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),
        ],
      ),
    );
  }
}

// ── Stats ─────────────────────────────────────────────────────────────────────

class _PatientStats extends StatelessWidget {
  const _PatientStats({required this.patient});

  final PatientFileInfo patient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: '${patient.testsCount}',
              label: 'تحاليل',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.border),
          Expanded(
            child: _StatItem(
              value: '${patient.prescriptionsCount}',
              label: 'الوصفات',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.border),
          Expanded(
            child: _StatItem(
              value: '${patient.visitsCount}',
              label: 'الزيارات',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.captionText),
      ],
    );
  }
}

// ── Health Condition ──────────────────────────────────────────────────────────

class _HealthConditionSection extends StatelessWidget {
  const _HealthConditionSection({required this.patient});

  final PatientFileInfo patient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('الحالة الصحية', style: AppTextStyles.h4),
          const SizedBox(height: AppDimensions.paddingS),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _HealthRow(
                  label: 'ضغط الدم',
                  value: patient.healthCondition.bloodPressure,
                  valueColor: AppColors.error,
                  showDivider: true,
                ),
                _HealthRow(
                  label: 'السكر',
                  value: patient.healthCondition.bloodSugar,
                  valueColor: AppColors.warning,
                  showDivider: true,
                ),
                _HealthRow(
                  label: 'الوزن',
                  value: patient.healthCondition.weight,
                  valueColor: AppColors.textPrimary,
                  showDivider: true,
                ),
                _HealthRow(
                  label: 'الحساسية',
                  value: patient.healthCondition.allergies,
                  valueColor: AppColors.error,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.showDivider,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: AppTextStyles.labelMedium.copyWith(color: valueColor),
              ),
              Text(label, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

// ── Previous Visits ───────────────────────────────────────────────────────────

class _PreviousVisitsSection extends StatelessWidget {
  const _PreviousVisitsSection({required this.patient});

  final PatientFileInfo patient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('الزيارات السابقة', style: AppTextStyles.h4),
          const SizedBox(height: AppDimensions.paddingS),
          ...patient.previousVisits.map(
            (visit) => _VisitTile(visit: visit),
          ),
        ],
      ),
    );
  }
}

class _VisitTile extends StatelessWidget {
  const _VisitTile({required this.visit});

  final PreviousVisit visit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Row(
        children: [
          // Visit type icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(
              _visitIcon(visit.type),
              color: AppColors.primary,
              size: AppDimensions.iconM,
            ),
          ),

          const SizedBox(width: AppDimensions.paddingM),

          // Title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  visit.title,
                  style: AppTextStyles.labelLarge,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 2),
                Text(
                  visit.date,
                  style: AppTextStyles.captionText,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _visitIcon(VisitType type) => switch (type) {
        VisitType.followUp => Icons.favorite_border_rounded,
        VisitType.checkup => Icons.calendar_today_rounded,
        VisitType.consultation => Icons.chat_bubble_outline_rounded,
      };
}
