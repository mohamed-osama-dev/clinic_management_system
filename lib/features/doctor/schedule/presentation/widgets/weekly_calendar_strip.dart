import 'package:flutter/material.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';

class WeeklyCalendarStrip extends StatefulWidget {
  const WeeklyCalendarStrip({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<WeeklyCalendarStrip> createState() => _WeeklyCalendarStripState();
}

class _WeeklyCalendarStripState extends State<WeeklyCalendarStrip> {
  late PageController _pageController;
  late DateTime _weekStart;

  static const _dayNames = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(DateTime.now());
    _pageController = PageController(initialPage: 0);
  }

  // دالة لحساب يوم السبت كبداية للأسبوع
  DateTime _getWeekStart(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    // السبت في دارت هو يوم 6، لذا نحسب الفرق بناءً عليه
    final diff = (normalizedDate.weekday % 7 == 6) ? 0 : (normalizedDate.weekday + 1) % 7;
    return normalizedDate.subtract(Duration(days: diff));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  icon: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ),
                Text(_formatMonthYear(_weekStart), style: AppTextStyles.labelLarge),
                IconButton(
                  onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 70,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _weekStart = _getWeekStart(DateTime.now()).add(Duration(days: page * 7));
                });
              },
              itemBuilder: (context, page) {
                final weekStart = _getWeekStart(DateTime.now()).add(Duration(days: page * 7));
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final day = weekStart.add(Duration(days: i));
                    final isSelected = _isSameDay(day, widget.selectedDate);
                    return _DayCell(
                      day: day,
                      dayName: _dayNames[i],
                      isSelected: isSelected,
                      onTap: () => widget.onDateSelected(day),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatMonthYear(DateTime date) {
    const months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.dayName, required this.isSelected, required this.onTap});
  final DateTime day;
  final String dayName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40, height: 60,
        decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dayName, style: AppTextStyles.labelSmall.copyWith(color: isSelected ? Colors.white70 : AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('${day.day}', style: AppTextStyles.labelLarge.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}