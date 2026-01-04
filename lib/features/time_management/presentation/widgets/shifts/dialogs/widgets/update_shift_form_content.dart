import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_time_picker_dialog.dart';
import 'package:digify_hr_system/features/time_management/data/config/shift_form_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart' hide TimeOfDay;
import 'package:digify_hr_system/features/time_management/presentation/providers/update_shift_form_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_color_picker_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_time_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateShiftFormContent extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final ShiftOverview shift;
  final TextEditingController codeController;
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController durationController;
  final TextEditingController breakDurationController;
  final int enterpriseId;

  const UpdateShiftFormContent({
    super.key,
    required this.formKey,
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

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Shift Code',
                  hintText: 'e.g., DAY-SHIFT',
                  controller: codeController,
                  isRequired: true,
                  enabled: false, // Code is read-only
                  validator: (value) => FormValidators.requiredWithStateError(value, formState.errors, 'code'),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DigifyTextField(
                  labelText: 'Shift Name (English)',
                  hintText: 'e.g., Day Shift',
                  controller: nameEnController,
                  isRequired: true,
                  validator: (value) => FormValidators.requiredWithStateError(value, formState.errors, 'nameEn'),
                  onChanged: (value) => formNotifier.updateNameEn(value),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Name and Type
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Shift Name (Arabic)',
                  hintText: 'الدوام النهاري',
                  controller: nameArController,
                  isRequired: true,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  validator: (value) => FormValidators.requiredWithStateError(value, formState.errors, 'nameAr'),
                  onChanged: (value) => formNotifier.updateNameAr(value),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DigifySelectField<String>(
                  label: 'Shift Type',
                  items: ShiftFormConfig.shiftTypeOptions,
                  itemLabelBuilder: (e) => e,
                  value: formState.shiftType,
                  onChanged: (value) => formNotifier.updateShiftType(value),
                  isRequired: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Time Selection
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
              SizedBox(width: 16.w),
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
          SizedBox(height: 16.h),

          // Duration
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Duration (Hours)',
                  hintText: '8',
                  controller: durationController,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [AppInputFormatters.decimalWithOnePlace()],
                  validator: (value) {
                    final requiredError = FormValidators.requiredWithStateError(value, formState.errors, 'duration');
                    if (requiredError != null) {
                      return requiredError;
                    }
                    return FormValidators.positiveNumber(value);
                  },
                  onChanged: (value) => formNotifier.updateDuration(value),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DigifyTextField(
                  labelText: 'Break Duration (Hours)',
                  hintText: '1',
                  controller: breakDurationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [AppInputFormatters.decimalWithOnePlace()],
                  onChanged: (value) => formNotifier.updateBreakDuration(value),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Appearance and Status
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
              SizedBox(width: 16.w),
              Expanded(
                child: DigifySelectField<String>(
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
      ),
    );
  }
}
