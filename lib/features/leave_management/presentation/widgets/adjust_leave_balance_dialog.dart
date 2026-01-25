import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart' show DigifyTextField, DigifyTextArea;
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustLeaveBalanceDialog extends ConsumerStatefulWidget {
  final LeaveBalance balance;

  const AdjustLeaveBalanceDialog({super.key, required this.balance});

  static Future<void> show(BuildContext context, {required LeaveBalance balance}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AdjustLeaveBalanceDialog(balance: balance),
    );
  }

  @override
  ConsumerState<AdjustLeaveBalanceDialog> createState() => _AdjustLeaveBalanceDialogState();
}

class _AdjustLeaveBalanceDialogState extends ConsumerState<AdjustLeaveBalanceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _annualLeaveController;
  late TextEditingController _sickLeaveController;
  late TextEditingController _unpaidLeaveController;
  late TextEditingController _reasonController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final b = widget.balance;
    _annualLeaveController = TextEditingController(text: _formatDouble(b.availableDays));
    _sickLeaveController = TextEditingController(text: '0');
    _unpaidLeaveController = TextEditingController(text: '0');
    _reasonController = TextEditingController();

    _annualLeaveController.addListener(() => setState(() {}));
    _sickLeaveController.addListener(() => setState(() {}));
    _unpaidLeaveController.addListener(() => setState(() {}));
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    final params = UpdateLeaveBalanceParams(
      openingBalanceDays: widget.balance.openingBalanceDays,
      accruedDays: widget.balance.accruedDays,
      takenDays: widget.balance.takenDays,
      adjustedDays: widget.balance.adjustedDays,
      availableDays: (int.tryParse(_annualLeaveController.text) ?? 0).toDouble(),
      status: widget.balance.status,
      comments: _reasonController.text.trim(),
    );

    try {
      await ref
          .read(leaveBalancesNotifierProvider.notifier)
          .updateLeaveBalance(widget.balance.employeeLeaveBalanceGuid, params);
      if (!mounted) return;
      ToastService.success(context, 'Leave balance updated successfully');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.theme.brightness == Brightness.dark;

    return AppDialog(
      title: 'Adjust Leave Balance',
      subtitle: widget.balance.employeeName,
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
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
        ),
        Gap(12.w),
        AppButton(
          label: 'Update Balance',
          type: AppButtonType.primary,
          onPressed: _isSubmitting ? null : _submit,
          isLoading: _isSubmitting,
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
    final previousAnnual = _formatDouble(widget.balance.availableDays);
    final previousSick = '0';
    final newAnnual = _annualLeaveController.text;
    final newSick = _sickLeaveController.text;

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
