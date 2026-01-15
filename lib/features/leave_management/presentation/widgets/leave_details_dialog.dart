import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum LeaveType { annualLeave, sickLeave, unpaidLeave }

class LeaveDetailsDialog extends StatefulWidget {
  final String employeeName;
  final String employeeId;

  const LeaveDetailsDialog({
    super.key,
    required this.employeeName,
    required this.employeeId,
  });

  static void show(
    BuildContext context, {
    required String employeeName,
    required String employeeId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => LeaveDetailsDialog(
        employeeName: employeeName,
        employeeId: employeeId,
      ),
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
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final summary = _summaryData[_selectedLeaveType]!;
    final transactions = _getTransactions();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 896.w, maxHeight: 800.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, isDark),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmployeeInfoCards(isDark),
                      Gap(20.5.h),
                      _buildLeaveTypeSelector(isDark),
                      Gap(20.5.h),
                      _buildSummaryCards(summary, isDark),
                      Gap(21.h),
                      _buildTransactionHistory(transactions, isDark),
                      Gap(21.h),
                      _buildLaborLawSection(isDark),
                    ],
                  ),
                ),
              ),
              _buildFooter(context, isDark, localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 21.h),
      decoration: BoxDecoration(
        color: const Color(0xFF155DFC), // Blue header
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leave Balance Details',
                  style: TextStyle(
                    fontSize: 15.1.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 23.63 / 15.1,
                  ),
                ),
                Gap(0.01.h),
                Text(
                  '${widget.employeeName} • ${widget.employeeId}',
                  style: TextStyle(
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                    height: 21 / 13.7,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: DigifyAsset(
                  assetPath: Assets.icons.closeIcon.path,
                  width: 17.5,
                  height: 17.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfoCards(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildEmployeeInfoCard(
            label: 'Join Date',
            value: _employeeData['joinDate'],
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildEmployeeInfoCard(
            label: 'Years of Service',
            value: '${_employeeData['yearsOfService']} years',
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildEmployeeInfoCard(
            label: 'Department',
            value: _employeeData['department'],
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildEmployeeInfoCard(
            label: 'Position',
            value: _employeeData['position'],
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfoCard({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      // height: 70.5.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
              height: 18 / 13.6,
            ),
          ),
          Gap(2.5.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 21 / 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Leave Type',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 21 / 14,
          ),
        ),
        Gap(7.h),
        Row(
          children: [
            Expanded(
              child: _buildLeaveTypeButton(
                label: 'Annual Leave',
                type: LeaveType.annualLeave,
                isDark: isDark,
              ),
            ),
            Gap(7.w),
            Expanded(
              child: _buildLeaveTypeButton(
                label: 'Sick Leave',
                type: LeaveType.sickLeave,
                isDark: isDark,
              ),
            ),
            Gap(7.w),
            Expanded(
              child: _buildLeaveTypeButton(
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
                ? const Color(0xFF155DFC)
                : (isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB)),
            borderRadius: BorderRadius.circular(7.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF155DFC)
                  : (isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB)),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828)),
                height: 21 / 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> summary, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: 'Total Accrued',
            value: '${summary['totalAccrued']} days',
            iconPath: Assets.icons.arrowUp.path,
            iconColor: const Color(0xFF008236),
            iconBg: const Color(0xFFDCFCE7),
            valueColor: const Color(0xFF008236),
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            label: 'Total Consumed',
            value: '${summary['totalConsumed']} days',
            iconPath: Assets.icons.downArrowIcon.path,
            iconColor: const Color(0xFFDC2626),
            iconBg: const Color(0xFFFEE2E2),
            valueColor: const Color(0xFFDC2626),
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            label: 'Current Balance',
            value: '${summary['currentBalance']} days',
            iconPath: Assets.icons.calendarIcon.path,
            iconColor: const Color(0xFF155DFC),
            iconBg: const Color(0xFFEFF6FF),
            valueColor: const Color(0xFF155DFC),
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            label: 'Entitlement',
            value: summary['entitlement'],
            iconPath: Assets.icons.arrowUp.path, // Using arrowUp as placeholder for chart icon
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFF3E8FF),
            valueColor: const Color(0xFF8B5CF6),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required String iconPath,
    required Color iconColor,
    required Color iconBg,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      // height: 114.h,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: Center(
                  child: DigifyAsset(
                    assetPath: iconPath,
                    width: 17.5,
                    height: 17.5,
                    color: iconColor,
                  ),
                ),
              ),
              Gap(10.5.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 21 / 14,
                  ),
                ),
              ),
            ],
          ),
          Gap(7.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: valueColor,
              height: 28 / 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(List<Map<String, dynamic>> transactions, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(21.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.r),
                topRight: Radius.circular(7.r),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.arrowRightIcon.path,
                  width: 17.5,
                  height: 17.5,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                ),
                Gap(7.w),
                Text(
                  'Transaction History (${transactions.length} entries)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 21 / 14,
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
          SizedBox(width: 120.84.w, child: _buildHeaderCell('Amount', textColor, alignment: Alignment.center)),
          SizedBox(width: 128.63.w, child: _buildHeaderCell('Balance', textColor, alignment: Alignment.center)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, Color color, {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12.1.sp,
          fontWeight: FontWeight.w600,
          color: color,
          height: 17.5 / 12.1,
        ),
      ),
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> transaction, bool isDark) {
    final textColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF101828);
    final date = transaction['date'] as DateTime;
    final amount = transaction['amount'] as double;
    final balance = transaction['balance'] as double;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 16.h),
      child: Row(
        children: [
          SizedBox(
            width: 146.22.w,
            child: Text(
              DateFormat('MMM d, yyyy').format(date),
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 21 / 13.7,
              ),
            ),
          ),
          SizedBox(
            width: 136.48.w,
            child: _buildAccrualBadge(),
          ),
          Expanded(
            child: Text(
              transaction['description'] as String,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 21 / 13.7,
              ),
            ),
          ),
          SizedBox(
            width: 120.84.w,
            child: Center(
              child: Text(
                '+${amount.toStringAsFixed(1)} days',
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF008236),
                  height: 21 / 13.7,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 128.63.w,
            child: Center(
              child: Text(
                '${balance.toStringAsFixed(1)} days',
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 21 / 13.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccrualBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.5.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(16777200.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+',
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF008236),
              height: 18 / 10.5,
            ),
          ),
          Gap(3.5.w),
          Text(
            'Accrual',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF008236),
              height: 18 / 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaborLawSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
          width: 1,
        ),
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
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              ),
              Gap(7.w),
              Text(
                'Kuwait Labor Law No. 6/2010 - Leave Entitlements',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                  height: 21 / 14,
                ),
              ),
            ],
          ),
          Gap(10.5.h),
          Row(
            children: [
              Expanded(
                child: _buildLawInfoItem(
                  title: 'Annual Leave',
                  description: '30 days per year (2.5 days/month)',
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildLawInfoItem(
                  title: 'Sick Leave',
                  description: '15 days full + 10 half + 10 unpaid',
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildLawInfoItem(
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
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 21 / 14,
          ),
        ),
        Gap(3.5.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 18 / 13.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, AppLocalizations localizations) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 28.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Last updated: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
              height: 17.5 / 12.1,
            ),
          ),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(11.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.5.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 13.8.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
                        height: 21 / 13.8,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(10.49.w),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: Handle export report
                  },
                  borderRadius: BorderRadius.circular(11.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 11.25.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF155DFC),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.exportIconFigma.path,
                          width: 14,
                          height: 14,
                          color: Colors.white,
                        ),
                        Gap(7.w),
                        Text(
                          'Export Report',
                          style: TextStyle(
                            fontSize: 13.7.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 21 / 13.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
