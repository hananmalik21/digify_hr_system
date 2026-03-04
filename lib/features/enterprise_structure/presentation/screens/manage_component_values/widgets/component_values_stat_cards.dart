import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_stat_counts_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesStatCardData {
  const ComponentValuesStatCardData({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
  final String label;
  final int count;
  final String icon;
  final Color color;
}

List<ComponentValuesStatCardData> buildStatCardsFromCounts(
  Map<ComponentType, int> statCounts,
  AppLocalizations localizations,
) {
  const iconColor = AppColors.statIconBlue;

  return [
    ComponentValuesStatCardData(
      label: localizations.companies,
      count: statCounts[ComponentType.company] ?? 0,
      icon: Assets.icons.companyStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.divisions,
      count: statCounts[ComponentType.division] ?? 0,
      icon: Assets.icons.divisionStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.businessUnits,
      count: statCounts[ComponentType.businessUnit] ?? 0,
      icon: Assets.icons.businessUnitStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.departments,
      count: statCounts[ComponentType.department] ?? 0,
      icon: Assets.icons.departmentStatIcon.path,
      color: iconColor,
    ),
    ComponentValuesStatCardData(
      label: localizations.sections,
      count: statCounts[ComponentType.section] ?? 0,
      icon: Assets.icons.sectionStatIcon.path,
      color: iconColor,
    ),
  ];
}

class ComponentValuesStatCards extends ConsumerWidget {
  const ComponentValuesStatCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statCounts = ref.watch(manageComponentValuesStatCountsProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final cards = buildStatCardsFromCounts(statCounts, localizations);

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
        children: cards.map((card) {
          return SizedBox(
            width: (MediaQuery.sizeOf(context).width - 48.w - 16.w) / 2,
            child: _ComponentValuesStatCard(card: card, isDark: isDark),
          );
        }).toList(),
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
                  card.count.toString(),
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
