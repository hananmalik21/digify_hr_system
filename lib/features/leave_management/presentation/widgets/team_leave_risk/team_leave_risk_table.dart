import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TeamLeaveRiskTable extends StatelessWidget {
  final List<TeamLeaveRiskEmployee> employees;
  final AppLocalizations localizations;
  final bool isDark;

  const TeamLeaveRiskTable({super.key, required this.employees, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: Column(children: [_buildHeader(context), _buildTable(context)]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 17.5.sp,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
          ),
          Gap(7.w),
          Text(
            '${localizations.employeesWithAtRiskLeave} (${employees.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 21 / 14,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [_buildTableHeader(context), ...employees.map((employee) => _buildTableRow(context, employee))],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 10.5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(width: 213.84.w, child: _buildHeaderCell(localizations.employee)),
          SizedBox(width: 140.71.w, child: _buildHeaderCell(localizations.department)),
          SizedBox(width: 222.91.w, child: _buildHeaderCell(localizations.leaveType)),
          SizedBox(width: 151.68.w, child: _buildHeaderCell(localizations.totalBalance, center: true)),
          SizedBox(width: 147.3.w, child: _buildHeaderCell(localizations.atRiskDays, center: true)),
          SizedBox(width: 200.72.w, child: _buildHeaderCell(localizations.carryForwardLimit, center: true)),
          SizedBox(width: 143.1.w, child: _buildHeaderCell(localizations.expiryDate, center: true)),
          SizedBox(width: 125.48.w, child: _buildHeaderCell(localizations.riskLevel, center: true)),
          SizedBox(width: 122.26.w, child: _buildHeaderCell(localizations.actions, center: true)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {bool center = false}) {
    return Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 13.8.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
        height: 21 / 13.8,
        letterSpacing: 0,
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, TeamLeaveRiskEmployee employee) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final daysLeft = employee.daysUntilExpiry;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 0.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 213.84.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 31.75.h, bottom: 32.25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: TextStyle(
                      fontSize: 13.8.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                      height: 21 / 13.8,
                      letterSpacing: 0,
                    ),
                  ),
                  Gap(3.5.h),
                  Text(
                    employee.employeeId,
                    style: TextStyle(
                      fontSize: 12.1.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
                      height: 17.5 / 12.1,
                      letterSpacing: 0,
                    ),
                  ),
                  Gap(3.5.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      employee.nameArabic,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF99A1AF),
                        height: 14 / 10.5,
                        letterSpacing: 0,
                      ),
                      // textDirection: TextDirection.RTL,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 140.71.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 31.75.h, bottom: 32.25.h),
              child: Text(
                employee.department,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                  height: 21 / 13.7,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 222.91.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 32.h, bottom: 31.5.h),
              child: _buildLeaveTypeBadge(employee.leaveType),
            ),
          ),
          SizedBox(
            width: 151.68.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 31.75.h, bottom: 32.25.h),
              child: Center(
                child: Text(
                  '${employee.totalBalance.toStringAsFixed(employee.totalBalance == employee.totalBalance.toInt() ? 0 : 1)} days',
                  style: TextStyle(
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 21 / 13.8,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 147.3.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 30.5.h, bottom: 31.h),
              child: Center(child: _buildAtRiskBadge(employee.atRiskDays)),
            ),
          ),
          SizedBox(
            width: 200.72.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 31.75.h, bottom: 32.25.h),
              child: Center(
                child: Text(
                  '${employee.carryForwardLimit.toStringAsFixed(employee.carryForwardLimit == employee.carryForwardLimit.toInt() ? 0 : 1)} days',
                  style: TextStyle(
                    fontSize: 13.6.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                    height: 21 / 13.6,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 143.1.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 31.75.h, bottom: 32.25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dateFormat.format(employee.expiryDate),
                    style: TextStyle(
                      fontSize: 13.9.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                      height: 21 / 13.9,
                      letterSpacing: 0,
                    ),
                  ),
                  Gap(3.5.h),
                  Text(
                    localizations.daysLeft(daysLeft),
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
                      height: 14 / 10.5,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 125.48.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 30.25.h, bottom: 30.25.h),
              child: Center(child: _buildRiskLevelBadge(employee.riskLevel)),
            ),
          ),
          SizedBox(
            width: 122.26.w,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 30.25.h, bottom: 30.25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility_outlined, size: 14.sp),
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                    onPressed: () {},
                    padding: EdgeInsets.all(7.w),
                    constraints: const BoxConstraints(),
                  ),
                  Gap(7.w),
                  IconButton(
                    icon: Icon(Icons.check_circle_outline, size: 14.sp),
                    color: AppColors.success,
                    onPressed: () {},
                    padding: EdgeInsets.all(7.w),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeBadge(String leaveType) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.5.w, vertical: 1.75.h),
      decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(100.r)),
      child: Text(
        leaveType,
        style: TextStyle(
          fontSize: 12.1.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1447E6),
          height: 17.5 / 12.1,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildAtRiskBadge(double days) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.5.w, vertical: 1.25.h),
      decoration: BoxDecoration(color: const Color(0xFFFFE2E2), borderRadius: BorderRadius.circular(100.r)),
      child: Text(
        '${days.toStringAsFixed(days == days.toInt() ? 0 : 1)} days',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFC10007),
          height: 21 / 14,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildRiskLevelBadge(RiskLevel riskLevel) {
    final bgColor = riskLevel == RiskLevel.high
        ? const Color(0xFFFFEDD4)
        : riskLevel == RiskLevel.medium
        ? const Color(0xFFDBEAFE)
        : const Color(0xFFDBEAFE);
    final textColor = riskLevel == RiskLevel.high
        ? const Color(0xFFCA3500)
        : riskLevel == RiskLevel.medium
        ? const Color(0xFF1447E6)
        : const Color(0xFF1447E6);
    final icon = riskLevel == RiskLevel.high ? Icons.warning_amber_rounded : Icons.info_outline;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.5.w, vertical: 3.5.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.5.sp, color: textColor),
          Gap(3.5.w),
          Text(
            riskLevel.displayName,
            style: TextStyle(
              fontSize: riskLevel == RiskLevel.high ? 12.3.sp : 11.9.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
              height: 17.5 / 12.3,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
