import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/work_pattern_selection_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:ui' as ui;

class WorkScheduleFormFields extends StatefulWidget {
  final TextEditingController scheduleCodeController;
  final TextEditingController scheduleNameEnController;
  final TextEditingController scheduleNameArController;
  final TextEditingController effectiveStartDateController;
  final TextEditingController effectiveEndDateController;
  final WorkPattern? selectedWorkPattern;
  final int enterpriseId;
  final PositionStatus selectedStatus;
  final bool isScheduleCodeDisabled;
  final ValueChanged<String>? onScheduleCodeChanged;
  final ValueChanged<String>? onScheduleNameEnChanged;
  final ValueChanged<String>? onScheduleNameArChanged;
  final ValueChanged<WorkPattern?> onWorkPatternChanged;
  final ValueChanged<PositionStatus> onStatusChanged;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;

  const WorkScheduleFormFields({
    super.key,
    required this.scheduleCodeController,
    required this.scheduleNameEnController,
    required this.scheduleNameArController,
    required this.effectiveStartDateController,
    required this.effectiveEndDateController,
    this.selectedWorkPattern,
    required this.enterpriseId,
    required this.selectedStatus,
    this.isScheduleCodeDisabled = false,
    this.onScheduleCodeChanged,
    this.onScheduleNameEnChanged,
    this.onScheduleNameArChanged,
    required this.onWorkPatternChanged,
    required this.onStatusChanged,
    required this.onStartDateTap,
    required this.onEndDateTap,
  });

  @override
  State<WorkScheduleFormFields> createState() => _WorkScheduleFormFieldsState();
}

class _WorkScheduleFormFieldsState extends State<WorkScheduleFormFields> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DigifyTextField(
                controller: widget.scheduleCodeController,
                labelText: 'Schedule Code',
                hintText: 'e.g., SCH-ADMIN-2024',
                isRequired: true,
                readOnly: widget.isScheduleCodeDisabled,
                enabled: !widget.isScheduleCodeDisabled,
                onChanged: widget.onScheduleCodeChanged,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Schedule code is required';
                  }
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-_]'))],
              ),
            ),
            Gap(24.w),
            Expanded(
              child: DigifyTextField(
                controller: widget.scheduleNameEnController,
                labelText: 'Schedule Name (English)',
                hintText: 'e.g., Admin Department Schedule 2024',
                isRequired: true,
                onChanged: widget.onScheduleNameEnChanged,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Schedule name (English) is required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        Gap(24.h),
        Row(
          children: [
            Expanded(
              child: DigifyTextField(
                controller: widget.scheduleNameArController,
                labelText: 'Schedule Name (Arabic)',
                hintText: 'جدول الدوام القياسي',
                isRequired: true,
                textDirection: ui.TextDirection.rtl,
                textAlign: TextAlign.right,
                onChanged: widget.onScheduleNameArChanged,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Schedule name (Arabic) is required';
                  }
                  return null;
                },
                inputFormatters: [AppInputFormatters.nameAr],
              ),
            ),
            Gap(24.w),
            Expanded(
              child: WorkPatternSelectionField(
                label: 'Work Pattern',
                isRequired: true,
                enterpriseId: widget.enterpriseId,
                selectedWorkPattern: widget.selectedWorkPattern,
                onChanged: widget.onWorkPatternChanged,
              ),
            ),
          ],
        ),
        Gap(24.h),
        Row(
          children: [
            Expanded(
              child: DigifyTextField(
                controller: widget.effectiveStartDateController,
                labelText: 'Effective Start Date',
                hintText: 'YYYY-MM-DD',
                isRequired: true,
                readOnly: true,
                onTap: widget.onStartDateTap,
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: 20.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Effective start date is required';
                  }
                  return null;
                },
              ),
            ),
            Gap(24.w),
            Expanded(
              child: DigifyTextField(
                controller: widget.effectiveEndDateController,
                labelText: 'Effective End Date',
                hintText: 'YYYY-MM-DD (optional)',
                readOnly: true,
                onTap: widget.onEndDateTap,
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: 20.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        Gap(24.h),
        Row(
          children: [
            Expanded(
              child: DigifySelectFieldWithLabel<PositionStatus>(
                label: 'Status',
                value: widget.selectedStatus,
                items: [PositionStatus.active, PositionStatus.inactive],
                itemLabelBuilder: (status) => status == PositionStatus.active ? 'Active' : 'Inactive',
                onChanged: (value) {
                  if (value != null) {
                    widget.onStatusChanged(value);
                  }
                },
                isRequired: true,
              ),
            ),
            Gap(24.w),
            const Expanded(child: Gap(0)),
          ],
        ),
      ],
    );
  }
}
