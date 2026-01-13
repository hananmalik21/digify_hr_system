import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class TimeManagementStatsCards extends StatelessWidget {
  final AppLocalizations localizations;
  final TimeManagementStats stats;
  final bool isDark;

  const TimeManagementStatsCards({super.key, required this.localizations, required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = context.isMobile ? 1 : (context.isTablet ? 2 : 4);
    final double aspectRatio = context.isMobile ? 3.6 : (context.isTablet ? 2.2 : 2.5);
    final double spacing = 16.w;

    final cards = [
      _buildStatCard(
        context,
        label: localizations.shifts,
        value: '${stats.totalShifts}',
        iconPath: Assets.icons.clockIcon.path,
        isDark: isDark,
        color: AppColors.primaryLight,
      ),
      _buildStatCard(
        context,
        label: localizations.workPatterns,
        value: '${stats.workPatterns}',
        iconPath: Assets.icons.leaveManagementIcon.path,
        isDark: isDark,
        color: AppColors.statIconPurple,
      ),
      _buildStatCard(
        context,
        label: localizations.workSchedules,
        value: '${stats.activeSchedules}',
        iconPath: Assets.icons.sidebar.workSchedules.path,
        isDark: isDark,
        color: AppColors.statIconGreen,
      ),
      _buildStatCard(
        context,
        label: localizations.scheduleAssignments,
        value: '${stats.assignments}',
        iconPath: Assets.icons.sidebar.scheduleAssignments.path,
        isDark: isDark,
        color: AppColors.statIconOrange,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: spacing,
      childAspectRatio: aspectRatio,
      children: cards,
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String iconPath,
    required bool isDark,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.sidebarChildItemText),
                ),
                Gap(4.h),
                Text(
                  value,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          DigifyAsset(assetPath: iconPath, width: 24.sp, height: 24.sp, color: color),
        ],
      ),
    );
  }
}
