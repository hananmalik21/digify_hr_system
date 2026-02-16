import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_table_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveDetailsTransactionSection extends StatelessWidget {
  const LeaveDetailsTransactionSection({
    super.key,
    required this.transactions,
    required this.isDark,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = LeaveDetailsTransactionTableConfig.defaultPageSize,
    this.onPrevious,
    this.onNext,
  });

  final List<Map<String, dynamic>> transactions;
  final bool isDark;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeaveDetailsTransactionTableHeader(isDark: isDark),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 360.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: transactions.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: Center(
                        child: Text(
                          'No transactions',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: transactions
                          .map((t) => LeaveDetailsTransactionRow(transaction: t, isDark: isDark))
                          .toList(),
                    ),
            ),
          ),
          if (paginationInfo != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo!,
              currentPage: currentPage,
              pageSize: pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }
}

class LeaveDetailsTransactionTableHeader extends StatelessWidget {
  const LeaveDetailsTransactionTableHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText;
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    return Container(
      color: headerColor,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: LeaveDetailsTransactionTableConfig.cellPaddingHorizontal.w,
        vertical: LeaveDetailsTransactionTableConfig.headerPaddingVertical.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.dateWidth.w,
            child: _HeaderCell(text: 'Date', color: textColor),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.typeWidth.w,
            child: _HeaderCell(text: 'Type', color: textColor),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          Expanded(
            child: _HeaderCell(text: 'Description', color: textColor),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.amountWidth.w,
            child: _HeaderCell(text: 'Amount', color: textColor, alignment: Alignment.center),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.balanceWidth.w,
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

class LeaveDetailsTransactionRow extends StatelessWidget {
  const LeaveDetailsTransactionRow({super.key, required this.transaction, required this.isDark});

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
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: LeaveDetailsTransactionTableConfig.cellPaddingHorizontal.w,
        vertical: LeaveDetailsTransactionTableConfig.rowPaddingVertical.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.dateWidth.w,
            child: Text(
              DateFormat('MMM d, yyyy').format(date),
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.typeWidth.w,
            child: Align(
              alignment: Alignment.centerLeft,
              child: DigifyCapsule(label: 'Accrual'),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          Expanded(
            child: Text(
              transaction['description'] as String,
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.amountWidth.w,
            child: Center(
              child: Text(
                '+${amount.toStringAsFixed(1)} days',
                style: context.textTheme.labelMedium?.copyWith(color: AppColors.activeStatusTextLight),
              ),
            ),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.balanceWidth.w,
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
