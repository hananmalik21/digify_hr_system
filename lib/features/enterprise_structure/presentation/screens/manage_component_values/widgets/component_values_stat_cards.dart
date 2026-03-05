import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_stats.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_structure_stats_providers.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentValuesStatCardData {
  const ComponentValuesStatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final String icon;
  final Color color;
}

String _labelForLevelCode(String levelCode, AppLocalizations l10n) {
  switch (levelCode.toUpperCase()) {
    case 'COMPANY':
      return l10n.companies;
    case 'DIVISION':
      return l10n.divisions;
    case 'BUSINESS_UNIT':
      return l10n.businessUnits;
    case 'DEPARTMENT':
      return l10n.departments;
    case 'SECTION':
      return l10n.sections;
    default:
      return levelCode;
  }
}

String _iconForLevelCode(String levelCode) {
  switch (levelCode.toUpperCase()) {
    case 'COMPANY':
      return Assets.icons.companyStatIcon.path;
    case 'DIVISION':
      return Assets.icons.divisionStatIcon.path;
    case 'BUSINESS_UNIT':
      return Assets.icons.businessUnitStatIcon.path;
    case 'DEPARTMENT':
      return Assets.icons.departmentStatIcon.path;
    case 'SECTION':
      return Assets.icons.sectionStatIcon.path;
    default:
      return Assets.icons.companyStatIcon.path;
  }
}

List<ComponentValuesStatCardData> _placeholderCards(AppLocalizations localizations) {
  const iconColor = AppColors.statIconBlue;
  return [
    ComponentValuesStatCardData(
      label: localizations.companies,
      value: '0',
      icon: Assets.icons.companyStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.businessUnits,
      value: '0',
      icon: Assets.icons.businessUnitStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.divisions,
      value: '0',
      icon: Assets.icons.divisionStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.departments,
      value: '0',
      icon: Assets.icons.departmentStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.sections,
      value: '0',
      icon: Assets.icons.sectionStatIcon.path,
      color: iconColor,
    ),
  ];
}

List<ComponentValuesStatCardData> _buildCardsFromLevels(
  List<LevelWithComponents> levels,
  AppLocalizations localizations,
) {
  const iconColor = AppColors.statIconBlue;
  final sorted = List<LevelWithComponents>.from(levels)..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  return sorted
      .map(
        (level) => ComponentValuesStatCardData(
          label: _labelForLevelCode(level.levelCode, localizations),
          value: level.formattedComponentCount,
          icon: _iconForLevelCode(level.levelCode),
          color: iconColor,
        ),
      )
      .toList();
}

class ComponentValuesStatCards extends ConsumerWidget {
  const ComponentValuesStatCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(activeStructureStatsNotifierProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    if (statsAsync.isLoading) {
      final placeholderCards = _placeholderCards(localizations);
      return _buildLayout(context, placeholderCards, isDark, isSkeleton: true);
    }

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: localizations.somethingWentWrong,
        retryLabel: localizations.retry,
        onRetry: () => ref.read(activeStructureStatsNotifierProvider.notifier).refresh(),
      );
    }

    final stats = statsAsync.valueOrNull;
    final levels = stats?.levelsWithComponents ?? [];
    final cards = _buildCardsFromLevels(levels, localizations);

    return _buildLayout(context, cards, isDark);
  }

  Widget _buildLayout(
    BuildContext context,
    List<ComponentValuesStatCardData> cards,
    bool isDark, {
    bool isSkeleton = false,
  }) {
    final content = _buildResponsiveLayout(context, cards, isDark);
    return isSkeleton ? Skeletonizer(enabled: true, child: content) : content;
  }

  Widget _buildResponsiveLayout(BuildContext context, List<ComponentValuesStatCardData> cards, bool isDark) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) Gap(12.h),
            _ComponentValuesStatCard(card: cards[i], isDark: isDark),
          ],
        ],
      );
    }
    if (isTablet) {
      return Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        children: cards
            .map(
              (card) => SizedBox(
                width: (MediaQuery.sizeOf(context).width - 48.w - 16.w) / 2,
                child: _ComponentValuesStatCard(card: card, isDark: isDark),
              ),
            )
            .toList(),
      );
    }
    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) Gap(21.w),
          Expanded(
            child: _ComponentValuesStatCard(card: cards[i], isDark: isDark),
          ),
        ],
      ],
    );
  }
}

class _ComponentValuesStatCard extends StatelessWidget {
  const _ComponentValuesStatCard({required this.card, required this.isDark});

  final ComponentValuesStatCardData card;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBgColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg;

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
                  card.label,
                  style: context.textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
                Gap(7.h),
                Text(
                  card.value,
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
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: card.icon, color: card.color, width: 21, height: 21),
          ),
        ],
      ),
    );
  }
}
