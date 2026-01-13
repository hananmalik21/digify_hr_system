import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/forms/shift_selection_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WeeklyScheduleSection extends StatelessWidget {
  final bool isDark;
  final int enterpriseId;
  final List<ShiftOverview> shifts;
  final WorkPattern? selectedWorkPattern;
  final String assignmentMode;
  final ShiftOverview? sameShiftForAllDays;
  final Map<int, ShiftOverview?> dayShifts;
  final ValueChanged<String> onAssignmentModeChanged;
  final ValueChanged<ShiftOverview?> onSameShiftChanged;
  final void Function(int dayOfWeek, ShiftOverview? shift) onDayShiftChanged;

  const WeeklyScheduleSection({
    super.key,
    required this.isDark,
    required this.enterpriseId,
    required this.shifts,
    this.selectedWorkPattern,
    required this.assignmentMode,
    this.sameShiftForAllDays,
    required this.dayShifts,
    required this.onAssignmentModeChanged,
    required this.onSameShiftChanged,
    required this.onDayShiftChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: 'Weekly Schedule',
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              height: 20 / 13.8,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
              ),
            ],
          ),
        ),
        Gap(8.h),
        if (selectedWorkPattern != null)
          _AssignmentModeSelector(isDark: isDark, assignmentMode: assignmentMode, onChanged: onAssignmentModeChanged),
        if (selectedWorkPattern != null) Gap(16.h),
        if (assignmentMode == 'SAME_SHIFT_ALL_DAYS' && selectedWorkPattern != null)
          _SameShiftForAllDaysSelector(
            isDark: isDark,
            enterpriseId: enterpriseId,
            selectedShift: sameShiftForAllDays,
            onChanged: onSameShiftChanged,
          )
        else
          _IndividualShiftsPerDaySelector(
            isDark: isDark,
            enterpriseId: enterpriseId,
            selectedWorkPattern: selectedWorkPattern,
            dayShifts: dayShifts,
            onDayShiftChanged: onDayShiftChanged,
          ),
      ],
    );
  }
}

class _AssignmentModeSelector extends StatelessWidget {
  final bool isDark;
  final String assignmentMode;
  final ValueChanged<String> onChanged;

  const _AssignmentModeSelector({required this.isDark, required this.assignmentMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Schedule Assignment Mode',
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          Row(
            children: [
              _RadioOption(
                isDark: isDark,
                label: 'Same shift for all days',
                value: 'SAME_SHIFT_ALL_DAYS',
                groupValue: assignmentMode,
                onChanged: onChanged,
              ),
              Gap(24.w),
              _RadioOption(
                isDark: isDark,
                label: 'Individual shifts per day',
                value: 'PER_DAY_SHIFT',
                groupValue: assignmentMode,
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _RadioOption({
    required this.isDark,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: groupValue == value
                    ? AppColors.primary
                    : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                width: 2.w,
              ),
              color: Colors.transparent,
            ),
            child: groupValue == value
                ? Center(
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                    ),
                  )
                : null,
          ),
          Gap(8.w),
          Text(
            label,
            style: TextStyle(fontSize: 13.8.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _SameShiftForAllDaysSelector extends StatelessWidget {
  final bool isDark;
  final int enterpriseId;
  final ShiftOverview? selectedShift;
  final ValueChanged<ShiftOverview?> onChanged;

  const _SameShiftForAllDaysSelector({
    required this.isDark,
    required this.enterpriseId,
    this.selectedShift,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: ShiftSelectionField(
        label: 'Select Shift',
        isRequired: true,
        enterpriseId: enterpriseId,
        selectedShift: selectedShift,
        onChanged: onChanged,
      ),
    );
  }
}

class _IndividualShiftsPerDaySelector extends StatelessWidget {
  final bool isDark;
  final int enterpriseId;
  final WorkPattern? selectedWorkPattern;
  final Map<int, ShiftOverview?> dayShifts;
  final void Function(int dayOfWeek, ShiftOverview? shift) onDayShiftChanged;

  const _IndividualShiftsPerDaySelector({
    required this.isDark,
    required this.enterpriseId,
    this.selectedWorkPattern,
    required this.dayShifts,
    required this.onDayShiftChanged,
  });

  bool _isWorkingDay(int dayOfWeek) {
    if (selectedWorkPattern == null) {
      return dayShifts.containsKey(dayOfWeek) && dayShifts[dayOfWeek] != null;
    }
    return selectedWorkPattern!.days.any((day) => day.dayOfWeek == dayOfWeek && day.dayType == 'WORK');
  }

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        final dayOfWeek = index + 1;
        final dayName = dayNames[index];
        final selectedShift = dayShifts[dayOfWeek];
        final isWorkingDay = _isWorkingDay(dayOfWeek);

        return Container(
          margin: EdgeInsets.only(bottom: index < 6 ? 4.h : 0),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 128.w,
                child: Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w500,
                    color: isWorkingDay
                        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: ShiftSelectionField(
                  label: '',
                  isRequired: false,
                  enterpriseId: enterpriseId,
                  selectedShift: selectedShift,
                  onChanged: (shift) => onDayShiftChanged(dayOfWeek, shift),
                  enabled: isWorkingDay,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
