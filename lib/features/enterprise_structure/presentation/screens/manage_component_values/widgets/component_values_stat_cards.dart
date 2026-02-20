import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:flutter/material.dart';
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
  Map<ComponentType, int> statCounts, {
  required String companiesLabel,
  required String divisionsLabel,
  required String businessUnitsLabel,
  required String departmentsLabel,
  required String sectionsLabel,
}) {
  return [
    ComponentValuesStatCardData(
      label: companiesLabel,
      count: statCounts[ComponentType.company] ?? 0,
      icon: 'assets/icons/company_stat_icon.svg',
      color: AppColors.statIconPurple,
    ),
    ComponentValuesStatCardData(
      label: divisionsLabel,
      count: statCounts[ComponentType.division] ?? 0,
      icon: 'assets/icons/division_stat_icon.svg',
      color: AppColors.statIconBlue,
    ),
    ComponentValuesStatCardData(
      label: businessUnitsLabel,
      count: statCounts[ComponentType.businessUnit] ?? 0,
      icon: 'assets/icons/business_unit_stat_icon.svg',
      color: AppColors.statIconGreen,
    ),
    ComponentValuesStatCardData(
      label: departmentsLabel,
      count: statCounts[ComponentType.department] ?? 0,
      icon: 'assets/icons/department_stat_icon.svg',
      color: AppColors.statIconOrange,
    ),
    ComponentValuesStatCardData(
      label: sectionsLabel,
      count: statCounts[ComponentType.section] ?? 0,
      icon: 'assets/icons/section_stat_icon.svg',
      color: AppColors.textSecondary,
    ),
  ];
}

class ComponentValuesStatCards extends StatelessWidget {
  const ComponentValuesStatCards({super.key, required this.cards, required this.isDark});

  final List<ComponentValuesStatCardData> cards;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
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
          if (i > 0) Gap(16.w),
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
    return Container(
      padding: EdgeInsetsDirectional.all(24.w),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.label,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                  height: 20 / 13.7,
                  letterSpacing: 0,
                ),
              ),
              Gap(4.h),
              Text(
                card.count.toString(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: card.color,
                  height: 32 / 24,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          DigifyAsset(assetPath: card.icon, width: 24, height: 24, color: card.color),
        ],
      ),
    );
  }
}
