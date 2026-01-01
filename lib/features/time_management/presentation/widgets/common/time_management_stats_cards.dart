import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class TimeManagementStatsCards extends StatelessWidget {
  final AppLocalizations localizations;
  final TimeManagementStats stats;
  final bool isDark;

  const TimeManagementStatsCards({
    super.key,
    required this.localizations,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Total Shifts',
            value: '${stats.totalShifts}',
            iconPath: Assets.icons.clockIcon.path,
            iconColor: const Color(0xFF3B82F6),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Work Patterns',
            value: '${stats.workPatterns}',
            iconPath: Assets.icons.leaveManagementIcon.path,
            iconColor: const Color(0xFF9333EA),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Active Schedules',
            value: '${stats.activeSchedules}',
            iconPath: Assets.icons.sidebar.workSchedules.path,
            iconColor: const Color(0xFF22C55E),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            context,
            label: 'Assignments',
            value: '${stats.assignments}',
            iconPath: Assets.icons.sidebar.scheduleAssignments.path,
            iconColor: const Color(0xFFEA580C),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String iconPath,
    required Color iconColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                  fontFamily: 'Inter',
                ),
              ),
              DigifyAsset(
                assetPath: iconPath,
                width: 24.sp,
                height: 24.sp,
                color: iconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
