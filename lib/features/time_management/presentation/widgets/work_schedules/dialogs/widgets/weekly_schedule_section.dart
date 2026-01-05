import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/shift_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        SizedBox(height: 8.h),
        if (selectedWorkPattern != null)
          _AssignmentModeSelector(isDark: isDark, assignmentMode: assignmentMode, onChanged: onAssignmentModeChanged),
        if (selectedWorkPattern != null) SizedBox(height: 16.h),
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
          SizedBox(height: 12.h),
          Row(
            children: [
              _RadioOption(
                isDark: isDark,
                label: 'Same shift for all days',
                value: 'SAME_SHIFT_ALL_DAYS',
                groupValue: assignmentMode,
                onChanged: onChanged,
              ),
              SizedBox(width: 24.w),
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
              color: groupValue == value ? AppColors.primary : Colors.transparent,
            ),
            child: groupValue == value ? Icon(Icons.check, size: 12.sp, color: Colors.white) : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(fontSize: 13.8.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _SameShiftForAllDaysSelector extends StatefulWidget {
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
  State<_SameShiftForAllDaysSelector> createState() => _SameShiftForAllDaysSelectorState();
}

class _SameShiftForAllDaysSelectorState extends State<_SameShiftForAllDaysSelector> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedShift != null
          ? '${widget.selectedShift!.name} (${widget.selectedShift!.startTime} - ${widget.selectedShift!.endTime})'
          : '',
    );
  }

  @override
  void didUpdateWidget(_SameShiftForAllDaysSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedShift != oldWidget.selectedShift) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.selectedShift != null
              ? '${widget.selectedShift!.name} (${widget.selectedShift!.startTime} - ${widget.selectedShift!.endTime})'
              : '';
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectShift(BuildContext context) async {
    final selected = await ShiftSelectionDialog.show(
      context: context,
      enterpriseId: widget.enterpriseId,
      selectedShift: widget.selectedShift,
    );
    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: DigifyTextField(
        controller: _controller,
        labelText: 'Select Shift',
        hintText: 'Select shift',
        isRequired: true,
        readOnly: true,
        onTap: () => _selectShift(context),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          size: 24.sp,
          color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        validator: (value) {
          if (widget.selectedShift == null) {
            return 'Please select a shift';
          }
          return null;
        },
      ),
    );
  }
}

class _IndividualShiftsPerDaySelector extends StatefulWidget {
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

  @override
  State<_IndividualShiftsPerDaySelector> createState() => _IndividualShiftsPerDaySelectorState();
}

class _IndividualShiftsPerDaySelectorState extends State<_IndividualShiftsPerDaySelector> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
      final selectedShift = widget.dayShifts[dayOfWeek];
      _controllers[dayOfWeek] = TextEditingController(
        text: selectedShift != null
            ? '${selectedShift.name} (${selectedShift.startTime} - ${selectedShift.endTime})'
            : '',
      );
    }
  }

  @override
  void didUpdateWidget(_IndividualShiftsPerDaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
          final newShift = widget.dayShifts[dayOfWeek];
          final oldShift = oldWidget.dayShifts[dayOfWeek];
          if (newShift != oldShift) {
            _controllers[dayOfWeek]?.text = newShift != null
                ? '${newShift.name} (${newShift.startTime} - ${newShift.endTime})'
                : '';
          }
        }
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectShift(BuildContext context, int dayOfWeek, ShiftOverview? currentShift) async {
    final selected = await ShiftSelectionDialog.show(
      context: context,
      enterpriseId: widget.enterpriseId,
      selectedShift: currentShift,
    );
    if (selected != null) {
      widget.onDayShiftChanged(dayOfWeek, selected);
    }
  }

  bool _isWorkingDay(int dayOfWeek) {
    if (widget.selectedWorkPattern == null) {
      return widget.dayShifts.containsKey(dayOfWeek) && widget.dayShifts[dayOfWeek] != null;
    }
    return widget.selectedWorkPattern!.days.any((day) => day.dayOfWeek == dayOfWeek && day.dayType == 'WORK');
  }

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        final dayOfWeek = index + 1;
        final dayName = dayNames[index];
        final selectedShift = widget.dayShifts[dayOfWeek];
        final isWorkingDay = _isWorkingDay(dayOfWeek);

        return Container(
          margin: EdgeInsets.only(bottom: index < 6 ? 4.h : 0),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
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
                        ? (widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DigifyTextField(
                  controller: _controllers[dayOfWeek]!,
                  labelText: '',
                  hintText: isWorkingDay ? 'Select Shift' : 'Rest Day',
                  readOnly: true,
                  enabled: isWorkingDay,
                  onTap: isWorkingDay ? () => _selectShift(context, dayOfWeek, selectedShift) : null,
                  suffixIcon: isWorkingDay
                      ? Icon(
                          Icons.arrow_drop_down,
                          size: 24.sp,
                          color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        )
                      : Icon(Icons.block, size: 20.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
