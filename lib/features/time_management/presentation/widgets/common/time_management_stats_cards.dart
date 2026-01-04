import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_stats_provider.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class TimeManagementStatsCards extends StatelessWidget {
  final AppLocalizations localizations;
  final TimeManagementStats stats;
  final bool isDark;

  const TimeManagementStatsCards({super.key, required this.localizations, required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final spacing = 16.w;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatItem(context, index: 0)),
              SizedBox(width: spacing),
              Expanded(child: _buildStatItem(context, index: 1)),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: _buildStatItem(context, index: 2)),
              SizedBox(width: spacing),
              Expanded(child: _buildStatItem(context, index: 3)),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _buildStatItem(context, index: 0)),
        SizedBox(width: spacing),
        Expanded(child: _buildStatItem(context, index: 1)),
        SizedBox(width: spacing),
        Expanded(child: _buildStatItem(context, index: 2)),
        SizedBox(width: spacing),
        Expanded(child: _buildStatItem(context, index: 3)),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, {required int index}) {
    final statsList = [
      (
        label: 'Total Shifts',
        value: '${stats.totalShifts}',
        iconPath: Assets.icons.clockIcon.path,
        iconColor: const Color(0xFF3B82F6),
      ),
      (
        label: 'Work Patterns',
        value: '${stats.workPatterns}',
        iconPath: Assets.icons.leaveManagementIcon.path,
        iconColor: const Color(0xFF9333EA),
      ),
      (
        label: 'Active Schedules',
        value: '${stats.activeSchedules}',
        iconPath: Assets.icons.sidebar.workSchedules.path,
        iconColor: const Color(0xFF22C55E),
      ),
      (
        label: 'Assignments',
        value: '${stats.assignments}',
        iconPath: Assets.icons.sidebar.scheduleAssignments.path,
        iconColor: const Color(0xFFEA580C),
      ),
    ];

    final stat = statsList[index];
    return _buildStatCard(
      context,
      label: stat.label,
      value: stat.value,
      iconPath: stat.iconPath,
      iconColor: stat.iconColor,
      isDark: isDark,
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final cardPadding = isMobile ? 16.w : 24.w;
    final valueFontSize = isMobile ? 24.sp : 32.sp;
    final labelFontSize = isMobile ? 12.sp : 14.sp;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 4), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: isMobile ? 4.h : 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              DigifyAsset(
                assetPath: iconPath,
                width: isMobile ? 20.sp : 24.sp,
                height: isMobile ? 20.sp : 24.sp,
                color: iconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
