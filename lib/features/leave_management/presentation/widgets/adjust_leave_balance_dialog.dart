import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart' show DigifyTextField, DigifyTextArea;
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/adjust_leave_balance_validation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustLeaveBalanceDialog extends ConsumerStatefulWidget {
  final LeaveBalanceSummaryItem item;
  final LeaveBalance? balance;

  const AdjustLeaveBalanceDialog({super.key, required this.item, this.balance});

  static Future<AdjustLeaveBalanceResult?> show(
    BuildContext context, {
    required LeaveBalanceSummaryItem item,
    LeaveBalance? balance,
  }) {
    return showDialog<AdjustLeaveBalanceResult>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AdjustLeaveBalanceDialog(item: item, balance: balance),
    );
  }

  @override
  ConsumerState<AdjustLeaveBalanceDialog> createState() => _AdjustLeaveBalanceDialogState();
}

class _AdjustLeaveBalanceDialogState extends ConsumerState<AdjustLeaveBalanceDialog> {
  late TextEditingController _annualLeaveController;
  late TextEditingController _sickLeaveController;
  late TextEditingController _unpaidLeaveController;
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _annualLeaveController = TextEditingController(text: _formatDouble(item.annualLeave));
    _sickLeaveController = TextEditingController(text: _formatDouble(item.sickLeave));
    _unpaidLeaveController = TextEditingController(text: '0');
    _reasonController = TextEditingController();
  }

  String _formatDouble(double v) {
    return v == v.toInt() ? v.toInt().toString() : v.toString();
  }

  @override
  void dispose() {
    _annualLeaveController.dispose();
    _sickLeaveController.dispose();
    _unpaidLeaveController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final validation = ref.read(adjustLeaveBalanceValidationProvider);
    final error = validation.validate(
      annualLeaveStr: _annualLeaveController.text,
      sickLeaveStr: _sickLeaveController.text,
      unpaidLeaveStr: _unpaidLeaveController.text,
      reason: _reasonController.text,
    );
    if (error != null) {
      ToastService.warning(context, error);
      return;
    }
    final b = widget.balance;
    if (b == null) {
      context.pop<AdjustLeaveBalanceResult?>(null);
      return;
    }
    final result = AdjustLeaveBalanceResult(
      employeeLeaveBalanceGuid: b.employeeLeaveBalanceGuid,
      openingBalanceDays: b.openingBalanceDays,
      accruedDays: b.accruedDays,
      takenDays: b.takenDays,
      adjustedDays: b.adjustedDays,
      availableDays: (double.tryParse(_annualLeaveController.text) ?? 0).toDouble(),
      status: b.status,
      comments: _reasonController.text.trim(),
    );
    ToastService.success(context, 'Leave balance updated successfully');
    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.theme.brightness == Brightness.dark;

    return AppDialog(
      title: 'Adjust Leave Balance',
      subtitle: widget.item.employeeName,
      width: 700.w,
      content: Column(
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
      actions: [
        AppButton(label: localizations.cancel, type: AppButtonType.outline, onPressed: () => context.pop()),
        Gap(12.w),
        AppButton(label: 'Update Balance', type: AppButtonType.primary, onPressed: _submit),
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
            onChanged: (_) => setState(() {}),
          ),
        ),
        Gap(14.w),
        Expanded(
          child: DigifyTextField.number(
            controller: _sickLeaveController,
            labelText: 'Sick Leave (days)',
            isRequired: true,
            onChanged: (_) => setState(() {}),
          ),
        ),
        Gap(14.w),
        Expanded(
          child: DigifyTextField.number(
            controller: _unpaidLeaveController,
            labelText: 'Unpaid Leave (days)',
            isRequired: true,
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSection(BuildContext context, bool isDark) {
    final previousAnnual = _formatDouble(widget.item.annualLeave);
    final previousSick = _formatDouble(widget.item.sickLeave);
    const previousUnpaid = '0';
    final newAnnual = _annualLeaveController.text;
    final newSick = _sickLeaveController.text;
    final newUnpaid = _unpaidLeaveController.text;

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
                    Text('${newAnnual.isEmpty ? '0' : newAnnual} days', style: newValueStyle),
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
                    Text('${newSick.isEmpty ? '0' : newSick} days', style: newValueStyle),
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
                    Text('Previous Unpaid:', style: labelStyle),
                    Gap(7.w),
                    Text('$previousUnpaid days', style: valueStyle),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('New Unpaid:', style: labelStyle),
                    Gap(7.w),
                    Text('${newUnpaid.isEmpty ? '0' : newUnpaid} days', style: newValueStyle),
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
    );
  }
}
