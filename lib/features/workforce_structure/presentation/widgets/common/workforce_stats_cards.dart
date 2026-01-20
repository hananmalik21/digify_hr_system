import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_stats_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class WorkforceStatsCards extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const WorkforceStatsCards({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(workforceStatsNotifierProvider);

    if (statsAsync.isLoading) {
      return _buildGridView(context, isSkeleton: true);
    }

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: 'Failed to load workforce statistics',
        onRetry: () => ref.read(workforceStatsNotifierProvider.notifier).refresh(),
      );
    }

    if (statsAsync.hasValue && statsAsync.value != null) {
      return _buildGridView(context, stats: statsAsync.value!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildGridView(BuildContext context, {WorkforceStats? stats, bool isSkeleton = false}) {
    final crossAxisCount = context.isMobile ? 1 : (context.isTablet ? 2 : 4);
    final aspectRatio = context.isMobile ? 3.6 : (context.isTablet ? 2.2 : 2.5);
    final spacing = 16.w;

    final cards = _getCardConfigs(stats).map((config) {
      return _buildStatCard(
        context,
        label: config.label,
        value: config.value,
        iconPath: config.iconPath,
        isDark: isDark,
        color: config.color,
      );
    }).toList();

    final gridView = GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: spacing,
      childAspectRatio: aspectRatio,
      children: cards,
    );

    return isSkeleton ? Skeletonizer(enabled: true, child: gridView) : gridView;
  }

  List<_CardConfig> _getCardConfigs(WorkforceStats? stats) {
    final positionsStats = stats?.positionsStats;
    return [
      _CardConfig(
        label: localizations.totalPositions,
        value: positionsStats?.formattedTotalPositions ?? '000',
        iconPath: Assets.icons.workforce.totalPosition.path,
        color: AppColors.primaryLight,
      ),
      _CardConfig(
        label: localizations.filledPositions,
        value: positionsStats?.formattedFilledPositions ?? '000',
        iconPath: Assets.icons.workforce.filledPosition.path,
        color: AppColors.statIconGreen,
      ),
      _CardConfig(
        label: localizations.vacantPositions,
        value: positionsStats?.formattedVacantPositions ?? '000',
        iconPath: Assets.icons.workforce.warning.path,
        color: AppColors.statIconOrange,
      ),
      _CardConfig(
        label: localizations.fillRate,
        value: positionsStats?.formattedFillRate ?? '00.0%',
        iconPath: Assets.icons.workforce.fillRate.path,
        color: AppColors.primaryLight,
      ),
    ];
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

class _CardConfig {
  final String label;
  final String value;
  final String iconPath;
  final Color color;

  const _CardConfig({required this.label, required this.value, required this.iconPath, required this.color});
}
