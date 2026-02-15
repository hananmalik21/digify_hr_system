import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog_styles.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveDetailsTransactionSection extends StatelessWidget {
  const LeaveDetailsTransactionSection({super.key, required this.transactions, required this.isDark});

  final List<Map<String, dynamic>> transactions;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: leaveDetailsCardDecoration(isDark),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.arrowRightIcon.path,
                  width: 18,
                  height: 18,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                Gap(8.w),
                Text(
                  'Transaction History (${transactions.length} entries)',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 360.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TableHeader(isDark: isDark),
                  ...transactions.map((t) => _TransactionRow(transaction: t, isDark: isDark)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Container(
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 110.w,
            child: _HeaderCell(text: 'Date', color: textColor),
          ),
          SizedBox(
            width: 100.w,
            child: _HeaderCell(text: 'Type', color: textColor),
          ),
          Expanded(
            child: _HeaderCell(text: 'Description', color: textColor),
          ),
          SizedBox(
            width: 90.w,
            child: _HeaderCell(text: 'Amount', color: textColor, alignment: Alignment.center),
          ),
          SizedBox(
            width: 90.w,
            child: _HeaderCell(text: 'Balance', color: textColor, alignment: Alignment.center),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, required this.color, this.alignment = Alignment.centerLeft});

  final String text;
  final Color color;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction, required this.isDark});

  final Map<String, dynamic> transaction;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final date = transaction['date'] as DateTime;
    final amount = transaction['amount'] as double;
    final balance = transaction['balance'] as double;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              DateFormat('MMM d, yyyy').format(date),
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          SizedBox(width: 100.w, child: _AccrualBadge()),
          Expanded(
            child: Text(
              transaction['description'] as String,
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          SizedBox(
            width: 90.w,
            child: Center(
              child: Text(
                '+${amount.toStringAsFixed(1)} days',
                style: context.textTheme.labelMedium?.copyWith(color: AppColors.activeStatusTextLight),
              ),
            ),
          ),
          SizedBox(
            width: 90.w,
            child: Center(
              child: Text(
                '${balance.toStringAsFixed(1)} days',
                style: context.textTheme.labelMedium?.copyWith(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccrualBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: AppColors.shiftActiveStatusBg, borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('+', style: context.textTheme.labelSmall?.copyWith(color: AppColors.activeStatusTextLight)),
          Gap(3.5.w),
          Text('Accrual', style: context.textTheme.labelMedium?.copyWith(color: AppColors.activeStatusTextLight)),
        ],
      ),
    );
  }
}
