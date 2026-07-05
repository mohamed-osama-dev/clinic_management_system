// Path: lib/features/doctor/patients/presentation/pages/doctor_patients_screen2.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

import '../cubits/doctor_patients_cubit.dart';
import '../cubits/doctor_patients_state.dart';
import '../widgets/patient_card.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  // تم حذف _currentNavIndex من هنا
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DoctorPatientsCubit>().loadPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // تم حذف الـ bottomNavigationBar من هنا
      body: BlocBuilder<DoctorPatientsCubit, PatientsState>(
        builder: (context, state) {
          if (state is PatientsLoading || state is PatientsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is PatientsError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.bodyMedium),
            );
          }

          if (state is PatientsLoaded) {
            return _PatientsBody(
              state: state,
              searchController: _searchController,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Patients Body ─────────────────────────────────────────────────────────────

class _PatientsBody extends StatelessWidget {
  const _PatientsBody({
    required this.state,
    required this.searchController,
  });

  final PatientsLoaded state;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── App Bar ──────────────────────────────────────────────────────
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('المرضى', style: AppTextStyles.h3),
              ],
            ),
          ),
        ),

        // ── Search Bar ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: TextField(
            controller: searchController,
            textDirection: TextDirection.rtl,
            onChanged: (q) =>
                context.read<DoctorPatientsCubit>().search(q),
            decoration: InputDecoration(
              hintText: 'ابحث عن مريض...',
              hintStyle: AppTextStyles.bodyMedium,
              hintTextDirection: TextDirection.rtl,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(AppDimensions.radiusFull),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(AppDimensions.radiusFull),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(AppDimensions.radiusFull),
                borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),

        // ── Patients count ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingXS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${state.filteredPatients.length} مريض',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        // ── Patients List ────────────────────────────────────────────────
        Expanded(
          child: state.filteredPatients.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_search_rounded,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  'لا توجد نتائج',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            itemCount: state.filteredPatients.length,
            itemBuilder: (context, i) => PatientCard(
              patient: state.filteredPatients[i],
              onTap: () {
                // TODO: navigate to patient file
              },
            ),
          ),
        ),
      ],
    );
  }
}