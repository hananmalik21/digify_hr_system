import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceTabBar extends StatelessWidget {
  final AppLocalizations localizations;
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;
  final bool isDark;

  const WorkforceTabBar({
    super.key,
    required this.localizations,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'label': localizations.positions, 'icon': 'assets/icons/business_unit_card_icon.svg'},
      {'label': localizations.jobFamilies, 'icon': 'assets/icons/hierarchy_icon_department.svg'},
      {'label': localizations.jobLevels, 'icon': 'assets/icons/levels_icon.svg'},
      {'label': localizations.gradeStructure, 'icon': 'assets/icons/grade_icon.svg'},
      {'label': localizations.reportingStructure, 'icon': 'assets/icons/company_filter_icon.svg'},
      {'label': localizations.positionTree, 'icon': 'assets/icons/hierarchy_icon_department.svg'},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = selectedTabIndex == index;
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: _buildTabButton(
                label: tab['label']!,
                icon: tab['icon']!,
                isSelected: isSelected,
                onTap: () => onTabSelected(index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: icon,
                width: 16,
                height: 16,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  height: 24 / 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
