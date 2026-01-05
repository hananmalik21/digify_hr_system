import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AssignmentLevel { department, employee }

class AssignmentLevelSelector extends StatelessWidget {
  final AssignmentLevel? selectedLevel;
  final ValueChanged<AssignmentLevel> onLevelChanged;

  const AssignmentLevelSelector({super.key, required this.selectedLevel, required this.onLevelChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Assignment Level',
              style: TextStyle(
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w500,
                color: context.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '*',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _LevelCard(
                level: AssignmentLevel.department,
                title: 'Department Level',
                description: 'Assign to entire department',
                icon: Assets.icons.departmentIcon.path,
                isSelected: selectedLevel == AssignmentLevel.department,
                onTap: () => onLevelChanged(AssignmentLevel.department),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _LevelCard(
                level: AssignmentLevel.employee,
                title: 'Employee Level',
                description: 'Assign to specific employee',
                icon: Assets.icons.addEmployeeIcon.path,
                isSelected: selectedLevel == AssignmentLevel.employee,
                onTap: () => onLevelChanged(AssignmentLevel.employee),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final AssignmentLevel level;
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.05))
              : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : (isDark ? AppColors.inputBgDark : AppColors.inputBg),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: DigifyAsset(
                  assetPath: icon,
                  width: 24,
                  height: 24,
                  color: isSelected ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
