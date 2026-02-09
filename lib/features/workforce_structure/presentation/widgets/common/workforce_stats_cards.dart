import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_stats_providers.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkforceStatsCards extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const WorkforceStatsCards({super.key, required this.localizations, required this.isDark});

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(workforceStatsNotifierProvider);

    if (statsAsync.isLoading) {
      return _buildLayout(context, isSkeleton: true);
    }

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: 'Failed to load workforce statistics',
        onRetry: () => ref.read(workforceStatsNotifierProvider.notifier).refresh(),
      );
    }

    final stats = statsAsync.valueOrNull;
    return _buildLayout(context, stats: stats);
  }

  Widget _buildLayout(BuildContext context, {WorkforceStats? stats, bool isSkeleton = false}) {
    final positionsStats = stats?.positionsStats;
    final cards = [
      _WorkforceStatCard(
        label: localizations.totalPositions,
        value: positionsStats?.formattedTotalPositions ?? '0',
        iconPath: Assets.icons.workforce.totalPosition.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _WorkforceStatCard(
        label: localizations.filledPositions,
        value: positionsStats?.formattedFilledPositions ?? '0',
        iconPath: Assets.icons.workforce.filledPosition.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _WorkforceStatCard(
        label: localizations.vacantPositions,
        value: positionsStats?.formattedVacantPositions ?? '0',
        iconPath: Assets.icons.workforce.warning.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _WorkforceStatCard(
        label: localizations.fillRate,
        value: positionsStats?.formattedFillRate ?? '0%',
        iconPath: Assets.icons.workforce.fillRate.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
    ];

    final content = _buildResponsiveLayout(context, cards);
    return isSkeleton ? Skeletonizer(enabled: true, child: content) : content;
  }

  Widget _buildResponsiveLayout(BuildContext context, List<Widget> cards) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: i < cards.length - 1 ? 12.h : 0),
              child: cards[i],
            ),
        ],
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards
            .map((card) => SizedBox(width: (MediaQuery.of(context).size.width - 48.w - 12.w) / 2, child: card))
            .toList(),
      );
    } else {
      return Row(
        children: [
          for (var i = 0; i < cards.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 21.w : 0),
                child: cards[i],
              ),
            ),
        ],
      );
    }
  }
}

class _WorkforceStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;
  final Color iconColor;

  const _WorkforceStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
                Gap(7.h),
                Text(
                  value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 21, height: 21),
          ),
        ],
      ),
    );
  }
}
