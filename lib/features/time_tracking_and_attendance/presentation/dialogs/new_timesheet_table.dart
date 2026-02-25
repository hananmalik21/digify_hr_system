import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/new_timesheet_provider.dart';

class NewTimesheetTable extends StatelessWidget {
  const NewTimesheetTable({
    super.key,
    required this.state,
    required this.notifier,
    required this.regularHoursControllers,
    required this.overtimeHoursControllers,
  });

  final NewTimesheetFormState state;
  final NewTimesheetNotifier notifier;
  final List<TextEditingController> regularHoursControllers;
  final List<TextEditingController> overtimeHoursControllers;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Daily Time Entries',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        Gap(6.h),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(children: [_buildHeader(context, isDark), _buildBody(context, isDark)]),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Day',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 3,
            child: Text(
              'Project/Task',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              'Regular Hrs',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              'OT Hrs',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    return Column(
      children: [
        for (var index = 0; index < state.weekDays.length; index++) ...[
          _buildRow(context, isDark, index),
          if (index < state.weekDays.length - 1) DigifyDivider.horizontal(),
        ],
        _buildWeeklyTotalRow(context, isDark),
      ],
    );
  }

  Widget _buildRow(BuildContext context, bool isDark, int index) {
    final date = state.weekDays[index];
    final weekday = date.weekday;
    final isRestDay = weekday == DateTime.friday || weekday == DateTime.saturday;

    return Container(
      color: isRestDay
          ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey)
          : AppColors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: DateFormat('EEEE').format(date),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                    ),
                  ),
                  if (isRestDay)
                    TextSpan(
                      text: '  (Rest)',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('MMM d').format(date),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 3,
            child: DigifyTextField(
              hintText: 'Enter task',
              onChanged: (value) => notifier.setTaskText(index, value),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: DigifyTextField(
              controller: regularHoursControllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              onChanged: (value) => notifier.setRegularHours(index, value),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: DigifyTextField(
              controller: overtimeHoursControllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              onChanged: (value) => notifier.setOvertimeHours(index, value),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTotalRow(BuildContext context, bool isDark) {
    String formatHours(double value) {
      if (value == 0) return '0h';
      return value == value.roundToDouble() ? '${value.toInt()}h' : '${value.toStringAsFixed(2)}h';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Weekly Total',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
              ),
            ),
          ),
          Gap(16.w),
          const Expanded(flex: 2, child: SizedBox.shrink()),
          Gap(16.w),
          const Expanded(flex: 3, child: SizedBox.shrink()),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                formatHours(state.totalRegularHours),
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.inputLabel,
                ),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                formatHours(state.totalOvertimeHours),
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.inputLabel,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
