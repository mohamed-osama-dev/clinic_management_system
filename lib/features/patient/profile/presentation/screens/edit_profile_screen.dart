import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;

  // متغيرات فصيلة الدم
  String? _selectedBloodType;
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;
    String currentName = '';

    if (authState is AuthAuthenticated) {
      currentName = authState.user.name;
    } else {
      final user = context.read<AuthCubit>().currentUser;
      if (user != null) currentName = user.name;
    }

    _nameController = TextEditingController(text: currentName);
    _ageController = TextEditingController(text: '32');
    _weightController = TextEditingController(text: '78');
    _selectedBloodType = 'O+'; // القيمة الافتراضية
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // حفظ كل البيانات في فايربيز
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': _nameController.text.trim(),
          'age': _ageController.text.trim(),
          'weight': _weightController.text.trim(),
          'bloodType': _selectedBloodType,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ التعديلات بنجاح', style: TextStyle(fontFamily: 'Cairo')),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء الحفظ، تأكد من الاتصال بالإنترنت', style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('تعديل الحساب', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'P',
                            style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 36),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 3),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                            onPressed: () {},
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    _buildTextField(
                      controller: _nameController,
                      label: 'الاسم الكامل',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _ageController,
                            label: 'العمر',
                            icon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: 'الوزن (كغ)',
                            icon: Icons.monitor_weight_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── قائمة فصيلة الدم المنسدلة ──
                    DropdownButtonFormField<String>(
                      value: _selectedBloodType,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                      decoration: InputDecoration(
                        labelText: 'فصيلة الدم',
                        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.surface,
                        prefixIcon: const Icon(Icons.bloodtype_outlined, color: AppColors.primary, size: 22),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      items: _bloodTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type, style: AppTextStyles.bodyMedium),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBloodType = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text('حفظ التعديلات', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        alignLabelWithHint: true,
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'برجاء إدخال $label';
        }
        return null;
      },
    );
  }
}