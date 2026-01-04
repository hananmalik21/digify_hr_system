import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/domain/config/work_pattern_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditWorkPatternDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final WorkPattern workPattern;

  const EditWorkPatternDialog({super.key, required this.enterpriseId, required this.workPattern});

  static Future<void> show(BuildContext context, int enterpriseId, WorkPattern workPattern) {
    return showDialog(
      context: context,
      builder: (context) => EditWorkPatternDialog(enterpriseId: enterpriseId, workPattern: workPattern),
    );
  }

  @override
  ConsumerState<EditWorkPatternDialog> createState() => _EditWorkPatternDialogState();
}

class _EditWorkPatternDialogState extends ConsumerState<EditWorkPatternDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _patternCodeController;
  late final TextEditingController _patternNameEnController;
  late final TextEditingController _patternNameArController;
  late final TextEditingController _totalHoursController;

  late String? _selectedPatternType;
  late PositionStatus _selectedStatus;
  final Set<int> _workingDays = {};
  final Set<int> _restDays = {};
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final pattern = widget.workPattern;

    _patternCodeController = TextEditingController(text: pattern.patternCode);
    _patternNameEnController = TextEditingController(text: pattern.patternNameEn);
    _patternNameArController = TextEditingController(text: pattern.patternNameAr);
    _totalHoursController = TextEditingController(text: pattern.totalHoursPerWeek.toString());

    _selectedPatternType = WorkPatternConfig.patternTypes.contains(pattern.patternType) ? pattern.patternType : null;
    _selectedStatus = pattern.status;

    // Initialize working and rest days from the pattern
    for (final day in pattern.days) {
      if (day.dayType == 'WORK') {
        _workingDays.add(day.dayOfWeek);
      } else if (day.dayType == 'REST') {
        _restDays.add(day.dayOfWeek);
      }
    }
  }

  @override
  void dispose() {
    _patternCodeController.dispose();
    _patternNameEnController.dispose();
    _patternNameArController.dispose();
    _totalHoursController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPatternType == null) {
      ToastService.error(context, 'Please select a pattern type');
      return;
    }

    if (_workingDays.isEmpty) {
      ToastService.error(context, 'Please select at least one working day');
      return;
    }

    // Build days list
    final days = <WorkPatternDay>[];
    for (int i = 1; i <= 7; i++) {
      if (_workingDays.contains(i)) {
        days.add(WorkPatternDay(dayOfWeek: i, dayType: 'WORK'));
      } else if (_restDays.contains(i)) {
        days.add(WorkPatternDay(dayOfWeek: i, dayType: 'REST'));
      }
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final notifier = ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier);
      await notifier.updateWorkPattern(
        workPatternId: widget.workPattern.workPatternId,
        patternNameEn: _patternNameEnController.text.trim(),
        patternNameAr: _patternNameArController.text.trim(),
        patternType: _selectedPatternType!,
        totalHoursPerWeek: int.tryParse(_totalHoursController.text) ?? 40,
        status: _selectedStatus,
        days: days,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ToastService.success(context, 'Work pattern updated successfully', title: 'Success');
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Failed to update work pattern: ${e.toString()}', title: 'Error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  void _toggleWorkingDay(int dayNumber) {
    setState(() {
      if (_workingDays.contains(dayNumber)) {
        _workingDays.remove(dayNumber);
      } else {
        _workingDays.add(dayNumber);
        _restDays.remove(dayNumber);
      }
    });
  }

  void _toggleRestDay(int dayNumber) {
    setState(() {
      if (_restDays.contains(dayNumber)) {
        _restDays.remove(dayNumber);
      } else {
        _restDays.add(dayNumber);
        _workingDays.remove(dayNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AppDialog(
      title: 'Edit Work Pattern',
      width: 896.w,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Pattern Code (readonly) and Pattern Name (English)
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _patternCodeController,
                    labelText: 'Pattern Code',
                    isRequired: true,
                    readOnly: true,
                    enabled: false,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _patternNameEnController,
                    labelText: 'Pattern Name (English)',
                    hintText: 'e.g., Standard 5-Day Week',
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pattern name (English) is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Second row: Pattern Name (Arabic) and Pattern Type
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _patternNameArController,
                    labelText: 'Pattern Name (Arabic)',
                    hintText: 'أيام',
                    isRequired: true,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pattern name (Arabic) is required';
                      }
                      return null;
                    },
                    inputFormatters: [AppInputFormatters.nameAr],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Pattern Type',
                    value: _selectedPatternType,
                    items: WorkPatternConfig.patternTypes,
                    itemLabelBuilder: (type) => WorkPatternConfig.getPatternTypeLabel(type),
                    onChanged: (value) {
                      setState(() {
                        _selectedPatternType = value;
                      });
                    },
                    isRequired: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Pattern type is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Third row: Total Hours/Week and Status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Total Hours/Week',
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
                      DigifyTextField(
                        controller: _totalHoursController,
                        hintText: '40',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Total hours is required';
                          }
                          final hours = int.tryParse(value);
                          if (hours == null || hours <= 0 || hours > 168) {
                            return 'Please enter a valid number (1-168)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: DigifySelectField<PositionStatus>(
                    label: 'Status',
                    value: _selectedStatus,
                    items: [PositionStatus.active, PositionStatus.inactive],
                    itemLabelBuilder: (status) => status == PositionStatus.active ? 'Active' : 'Inactive',
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Working Days section
            _buildDaysSection(
              label: 'Working Days',
              isDark: isDark,
              selectedDays: _workingDays,
              onDayToggle: _toggleWorkingDay,
              isRequired: true,
            ),
            SizedBox(height: 24.h),

            // Rest Days section
            _buildDaysSection(
              label: 'Rest Days',
              isDark: isDark,
              selectedDays: _restDays,
              onDayToggle: _toggleRestDay,
              isRequired: false,
            ),
          ],
        ),
      ),
      actions: [
        AppButton.outline(
          label: 'Cancel',
          width: 100.w,
          onPressed: _isUpdating ? null : () => Navigator.of(context).pop(),
        ),
        SizedBox(width: 12.w),
        AppButton(
          label: 'Save Changes',
          width: 179.w,
          onPressed: _isUpdating ? null : _handleUpdate,
          isLoading: _isUpdating,
          svgPath: Assets.icons.saveIcon.path,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDaysSection({
    required String label,
    required bool isDark,
    required Set<int> selectedDays,
    required ValueChanged<int> onDayToggle,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              height: 20 / 13.8,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: List.generate(7, (index) {
            final dayNumber = index + 1;
            final isSelected = selectedDays.contains(dayNumber);

            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: index < 6 ? 8.w : 0),
                child: InkWell(
                  onTap: () => onDayToggle(dayNumber),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 13.w,
                          height: 13.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                              width: 1.5.w,
                            ),
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          WorkPatternConfig.dayNames[index],
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
