import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'holiday_card.dart';

class MonthlyHolidayGroupData {
  final String monthYear;
  final List<HolidayCardData> holidays;

  const MonthlyHolidayGroupData({required this.monthYear, required this.holidays});
}

class MonthlyHolidayGroup extends StatelessWidget {
  final MonthlyHolidayGroupData data;
  final void Function(String holidayId)? onViewHoliday;
  final void Function(String holidayId)? onEditHoliday;
  final void Function(String holidayId)? onDeleteHoliday;

  const MonthlyHolidayGroup({
    super.key,
    required this.data,
    this.onViewHoliday,
    this.onEditHoliday,
    this.onDeleteHoliday,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 4), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              children: [
                ...data.holidays.asMap().entries.map((entry) {
                  final index = entry.key;
                  final holiday = entry.value;
                  return Column(
                    children: [
                      HolidayCard(
                        holiday: holiday,
                        onView: onViewHoliday != null ? () => onViewHoliday!(holiday.id) : null,
                        onEdit: onEditHoliday != null ? () => onEditHoliday!(holiday.id) : null,
                        onDelete: onDeleteHoliday != null ? () => onDeleteHoliday!(holiday.id) : null,
                        showBorder: true,
                      ),
                      if (index < data.holidays.length - 1) SizedBox(height: 16.h),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFF155DFC), Color(0xFF4F39F6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isDark ? AppColors.cardBackgroundDark : null,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Text(
        data.monthYear,
        style: TextStyle(
          fontSize: 15.6.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : Colors.white,
          fontFamily: 'Inter',
          height: 24 / 15.6,
        ),
      ),
    );
  }
}
