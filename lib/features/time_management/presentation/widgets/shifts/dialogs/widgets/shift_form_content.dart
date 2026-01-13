import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_time_picker_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/time_management/data/config/shift_form_config.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shift_form_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_color_picker_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_time_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftFormContent extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController durationController;
  final TextEditingController breakDurationController;
  final int enterpriseId;

  const ShiftFormContent({
    super.key,
    required this.formKey,
    required this.codeController,
    required this.nameEnController,
    required this.nameArController,
    required this.durationController,
    required this.breakDurationController,
    required this.enterpriseId,
  });

  Future<void> _selectTime(BuildContext context, WidgetRef ref, bool isStartTime) async {
    final formNotifier = ref.read(shiftFormProvider(enterpriseId).notifier);
    final currentTime = isStartTime
        ? ref.read(shiftFormProvider(enterpriseId)).startTime
        : ref.read(shiftFormProvider(enterpriseId)).endTime;

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
    final formState = ref.watch(shiftFormProvider(enterpriseId));
    final formNotifier = ref.read(shiftFormProvider(enterpriseId).notifier);
    final isDark = context.isDark;

    return Form(
      key: formKey,
      child: Column(
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
                  validator: (value) => FormValidators.requiredWithStateError(value, formState.errors, 'code'),
                  onChanged: (value) => formNotifier.updateCode(value),
                ),
              ),
              Gap(16.w),
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
          Gap(16.h),

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
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
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
                  enabled: false,
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
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  labelText: 'Break Duration (Hours)',
                  hintText: '1',
                  controller: breakDurationController,
                  isRequired: true,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [AppInputFormatters.decimalWithOnePlace()],
                  validator: (value) => FormValidators.requiredWithStateError(value, formState.errors, 'breakDuration'),
                  onChanged: (value) => formNotifier.updateBreakDuration(value),
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
      ),
    );
  }
}
