import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
// import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';
import '../providers/overtime/new_overtime_provider.dart';

class NewOvertimeRequestDialog extends ConsumerWidget {
  NewOvertimeRequestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NewOvertimeRequestDialog(),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    // final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(newOvertimeRequestProvider);
    final notifier = ref.read(newOvertimeRequestProvider.notifier);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 550.w,
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(context, isDark, notifier),
                Expanded(child: _buildBody(context, isDark, state, notifier)),
                _buildFooter(context, isDark, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header
  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    NewOvertimeRequestNotifier notifier,
  ) {
    final title = 'New Overtime Request';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(Icons.cancel_outlined, size: 20.r, color: Colors.white),
            onPressed: () {
              notifier.reset();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Body
  Widget _buildBody(
    BuildContext context,
    bool isDark,
    NewOvertimeRequestFormState state,
    NewOvertimeRequestNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField(
            labelText: "Select Employee",
            isRequired: true,
            onChanged: (value) => notifier.setEmployee(employeeName: value),
            hintText: 'Type to search employees...',
            prefixIcon: Icon(Icons.search_outlined, size: 20.r),
            suffixIcon: Icon(Icons.arrow_drop_down_outlined, size: 20.r),
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyDateField(
              label: "Overtime Date",
              onDateSelected: (value) => notifier.setDate(value),
              hintText: 'Select overtime date',
            ),
            Gap(16.h),
            DigifySelectFieldWithLabel<String>(
              label: "Overtime Type",
              hint: 'Select overtime type',
              onChanged: (value) => notifier.setOvertimeType(value),
              items: [],
              itemLabelBuilder: (Object p1) => "",
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyDateField(
                    label: "Overtime Date",
                    onDateSelected: (value) => notifier.setDate(value),
                    hintText: 'Select overtime date',
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifySelectFieldWithLabel<String>(
                    label: "Overtime Type",
                    onChanged: (value) => notifier.setOvertimeType(value),
                    items: [],
                    itemLabelBuilder: (Object p1) => "",
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField.normal(
              labelText: "Number of Hours",
              onChanged: (value) => notifier.setNumberOfHours(value),
              hintText: 'Type number of hours',
            ),
            Gap(16.h),
            DigifyTextField(
              labelText: "Estimated Rate",
              enabled: false,
              filled: true,
              fillColor: AppColors.primary.withValues(alpha: 0.1),
              initialValue: "",
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField.normal(
                    labelText: "Number of Hours",
                    onChanged: (value) => notifier.setNumberOfHours(value),
                    hintText: 'Type number of hours',
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyTextField(
                    labelText: "Estimated Rate",
                    enabled: false,
                    filled: true,
                    fillColor: AppColors.primary.withValues(alpha: 0.1),
                    initialValue: "",
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          DigifyTextArea(
            labelText: "Justification Reason",
            onChanged: (value) => notifier.setReason(value),
            hintText: 'Provide a detailed reason for the overtime request...',
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  /// Footer
  Widget _buildFooter(
    BuildContext context,
    bool isDark,
    NewOvertimeRequestNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            type: AppButtonType.outline,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textSecondary,
            height: 40.h,
            borderRadius: BorderRadius.circular(7.0),
            fontSize: 14.sp,
          ),
          Gap(12.w),
          AppButton(
            label: 'Submit Request',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop();
              }
            },
            type: AppButtonType.primary,
            icon: Icons.add,
            height: 40.h,
            borderRadius: BorderRadius.circular(7.0),
            fontSize: 14.sp,
          ),
        ],
      ),
    );
  }
}
