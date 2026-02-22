import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StatsCardsWidget extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;

  const StatsCardsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.structureListProvider,
  });

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final listState = ref.watch(structureListProvider);
    final totalStructures = listState.pagination?.total ?? listState.total;
    final activeCount = listState.structures.where((s) => s.isActive).length;

    final cards = [
      _EnterpriseStatCard(
        label: localizations.totalStructures,
        value: totalStructures.toString(),
        iconPath: Assets.icons.totalStructuresIcon.path,
        isDark: isDark,
        iconColor: _iconColor,
        iconBgLight: _iconBackgroundLight,
      ),
      _EnterpriseStatCard(
        label: localizations.activeStructure,
        value: activeCount.toString(),
        iconPath: Assets.icons.activeStructureIcon.path,
        isDark: isDark,
        iconColor: _iconColor,
        iconBgLight: _iconBackgroundLight,
      ),
      _EnterpriseStatCard(
        label: localizations.componentsInUse,
        value: '58',
        iconPath: Assets.icons.componentsIcon.path,
        isDark: isDark,
        iconColor: _iconColor,
        iconBgLight: _iconBackgroundLight,
      ),
      _EnterpriseStatCard(
        label: localizations.employeesAssigned,
        value: '450',
        iconPath: Assets.icons.employeesAssignedIcon.path,
        isDark: isDark,
        iconColor: _iconColor,
        iconBgLight: _iconBackgroundLight,
      ),
    ];

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

class _EnterpriseStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconColor;
  final Color iconBgLight;

  const _EnterpriseStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconColor,
    required this.iconBgLight,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBgColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgLight;

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
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 21, height: 21),
          ),
        ],
      ),
    );
  }
}
