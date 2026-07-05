import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import 'package:clinic_management_system/features/patient/doctor_profile/domain/entities/doctor_entity.dart';
import '../../../../shared/data/repositories/appointments_repository.dart';
import '../../../appointments/presentation/screens/my_appointments_screen.dart';

// ── استدعاءات الـ Auth والـ Repository ──
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_management_system/features/shared/data/models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BookingConfirmationScreen extends StatefulWidget {
  final DoctorEntity doctor;
  final String time;
  final DateTime date;
  final bool isOnline;

  const BookingConfirmationScreen({
    super.key,
    required this.doctor,
    required this.time,
    required this.date,
    required this.isOnline,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final AppointmentsRepository _repository = AppointmentsRepository();
  bool _isBooking = true;
  String? _errorMessage;

  static const Map<int, String> _days = {
    1: 'الإثنين', 2: 'الثلاثاء', 3: 'الأربعاء', 4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الأحد'
  };
  static const Map<int, String> _months = {
    1: 'يناير', 2: 'فبراير', 3: 'مارس', 4: 'أبريل', 5: 'مايو', 6: 'يونيو', 7: 'يوليو', 8: 'أغسطس', 9: 'سبتمبر', 10: 'أكتوبر', 11: 'نوفمبر', 12: 'ديسمبر'
  };

  String get _formattedDate => '${_days[widget.date.weekday]}، ${widget.date.day} ${_months[widget.date.month]} ${widget.date.year}';

  @override
  void initState() {
    super.initState();
    _confirmBooking();
  }

  Future<void> _confirmBooking() async {
    try {
      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthAuthenticated) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      final patient = authState.user;

      // دمج التاريخ والوقت المختارين
      final hour = int.parse(widget.time.split(':')[0]);
      final minute = int.parse(widget.time.split(':')[1].split(' ')[0]);
      final isPM = widget.time.contains('م');
      final finalHour = isPM && hour != 12 ? hour + 12 : (!isPM && hour == 12 ? 0 : hour);
      final appointmentDateTime = DateTime(widget.date.year, widget.date.month, widget.date.day, finalHour, minute);

      // ── التعديل هنا: توليد ID حقيقي من فايربيز قبل الحفظ ──
      final generatedId = FirebaseFirestore.instance.collection('appointments').doc().id;

      // تجهيز الحجز
      final newAppointment = AppointmentModel(
        id: generatedId, // استخدمنا الـ ID اللي اتولد
        patientId: patient.id,
        doctorId: widget.doctor.id,
        dateTime: appointmentDateTime,
        status: AppointmentStatus.pending,
        patientName: patient.name,
        type: widget.isOnline ? 'استشارة عن بعد' : 'كشف حضوري',
        durationMinutes: 30,
      );

      // رفع الداتا لفايربيز
      await _repository.createAppointment(newAppointment);

      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBooking = false;
          _errorMessage = e.toString();
        });
      }
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
        title: const Text('تأكيد الحجز', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isBooking
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _errorMessage != null
            ? Center(child: Text('حدث خطأ: $_errorMessage', style: AppTextStyles.bodyMedium.copyWith(color: Colors.red)))
            : Column(
          children: [
            const SizedBox(height: 32),
            Container(
              width: 72, height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 20),
            const Text('تم الحجز بنجاح!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text('سيتم إشعارك بتفاصيل الموعد بعد 24 ساعة',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.doctor.name, style: AppTextStyles.h4),
                            Text(widget.doctor.specialty, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: AppColors.border),
                  _infoRow('التاريخ', _formattedDate),
                  const SizedBox(height: 12),
                  _infoRow('الوقت', widget.time),
                  const SizedBox(height: 12),
                  _infoRow('النوع', widget.isOnline ? 'عن بعد' : 'حضوري'),
                  const SizedBox(height: 12),
                  _infoRow('المكان', widget.isOnline ? 'مكالمة فيديو' : widget.doctor.location),
                  const SizedBox(height: 12),
                  _infoRow('الرسوم', '${widget.doctor.price.toInt()} ر.س'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyAppointmentsScreen()),
                      (route) => route.isFirst,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('عرض مواعيدي', style: AppTextStyles.buttonText),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('إضافة إلى التقويم',
                    style: AppTextStyles.buttonText.copyWith(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: AppTextStyles.labelLarge),
        Text(label, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}