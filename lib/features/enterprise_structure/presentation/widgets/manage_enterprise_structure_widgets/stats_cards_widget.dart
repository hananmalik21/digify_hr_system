import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/stat_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Stats cards widget
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Get total from pagination
    final listState = ref.watch(structureListProvider);
    final totalStructures = listState.pagination?.total ?? listState.total;

    final cards = [
      StatCard(
        label: localizations.totalStructures,
        value: totalStructures.toString(),
        icon: 'assets/icons/total_structures_icon.svg',
        color: const Color(0xFF9810FA),
      ),
      StatCard(
        label: localizations.activeStructure,
        value: '1',
        icon: 'assets/icons/active_structure_icon.svg',
        color: const Color(0xFF00A63E),
      ),
      StatCard(
        label: localizations.componentsInUse,
        value: '58',
        icon: 'assets/icons/components_icon.svg',
        color: const Color(0xFF155DFC),
      ),
      StatCard(
        label: localizations.employeesAssigned,
        value: '450',
        icon: 'assets/icons/employees_assigned_icon.svg',
        color: const Color(0xFFF54900),
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((card) {
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: card != cards.last ? 12.h : 0),
            child: StatCardWidget(card: card, isDark: isDark),
          );
        }).toList(),
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 48.w - 12.w) / 2,
            child: StatCardWidget(card: card, isDark: isDark),
          );
        }).toList(),
      );
    } else {
      return Row(
        children: cards.map((card) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: card != cards.last ? 16.w : 0),
              child: StatCardWidget(card: card, isDark: isDark),
            ),
          );
        }).toList(),
      );
    }
  }
}

/// Individual stat card widget
class StatCardWidget extends StatelessWidget {
  final StatCard card;
  final bool isDark;

  const StatCardWidget({super.key, required this.card, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(16.w),
        tablet: EdgeInsetsDirectional.all(20.w),
        web: EdgeInsetsDirectional.all(24.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.label,
                  style: TextStyle(
                    fontSize: isMobile ? 12.sp : (isTablet ? 13.sp : 13.7.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                    height: 20 / 13.7,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  card.value,
                  style: TextStyle(
                    fontSize: isMobile ? 20.sp : (isTablet ? 22.sp : 24.sp),
                    fontWeight: FontWeight.w700,
                    color: card.color,
                    height: 32 / 24,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          DigifyAsset(
            assetPath: card.icon,
            width: isMobile ? 20 : (isTablet ? 22 : 24),
            height: isMobile ? 20 : (isTablet ? 22 : 24),
            color: card.color,
          ),
        ],
      ),
    );
  }
}
