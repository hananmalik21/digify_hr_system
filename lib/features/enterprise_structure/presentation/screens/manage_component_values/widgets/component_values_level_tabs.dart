import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/feedback/shimmer_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesLevelTabs extends StatelessWidget {
  const ComponentValuesLevelTabs({
    super.key,
    required this.treeViewLabel,
    required this.isTreeViewActive,
    required this.selectedLevelCode,
    required this.levels,
    required this.isLevelsLoading,
    required this.levelsError,
    required this.isDark,
    required this.onTreeViewTap,
    required this.onLevelTap,
  });

  final String treeViewLabel;
  final bool isTreeViewActive;
  final String? selectedLevelCode;
  final List<ActiveStructureLevel> levels;
  final bool isLevelsLoading;
  final String? levelsError;
  final bool isDark;
  final VoidCallback onTreeViewTap;
  final void Function(ActiveStructureLevel level) onLevelTap;

  @override
  Widget build(BuildContext context) {
    if (isLevelsLoading) {
      return _LevelTabsShimmer(isDark: isDark);
    }
    if (levelsError != null) {
      return Container(
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            levelsError!,
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
        ),
      );
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: isMobile ? const AlwaysScrollableScrollPhysics() : null,
        child: Row(
          children: [
            _LevelTabChip(
              label: treeViewLabel,
              iconPath: isTreeViewActive ? 'assets/icons/tree_view_icon_active.svg' : 'assets/icons/tree_view_icon.svg',
              isActive: isTreeViewActive,
              isDark: isDark,
              onTap: onTreeViewTap,
            ),
            Gap(4.w),
            ...levels.map((level) {
              final icons = getIconsForLevelCode(level.levelCode);
              final isActive = selectedLevelCode == level.levelCode;
              return Padding(
                key: Key('tab_${level.levelCode}'),
                padding: EdgeInsetsDirectional.only(end: 4.w),
                child: _LevelTabChip(
                  label: level.levelName,
                  iconPath: icons['icon'] ?? 'assets/icons/company_icon.svg',
                  isActive: isActive,
                  isDark: isDark,
                  onTap: () => onLevelTap(level),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LevelTabChip extends StatelessWidget {
  const _LevelTabChip({
    required this.label,
    required this.iconPath,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : (isDark ? AppColors.cardBackgroundGreyDark : Colors.white),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isActive
              ? null
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 2)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyAsset(
              assetPath: iconPath,
              width: 16,
              height: 16,
              color: isActive ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
            ),
            Gap(8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTabsShimmer extends StatelessWidget {
  const _LevelTabsShimmer({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: isMobile ? const AlwaysScrollableScrollPhysics() : null,
        child: Row(
          children: [
            _ShimmerTab(),
            Gap(4.w),
            _ShimmerTab(width: 110.w),
            Gap(4.w),
            _ShimmerTab(width: 140.w),
            Gap(4.w),
            _ShimmerTab(width: 100.w),
            Gap(4.w),
            _ShimmerTab(width: 130.w),
          ],
        ),
      ),
    );
  }
}

class _ShimmerTab extends StatelessWidget {
  const _ShimmerTab({this.width = 150});

  final double width;

  @override
  Widget build(BuildContext context) {
    final iconSize = 18.sp;
    final textWidth = (width.w - (16.w * 2) - iconSize - 8.w).clamp(50.w, 220.w);
    return ShimmerWidget(
      child: Container(
        height: 48.h,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, 1), blurRadius: 2),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerContainer(width: iconSize, height: iconSize, borderRadius: 4),
            Gap(8.w),
            ShimmerContainer(width: textWidth, height: 12.h, borderRadius: 6),
          ],
        ),
      ),
    );
  }
}
