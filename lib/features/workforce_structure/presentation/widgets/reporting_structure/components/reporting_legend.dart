import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReportingLegend extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ReportingLegend({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.positionTypes,
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          Row(
            children: [
              Expanded(
                child: _LegendCard(title: localizations.topLevelPositions, subtitle: localizations.noReportingManager),
              ),
              Gap(16.w),
              Expanded(
                child: _LegendCard(title: localizations.managementPositions, subtitle: localizations.hasDirectReports),
              ),
              Gap(16.w),
              Expanded(
                child: _LegendCard(
                  title: localizations.individualContributors,
                  subtitle: localizations.noDirectReports,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _LegendCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.ingobgBorder, width: 1),
      ),
      child: Row(
        children: [
          DigifyAsset(
            assetPath: Assets.icons.workforce.totalPosition.path,
            color: AppColors.primary,
            width: 20.w,
            height: 20.h,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.labelMedium?.copyWith(color: AppColors.textPrimary, fontSize: 15.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(2.h),
                Text(
                  subtitle,
                  style: context.textTheme.labelSmall?.copyWith(color: AppColors.shiftExportButton, fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
