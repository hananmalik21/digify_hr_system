import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TeamLeaveRiskStatCards extends StatelessWidget {
  final TeamLeaveRiskStats stats;
  final bool isDark;

  const TeamLeaveRiskStatCards({
    super.key,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final cards = [
      _StatCardData(
        label: 'Team Members',
        value: stats.teamMembers.toString(),
        description: 'Active employees',
        iconBgColor: const Color(0xFFDBEAFE),
        borderColor: const Color(0xFFBEDBFF),
        valueColor: const Color(0xFF101828),
      ),
      _StatCardData(
        label: 'Employees at Risk',
        value: stats.employeesAtRisk.toString(),
        description: '${(stats.employeesAtRisk / stats.teamMembers * 100).toStringAsFixed(1)}% of team',
        iconBgColor: const Color(0xFFFFEDD4),
        borderColor: const Color(0xFFFFD6A7),
        valueColor: const Color(0xFFF54900),
      ),
      _StatCardData(
        label: 'Total At-Risk Days',
        value: stats.totalAtRiskDays.toString(),
        description: 'Across all team members',
        iconBgColor: const Color(0xFFFFE2E2),
        borderColor: const Color(0xFFFFC9C9),
        valueColor: const Color(0xFFE7000B),
      ),
      _StatCardData(
        label: 'Avg At-Risk per Employee',
        value: stats.avgAtRiskPerEmployee.toStringAsFixed(1),
        description: 'Days per employee',
        iconBgColor: const Color(0xFFF3E8FF),
        borderColor: const Color(0xFFE9D4FF),
        valueColor: const Color(0xFF9810FA),
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((card) {
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: card != cards.last ? 12.h : 0),
            child: _StatCard(card: card, isDark: isDark),
          );
        }).toList(),
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 48.w - 12.w) / 2,
            child: _StatCard(card: card, isDark: isDark),
          );
        }).toList(),
      );
    } else {
      return Row(
        children: cards.map((card) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: card != cards.last ? 21.w : 0),
              child: _StatCard(card: card, isDark: isDark),
            ),
          );
        }).toList(),
      );
    }
  }
}

class _StatCardData {
  final String label;
  final String value;
  final String description;
  final Color iconBgColor;
  final Color borderColor;
  final Color valueColor;

  _StatCardData({
    required this.label,
    required this.value,
    required this.description,
    required this.iconBgColor,
    required this.borderColor,
    required this.valueColor,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData card;
  final bool isDark;

  const _StatCard({
    required this.card,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(
          color: card.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: card.iconBgColor,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(
              Icons.info_outline,
              size: 21.sp,
              color: card.valueColor,
            ),
          ),
          Gap(14.h),
          Text(
            card.label,
            style: TextStyle(
              fontSize: 11.9.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
              height: 17.5 / 11.9,
              letterSpacing: 0,
            ),
          ),
          Gap(7.h),
          Text(
            card.value,
            style: TextStyle(
              fontSize: 26.3.sp,
              fontWeight: FontWeight.w700,
              color: card.valueColor,
              height: 31.5 / 26.3,
              letterSpacing: 0,
            ),
          ),
          Gap(7.h),
          Text(
            card.description,
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
    );
  }
}
