import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
// import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../core/widgets/feedback/app_dialog.dart';
import '../providers/overtime/new_overtime_provider.dart';

class NewOvertimeRequestDialog extends ConsumerWidget {
  NewOvertimeRequestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => NewOvertimeRequestDialog());
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(newOvertimeRequestProvider.notifier);

    return AppDialog(
      title: 'Add New Overtimes',
      subtitle: 'Fill out the required information to apply for the overtime.',
      width: 600.w,
      onClose: () {
        notifier.reset();
        Navigator.of(context).pop();
      },
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyTextField(
              labelText: "Employee Name",
              isRequired: true,
              onChanged: (value) => notifier.setEmployee(employeeName: value),
              hintText: 'Type to search employees...',
              prefixIcon: Icon(Icons.search_outlined, size: 20.r),
              suffixIcon: Icon(Icons.arrow_drop_down_outlined, size: 20.r),
            ),
            Gap(16.h),
            if (context.isMobile) ...[
              DigifySelectFieldWithLabel<String>(
                label: "Overtime Category",
                hint: 'Select overtime category',
                onChanged: (value) => notifier.setOvertimeType(value),
                items: [],
                itemLabelBuilder: (Object p1) => "",
              ),
              Gap(16.h),
              DigifyTextField(
                labelText: "Rate Per Hour",
                enabled: false,
                filled: true,
                fillColor: AppColors.primary.withValues(alpha: 0.05),
                initialValue: "",
              ),
              Gap(16.h),
              DigifyDateField(
                label: "Date",
                onDateSelected: (value) => notifier.setDate(value),
                hintText: 'Select overtime date',
              ),
              Gap(16.h),
              DigifyTextField.normal(
                labelText: "Number of Hours",
                onChanged: (value) => notifier.setNumberOfHours(value),
                hintText: 'Type number of hours',
              ),
              Gap(16.h),
              DigifyTextField.normal(labelText: "Time In", onChanged: (value) {}, hintText: 'Time In'),
              Gap(16.h),
              DigifyTextField.normal(labelText: "Time Out", onChanged: (value) {}, hintText: 'Time Out'),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: DigifySelectFieldWithLabel<String>(
                      label: "Overtime Category",
                      onChanged: (value) => notifier.setOvertimeType(value),
                      items: [],
                      itemLabelBuilder: (Object p1) => "",
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifyTextField(
                      labelText: "Rate Per Hour",
                      enabled: false,
                      filled: true,
                      fillColor: AppColors.primary.withValues(alpha: 0.05),
                      initialValue: "",
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: DigifyDateField(
                      label: "Date",
                      onDateSelected: (value) => notifier.setDate(value),
                      hintText: 'Select overtime date',
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifyTextField.normal(
                      labelText: "Number of Hours",
                      onChanged: (value) => notifier.setNumberOfHours(value),
                      hintText: 'Type number of hours',
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: DigifyTextField.normal(labelText: "Time In", onChanged: (value) {}, hintText: 'Time In'),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifyTextField.normal(labelText: "Time Out", onChanged: (value) {}, hintText: 'Time Out'),
                  ),
                ],
              ),
            ],
            Gap(16.h),
            DigifyTextArea(
              labelText: "Remarks",
              onChanged: (value) => notifier.setReason(value),
              hintText: 'Provide a detailed reason for the overtime request...',
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          onPressed: () {
            notifier.reset();
            Navigator.of(context).pop();
          },
          type: AppButtonType.outline,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textSecondary,
          height: 40.h,
          borderRadius: BorderRadius.circular(7.0),
          fontSize: 14.sp,
        ),
        Gap(12.w),
        AppButton(
          label: 'Save',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
            }
          },
          type: AppButtonType.primary,
          icon: null,
          height: 40.h,
          borderRadius: BorderRadius.circular(7.0),
          fontSize: 14.sp,
        ),
      ],
    );
  }
}
