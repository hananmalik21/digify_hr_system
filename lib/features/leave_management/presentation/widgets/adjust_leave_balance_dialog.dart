import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart' show DigifyTextField, DigifyTextArea;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustLeaveBalanceDialog extends StatefulWidget {
  final String employeeName;
  final String employeeId;
  final int currentAnnualLeave;
  final int currentSickLeave;
  final int currentUnpaidLeave;

  const AdjustLeaveBalanceDialog({
    super.key,
    required this.employeeName,
    required this.employeeId,
    required this.currentAnnualLeave,
    required this.currentSickLeave,
    required this.currentUnpaidLeave,
  });

  static Future<void> show(
    BuildContext context, {
    required String employeeName,
    required String employeeId,
    required int currentAnnualLeave,
    required int currentSickLeave,
    required int currentUnpaidLeave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AdjustLeaveBalanceDialog(
        employeeName: employeeName,
        employeeId: employeeId,
        currentAnnualLeave: currentAnnualLeave,
        currentSickLeave: currentSickLeave,
        currentUnpaidLeave: currentUnpaidLeave,
      ),
    );
  }

  @override
  State<AdjustLeaveBalanceDialog> createState() => _AdjustLeaveBalanceDialogState();
}

class _AdjustLeaveBalanceDialogState extends State<AdjustLeaveBalanceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _annualLeaveController;
  late TextEditingController _sickLeaveController;
  late TextEditingController _unpaidLeaveController;
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _annualLeaveController = TextEditingController(text: widget.currentAnnualLeave.toString());
    _sickLeaveController = TextEditingController(text: widget.currentSickLeave.toString());
    _unpaidLeaveController = TextEditingController(text: widget.currentUnpaidLeave.toString());
    _reasonController = TextEditingController();

    // Add listeners to update comparison section when values change
    _annualLeaveController.addListener(() => setState(() {}));
    _sickLeaveController.addListener(() => setState(() {}));
    _unpaidLeaveController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _annualLeaveController.dispose();
    _sickLeaveController.dispose();
    _unpaidLeaveController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.theme.brightness == Brightness.dark;

    return AppDialog(
      title: 'Adjust Leave Balance',
      subtitle: widget.employeeName,
      width: 700.w,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLeaveBalanceFieldsRow(context),
            Gap(14.h),
            _buildComparisonSection(context, isDark),
            Gap(14.h),
            _buildReasonField(context),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: localizations.cancel,
          type: AppButtonType.outline,
          onPressed: () => Navigator.of(context).pop(),
        ),
        Gap(12.w),
        AppButton(
          label: 'Update Balance',
          type: AppButtonType.primary,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _buildLeaveBalanceFieldsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DigifyTextField.number(
            controller: _annualLeaveController,
            labelText: 'Annual Leave (days)',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Annual leave is required';
              }
              return null;
            },
          ),
        ),
        Gap(14.w),
        Expanded(
          child: DigifyTextField.number(
            controller: _sickLeaveController,
            labelText: 'Sick Leave (days)',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Sick leave is required';
              }
              return null;
            },
          ),
        ),
        Gap(14.w),
        Expanded(
          child: DigifyTextField.number(
            controller: _unpaidLeaveController,
            labelText: 'Unpaid Leave (days)',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Unpaid leave is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSection(BuildContext context, bool isDark) {
    final previousAnnual = widget.currentAnnualLeave;
    final previousSick = widget.currentSickLeave;
    final newAnnual = int.tryParse(_annualLeaveController.text) ?? previousAnnual;
    final newSick = int.tryParse(_sickLeaveController.text) ?? previousSick;

    final labelStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final valueStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final newValueStyle = context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.primary);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(7.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Previous Annual:', style: labelStyle),
                    Gap(7.w),
                    Text('$previousAnnual days', style: valueStyle),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('New Annual:', style: labelStyle),
                    Gap(7.w),
                    Text('$newAnnual days', style: newValueStyle),
                  ],
                ),
              ),
            ],
          ),
          Gap(6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Previous Sick:', style: labelStyle),
                    Gap(7.w),
                    Text('$previousSick days', style: valueStyle),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('New Sick:', style: labelStyle),
                    Gap(7.w),
                    Text('$newSick days', style: newValueStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonField(BuildContext context) {
    return DigifyTextArea(
      controller: _reasonController,
      labelText: 'Adjustment Reason',
      hintText: 'E.g., Annual leave accrual, Manual correction, Carried forward from previous year...',
      isRequired: true,
      minLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Adjustment reason is required';
        }
        return null;
      },
    );
  }
}
