// Placeholder stub for add medicine form widget.
import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/features/doctor/prescription/presentation/cubits/prescription_state.dart';
import 'package:uuid/uuid.dart';

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({
    required this.onAdd,
    super.key,
  });

  final ValueChanged<MedicineModel> onAdd;

  @override
  State<AddMedicineForm> createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  static const _uuid = Uuid();

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty || _doseController.text.isEmpty) return;

    widget.onAdd(MedicineModel(
      id: _uuid.v4(),
      name: _nameController.text.trim(),
      dose: _doseController.text.trim(),
      frequency: _frequencyController.text.trim().isEmpty
          ? 'مرة يومياً'
          : _frequencyController.text.trim(),
      durationDays: int.tryParse(_durationController.text) ?? 7,
    ));

    _nameController.clear();
    _doseController.clear();
    _frequencyController.clear();
    _durationController.clear();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.paddingM,
        right: AppDimensions.paddingM,
        top: AppDimensions.paddingM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),

          Text('إضافة دواء', style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.paddingM),

          _buildField(_nameController, 'اسم الدواء', Icons.medication_rounded),
          const SizedBox(height: AppDimensions.paddingS),
          _buildField(_doseController, 'الجرعة (مثال: 500mg)', Icons.colorize_rounded),
          const SizedBox(height: AppDimensions.paddingS),
          _buildField(_frequencyController, 'التكرار (مثال: مرة يومياً)', Icons.repeat_rounded),
          const SizedBox(height: AppDimensions.paddingS),
          _buildField(_durationController, 'المدة بالأيام', Icons.calendar_today_rounded,
              isNumber: true),

          const SizedBox(height: AppDimensions.paddingM),

          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Text('إضافة', style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      textDirection: TextDirection.rtl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium,
        hintTextDirection: TextDirection.rtl,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: AppDimensions.iconM),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
