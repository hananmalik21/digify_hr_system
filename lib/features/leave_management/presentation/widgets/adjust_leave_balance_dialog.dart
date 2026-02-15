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
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustLeaveBalanceDialog extends ConsumerStatefulWidget {
  final LeaveBalanceSummaryItem item;
  final LeaveBalance? balance;

  const AdjustLeaveBalanceDialog({super.key, required this.item, this.balance});

  static Future<void> show(BuildContext context, {required LeaveBalanceSummaryItem item, LeaveBalance? balance}) {
    return showDialog<void>(
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
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _annualLeaveController = TextEditingController(text: _formatDouble(item.annualLeave));
    _sickLeaveController = TextEditingController(text: _formatDouble(item.sickLeave));
    _reasonController = TextEditingController();
  }

  String _formatDouble(double v) {
    return v == v.toInt() ? v.toInt().toString() : v.toString();
  }

  @override
  void dispose() {
    _annualLeaveController.dispose();
    _sickLeaveController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final validation = ref.read(adjustLeaveBalanceValidationProvider);
    final error = validation.validate(
      annualLeaveStr: _annualLeaveController.text,
      sickLeaveStr: _sickLeaveController.text,
      reason: _reasonController.text,
    );
    if (error != null) {
      ToastService.warning(context, error);
      return;
    }
    final annualDays = (double.tryParse(_annualLeaveController.text) ?? 0).toDouble();
    final sickDays = (double.tryParse(_sickLeaveController.text) ?? 0).toDouble();
    final payload = AdjustLeaveBalancePayload(
      employeeId: widget.item.employeeId,
      reason: _reasonController.text.trim(),
      annualDays: annualDays,
      sickDays: sickDays,
    );
    ref.read(leaveBalancesNotifierProvider.notifier).submitAdjustment(payload);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.theme.brightness == Brightness.dark;
    final balancesState = ref.watch(leaveBalancesNotifierProvider);
    final isUpdating = balancesState.isUpdating;

    ref.listen<LeaveBalancesState>(leaveBalancesNotifierProvider, (previous, next) {
      if (previous?.isUpdating == true && next.isUpdating == false) {
        if (!context.mounted) return;
        if (next.updateError != null) {
          ToastService.error(context, next.updateError!);
        } else {
          context.pop();
          ToastService.success(context, 'Leave balances adjusted successfully');
        }
      }
    });

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
        AppButton(
          label: localizations.cancel,
          type: AppButtonType.outline,
          onPressed: isUpdating ? null : () => context.pop(),
        ),
        Gap(12.w),
        AppButton(
          label: 'Update Balance',
          type: AppButtonType.primary,
          onPressed: isUpdating ? null : _submit,
          isLoading: isUpdating,
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
      ],
    );
  }

  Widget _buildComparisonSection(BuildContext context, bool isDark) {
    final previousAnnual = _formatDouble(widget.item.annualLeave);
    final previousSick = _formatDouble(widget.item.sickLeave);
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
    );
  }
}
