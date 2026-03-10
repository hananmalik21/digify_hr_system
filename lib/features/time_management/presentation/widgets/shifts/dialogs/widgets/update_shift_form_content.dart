import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_time_picker_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/time_management/data/config/shift_form_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart' hide TimeOfDay;
import 'package:digify_hr_system/features/time_management/presentation/providers/update_shift_form_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_color_picker_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_time_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpdateShiftFormContent extends ConsumerWidget {
  final ShiftOverview shift;
  final TextEditingController codeController;
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController durationController;
  final TextEditingController breakDurationController;
  final int enterpriseId;

  const UpdateShiftFormContent({
    super.key,
    required this.shift,
    required this.codeController,
    required this.nameEnController,
    required this.nameArController,
    required this.durationController,
    required this.breakDurationController,
    required this.enterpriseId,
  });

  Future<void> _selectTime(BuildContext context, WidgetRef ref, bool isStartTime) async {
    final params = (shift: shift, enterpriseId: enterpriseId);
    final formNotifier = ref.read(updateShiftFormProvider(params).notifier);
    final formState = ref.read(updateShiftFormProvider(params));
    final currentTime = isStartTime ? formState.startTime : formState.endTime;

    final TimeOfDay? picked = await DigifyTimePickerDialog.show(
      context,
      initialTime: isStartTime
          ? (currentTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (currentTime ?? const TimeOfDay(hour: 17, minute: 0)),
    );

    if (picked != null) {
      if (isStartTime) {
        formNotifier.updateStartTime(picked);
      } else {
        formNotifier.updateEndTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (shift: shift, enterpriseId: enterpriseId);
    final formState = ref.watch(updateShiftFormProvider(params));
    final formNotifier = ref.read(updateShiftFormProvider(params).notifier);
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'Shift Code',
                hintText: 'e.g., DAY-SHIFT',
                controller: codeController,
                isRequired: true,
                enabled: false,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                labelText: 'Shift Name (English)',
                hintText: 'e.g., Day Shift',
                controller: nameEnController,
                isRequired: true,
                onChanged: (value) => formNotifier.updateNameEn(value),
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'Shift Name (Arabic)',
                hintText: 'Enter shift name in Arabic (Optional)',
                controller: nameArController,
                isRequired: false,
                inputFormatters: [AppInputFormatters.nameAny],
                onChanged: (value) => formNotifier.updateNameAr(value),
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifySelectFieldWithLabel<String>(
                label: 'Shift Type',
                items: ShiftFormConfig.shiftTypeOptions,
                itemLabelBuilder: (e) => e,
                value: ShiftFormConfig.shiftTypeOptions.contains(formState.shiftType)
                    ? formState.shiftType!
                    : shift.shiftType.displayName,
                onChanged: (value) => formNotifier.updateShiftType(value),
                isRequired: true,
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShiftTimePickerField(
                label: 'Start Time',
                hintText: '09:00 AM',
                time: formState.startTime,
                onTap: () => _selectTime(context, ref, true),
                isDark: isDark,
                isRequired: true,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: ShiftTimePickerField(
                label: 'End Time',
                hintText: '05:00 PM',
                time: formState.endTime,
                onTap: () => _selectTime(context, ref, false),
                isDark: isDark,
                isRequired: true,
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'Duration (Hours)',
                hintText: '8',
                controller: durationController,
                isRequired: true,
                readOnly: true,
                enabled: false,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                labelText: 'Break Duration (Hours)',
                hintText: '1',
                controller: breakDurationController,
                readOnly: true,
                enabled: false,
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ShiftColorPickerField(
                selectedColor: formState.selectedColor,
                onColorChanged: (color) => formNotifier.updateColor(color),
                isDark: isDark,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifySelectFieldWithLabel<String>(
                label: 'Status',
                items: ShiftFormConfig.statusOptions,
                itemLabelBuilder: (e) => e,
                value: formState.status,
                onChanged: (value) => formNotifier.updateStatus(value!),
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
