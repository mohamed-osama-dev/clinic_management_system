// Placeholder stub for prescription screen.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

import '../cubits/prescription_cubit.dart';
import '../cubits/prescription_state.dart';
import '../widgets/medicine_card.dart';
import '../widgets/add_medicine_form.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PrescriptionCubit>().loadPrescription();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<PrescriptionCubit, PrescriptionState>(
        listener: (context, state) {
          if (state is PrescriptionLoaded && state.isSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'تم إرسال الوصفة للمريض بنجاح ✅',
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PrescriptionInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is PrescriptionLoaded) {
            // sync notes controller
            if (_notesController.text != state.generalNotes) {
              _notesController.text = state.generalNotes;
            }
            return _PrescriptionBody(
              state: state,
              notesController: _notesController,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _PrescriptionBody extends StatelessWidget {
  const _PrescriptionBody({
    required this.state,
    required this.notesController,
  });

  final PrescriptionLoaded state;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── App Bar ──────────────────────────────────────────────────────
        _PrescriptionAppBar(patient: state.patient),

        // ── Content ──────────────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Medicines list
              ...state.medicines.map(
                (m) => MedicineCard(
                  medicine: m,
                  onDelete: () =>
                      context.read<PrescriptionCubit>().removeMedicine(m.id),
                ),
              ),

              // Add medicine button
              _AddMedicineButton(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusXL),
                    ),
                  ),
                  builder: (_) => AddMedicineForm(
                    onAdd: (medicine) =>
                        context.read<PrescriptionCubit>().addMedicine(medicine),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // General notes
              _NotesField(
                controller: notesController,
                onChanged: (v) =>
                    context.read<PrescriptionCubit>().updateNotes(v),
              ),

              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),

        // ── Bottom Buttons ────────────────────────────────────────────────
        _BottomActions(state: state),
      ],
    );
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────

class _PrescriptionAppBar extends StatelessWidget {
  const _PrescriptionAppBar({required this.patient});

  final PrescriptionPatient patient;

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
                Text('وصفة طبية', style: AppTextStyles.h3),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'حفظ',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          // Patient info card
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.date,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),

                const Spacer(),

                // Name + avatar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      patient.name,
                      style: AppTextStyles.labelLarge,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(width: AppDimensions.paddingS),
                CircleAvatar(
                  radius: AppDimensions.avatarS / 2,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    patient.name.substring(0, 1),
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary),
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

// ── Add Medicine Button ───────────────────────────────────────────────────────

class _AddMedicineButton extends StatelessWidget {
  const _AddMedicineButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Text(
              '+ إضافة دواء',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notes Field ───────────────────────────────────────────────────────────────

class _NotesField extends StatelessWidget {
  const _NotesField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('ملاحظات', style: AppTextStyles.labelLarge),
        const SizedBox(height: AppDimensions.paddingS),
        TextField(
          controller: controller,
          onChanged: onChanged,
          textDirection: TextDirection.rtl,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'أضف ملاحظات للمريض...',
            hintStyle: AppTextStyles.bodyMedium,
            hintTextDirection: TextDirection.rtl,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.all(AppDimensions.paddingM),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Bottom Actions ────────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.state});

  final PrescriptionLoaded state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM +
            MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Print button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.read<PrescriptionCubit>().printPrescription(),
              icon: const Icon(Icons.print_rounded, size: AppDimensions.iconM),
              label: const Text('طباعة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingM),
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.paddingM),

          // Send button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: state.isSending
                  ? null
                  : () =>
                      context.read<PrescriptionCubit>().sendPrescription(),
              icon: state.isSending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: AppDimensions.iconM),
              label: Text(state.isSending ? 'جاري الإرسال...' : 'إرسال للمريض'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
