import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class WorkforceStatsCards extends StatelessWidget {
  final AppLocalizations localizations;
  final WorkforceStats stats;
  final bool isDark;

  const WorkforceStatsCards({super.key, required this.localizations, required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = context.isMobile ? 1 : (context.isTablet ? 2 : 4);
    final double aspectRatio = context.isMobile ? 3.6 : (context.isTablet ? 2.2 : 2.5);
    final double spacing = 16.w;

    final cards = [
      _buildStatCard(
        context,
        label: localizations.totalPositions,
        value: '${stats.totalPositions}',
        iconPath: Assets.icons.workforce.totalPosition.path,
        isDark: isDark,
        color: AppColors.primaryLight,
      ),
      _buildStatCard(
        context,
        label: localizations.filledPositions,
        value: '${stats.filledPositions}',
        iconPath: Assets.icons.workforce.filledPosition.path,
        isDark: isDark,
        color: AppColors.statIconGreen,
      ),
      _buildStatCard(
        context,
        label: localizations.vacantPositions,
        value: '${stats.vacantPositions}',
        iconPath: Assets.icons.workforce.warning.path,
        isDark: isDark,
        color: AppColors.statIconOrange,
      ),
      _buildStatCard(
        context,
        label: localizations.fillRate,
        value: '${stats.fillRate.toStringAsFixed(1)}%',
        iconPath: Assets.icons.workforce.fillRate.path,
        isDark: isDark,
        color: AppColors.primaryLight,
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
