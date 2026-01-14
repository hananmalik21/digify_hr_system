import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'holiday_card.dart';

class MonthlyHolidayGroupData {
  final String monthYear;
  final List<HolidayCardData> holidays;

  const MonthlyHolidayGroupData({required this.monthYear, required this.holidays});
}

class MonthlyHolidayGroup extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(publicHolidaysNotifierProvider);
    final deletingHolidayId = state.deletingHolidayId;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
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
                        isDeleting: deletingHolidayId != null && deletingHolidayId == int.tryParse(holiday.id),
                      ),
                      if (index < data.holidays.length - 1) Gap(16.h),
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
                colors: [AppColors.primary, AppColors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isDark ? AppColors.cardBackgroundDark : null,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Text(
        data.monthYear,
        style: context.textTheme.titleMedium?.copyWith(
          fontSize: 15.6.sp,
          color: isDark ? AppColors.textPrimaryDark : AppColors.cardBackground,
        ),
      ),
    );
  }
}
