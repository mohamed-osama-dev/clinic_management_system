
import 'package:clinic_management_system/features/patient/doctor_profile/domain/entities/doctor_entity.dart';
import 'package:clinic_management_system/features/patient/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorEntity doctor;
  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  DateTime _selectedDate = DateTime(2026, 4, 27);
  bool _isOnline = false;
  String? _selectedTime;
  bool _expanded = false;

  final List<String> _times = ['09:00 ص', '09:30 ص', '10:00 ص', '10:30 ص', '11:00 ص', '11:30 ص', '01:00 م', '04:00 م'];
  final List<String> _unavailable = ['02:30 م'];

  List<DateTime> get _days {
    final base = DateTime(2026, 4, 25);
    return List.generate(5, (i) => base.add(Duration(days: i)));
  }

  final Map<int, String> _dayNames = {1: 'الإث', 2: 'الثلا', 3: 'الأر', 4: 'الخم', 5: 'الجم', 6: 'الست', 7: 'الأح'};
  final Map<int, String> _monthNames = {4: 'أبريل', 5: 'مايو'};

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(d)),
          SliverToBoxAdapter(child: _buildStats(d)),
          SliverToBoxAdapter(child: _buildBio(d)),
          SliverToBoxAdapter(child: _buildBookingSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(d),
    );
  }

  Widget _buildHero(DoctorEntity d) {
    return Stack(
      children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(color: AppColors.primaryLight),
          child: const Center(child: Icon(Icons.person_rounded, size: 120, color: AppColors.primary)),
        ),
        Positioned(
          bottom: 16, right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(d.name, style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary)),
              Text(d.specialty, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(DoctorEntity d) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(Icons.workspace_premium_outlined, '${d.experience} سنة', 'الخبرة'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.h4),
        Text(label, style: AppTextStyles.captionText),
      ],
    );
  }

  Widget _buildBio(DoctorEntity d) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('نبذة', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(_expanded ? d.bio : (d.bio.length > 100 ? '${d.bio.substring(0, 100)}...' : d.bio), style: AppTextStyles.bodyMedium, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildBookingSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('احجز موعدك', style: AppTextStyles.h3),
          _buildDatePicker(),
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 72,
      child: ListView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        children: _days.map((date) {
          final selected = date.day == _selectedDate.day;
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 56, margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_dayNames[date.weekday] ?? '', style: TextStyle(color: selected ? Colors.white : AppColors.textSecondary)),
                  Text('${date.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textPrimary)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2.8),
      itemCount: _times.length,
      itemBuilder: (_, i) {
        final t = _times[i];
        final selected = _selectedTime == t;
        return GestureDetector(
          onTap: () => setState(() => _selectedTime = t),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: Text(t, style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary)),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(DoctorEntity d) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: ElevatedButton(
        onPressed: _selectedTime == null ? null : () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => BookingConfirmationScreen(doctor: d, time: _selectedTime!, date: _selectedDate, isOnline: _isOnline))),
        child: const Text('تأكيد الحجز', style: AppTextStyles.buttonText),
      ),
    );
  }
}