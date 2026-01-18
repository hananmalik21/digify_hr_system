import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum LeaveType { annualLeave, sickLeave, unpaidLeave }

class LeaveDetailsDialog extends StatefulWidget {
  final String employeeName;
  final String employeeId;

  const LeaveDetailsDialog({super.key, required this.employeeName, required this.employeeId});

  static Future<void> show(BuildContext context, {required String employeeName, required String employeeId}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => LeaveDetailsDialog(employeeName: employeeName, employeeId: employeeId),
    );
  }

  @override
  State<LeaveDetailsDialog> createState() => _LeaveDetailsDialogState();
}

class _LeaveDetailsDialogState extends State<LeaveDetailsDialog> {
  LeaveType _selectedLeaveType = LeaveType.annualLeave;

  // Mock employee data
  final Map<String, dynamic> _employeeData = {
    'joinDate': '2020-01-15',
    'yearsOfService': 6,
    'department': 'IT',
    'position': 'Senior Developer',
  };

  // Mock summary data for Annual Leave
  final Map<LeaveType, Map<String, dynamic>> _summaryData = {
    LeaveType.annualLeave: {
      'totalAccrued': 180.0,
      'totalConsumed': 0.0,
      'currentBalance': 23.0,
      'entitlement': '30 days/year',
    },
    LeaveType.sickLeave: {
      'totalAccrued': 0.0,
      'totalConsumed': 0.0,
      'currentBalance': 15.0,
      'entitlement': '15 days full + 10 half + 10 unpaid',
    },
    LeaveType.unpaidLeave: {
      'totalAccrued': 0.0,
      'totalConsumed': 0.0,
      'currentBalance': 0.0,
      'entitlement': 'As needed',
    },
  };

  // Mock transaction history (72 entries for Annual Leave)
  List<Map<String, dynamic>> _getTransactions() {
    final transactions = <Map<String, dynamic>>[];
    final startDate = DateTime(2020, 2, 15);
    double balance = 0.0;

    for (int i = 0; i < 72; i++) {
      final date = DateTime(startDate.year, startDate.month + i, startDate.day);
      final amount = 2.5;
      balance += amount;
      transactions.add({
        'date': date,
        'type': 'Accrual',
        'description': 'Monthly Accrual - ${DateFormat('MMMM yyyy').format(date)}',
        'amount': amount,
        'balance': balance,
      });
    }

    return transactions.reversed.toList(); // Most recent first
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final summary = _summaryData[_selectedLeaveType]!;
    final transactions = _getTransactions();

    return AppDialog(
      title: 'Leave Balance Details',
      width: 896.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEmployeeInfo(context, isDark),
          Gap(20.5.h),
          _buildEmployeeInfoCards(context, isDark),
          Gap(20.5.h),
          _buildLeaveTypeSelector(context, isDark),
          Gap(20.5.h),
          _buildSummaryCards(context, summary, isDark),
          Gap(21.h),
          _buildTransactionHistory(context, transactions, isDark),
          Gap(21.h),
          _buildLaborLawSection(context, isDark),
        ],
      ),
      actions: [
        Text(
          'Last updated: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(16.w),
        _buildCloseButton(context, isDark),
        Gap(10.49.w),
        _buildExportButton(context, isDark),
      ],
    );
  }

  Widget _buildEmployeeInfo(BuildContext context, bool isDark) {
    return Text(
      '${widget.employeeName} • ${widget.employeeId}',
      style: context.textTheme.bodyMedium?.copyWith(
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildEmployeeInfoCards(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildEmployeeInfoCard(
            context: context,
            label: 'Join Date',
            value: _employeeData['joinDate'],
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildEmployeeInfoCard(
            context: context,
            label: 'Years of Service',
            value: '${_employeeData['yearsOfService']} years',
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildEmployeeInfoCard(
            context: context,
            label: 'Department',
            value: _employeeData['department'],
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildEmployeeInfoCard(
            context: context,
            label: 'Position',
            value: _employeeData['position'],
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfoCard({
    required BuildContext context,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(2.5.h),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeSelector(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Leave Type',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(7.h),
        Row(
          children: [
            Expanded(
              child: _buildLeaveTypeButton(
                context: context,
                label: 'Annual Leave',
                type: LeaveType.annualLeave,
                isDark: isDark,
              ),
            ),
            Gap(7.w),
            Expanded(
              child: _buildLeaveTypeButton(
                context: context,
                label: 'Sick Leave',
                type: LeaveType.sickLeave,
                isDark: isDark,
              ),
            ),
            Gap(7.w),
            Expanded(
              child: _buildLeaveTypeButton(
                context: context,
                label: 'Unpaid Leave',
                type: LeaveType.unpaidLeave,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaveTypeButton({
    required BuildContext context,
    required String label,
    required LeaveType type,
    required bool isDark,
  }) {
    final isSelected = _selectedLeaveType == type;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedLeaveType = type),
        borderRadius: BorderRadius.circular(7.r),
        child: Container(
          height: 42.h,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground),
            borderRadius: BorderRadius.circular(7.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, Map<String, dynamic> summary, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context: context,
            label: 'Total Accrued',
            value: '${summary['totalAccrued']} days',
            iconPath: Assets.icons.arrowUp.path,
            iconColor: AppColors.activeStatusTextLight,
            iconBg: AppColors.shiftActiveStatusBg,
            valueColor: AppColors.activeStatusTextLight,
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            context: context,
            label: 'Total Consumed',
            value: '${summary['totalConsumed']} days',
            iconPath: Assets.icons.downArrowIcon.path,
            iconColor: AppColors.error,
            iconBg: AppColors.errorBg,
            valueColor: AppColors.error,
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            context: context,
            label: 'Current Balance',
            value: '${summary['currentBalance']} days',
            iconPath: Assets.icons.calendarIcon.path,
            iconColor: AppColors.primary,
            iconBg: AppColors.infoBg,
            valueColor: AppColors.primary,
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            context: context,
            label: 'Entitlement',
            value: summary['entitlement'],
            iconPath: Assets.icons.arrowUp.path,
            iconColor: AppColors.purple,
            iconBg: AppColors.purpleBg,
            valueColor: AppColors.purple,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String label,
    required String value,
    required String iconPath,
    required Color iconColor,
    required Color iconBg,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35.w,
                height: 35.h,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(7.r)),
                child: Center(
                  child: DigifyAsset(assetPath: iconPath, width: 17.5, height: 17.5, color: iconColor),
                ),
              ),
              Gap(10.5.w),
              Expanded(
                child: Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Gap(7.h),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(BuildContext context, List<Map<String, dynamic>> transactions, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(21.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(7.r), topRight: Radius.circular(7.r)),
              border: Border(
                bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.arrowRightIcon.path,
                  width: 17.5,
                  height: 17.5,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                Gap(7.w),
                Text(
                  'Transaction History (${transactions.length} entries)',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Table
          Container(
            constraints: BoxConstraints(maxHeight: 400.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTableHeader(isDark),
                  ...transactions.map((transaction) => _buildTransactionRow(transaction, isDark)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool isDark) {
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB);
    final textColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565);

    return Container(
      color: headerColor,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 10.5.h),
      child: Row(
        children: [
          SizedBox(width: 146.22.w, child: _buildHeaderCell('Date', textColor)),
          SizedBox(width: 136.48.w, child: _buildHeaderCell('Type', textColor)),
          Expanded(child: _buildHeaderCell('Description', textColor)),
          SizedBox(
            width: 120.84.w,
            child: _buildHeaderCell('Amount', textColor, alignment: Alignment.center),
          ),
          SizedBox(
            width: 128.63.w,
            child: _buildHeaderCell('Balance', textColor, alignment: Alignment.center),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, Color color, {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 12.1.sp, fontWeight: FontWeight.w600, color: color, height: 17.5 / 12.1),
      ),
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> transaction, bool isDark) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final date = transaction['date'] as DateTime;
    final amount = transaction['amount'] as double;
    final balance = transaction['balance'] as double;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 16.h),
      child: Row(
        children: [
          SizedBox(
            width: 146.22.w,
            child: Text(
              DateFormat('MMM d, yyyy').format(date),
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          SizedBox(width: 136.48.w, child: _buildAccrualBadge(context)),
          Expanded(
            child: Text(
              transaction['description'] as String,
              style: context.textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          SizedBox(
            width: 120.84.w,
            child: Center(
              child: Text(
                '+${amount.toStringAsFixed(1)} days',
                style: context.textTheme.labelMedium?.copyWith(color: AppColors.activeStatusTextLight),
              ),
            ),
          ),
          SizedBox(
            width: 128.63.w,
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

  Widget _buildAccrualBadge(BuildContext context) {
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

  Widget _buildLaborLawSection(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.arrowRightIcon.path,
                width: 17.5,
                height: 17.5,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                'Kuwait Labor Law No. 6/2010 - Leave Entitlements',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(10.5.h),
          Row(
            children: [
              Expanded(
                child: _buildLawInfoItem(
                  context: context,
                  title: 'Annual Leave',
                  description: '30 days per year (2.5 days/month)',
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildLawInfoItem(
                  context: context,
                  title: 'Sick Leave',
                  description: '15 days full + 10 half + 10 unpaid',
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildLawInfoItem(
                  context: context,
                  title: 'Accrual Method',
                  description: 'Monthly accrual after probation',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLawInfoItem({
    required BuildContext context,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(3.5.h),
        Text(
          description,
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(11.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.5.h),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder, width: 1),
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Text(
            'Close',
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(11.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 11.25.h),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(11.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: Assets.icons.exportIconFigma.path, width: 14, height: 14, color: Colors.white),
              Gap(7.w),
              Text(
                'Export Report',
                style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
