import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_text_theme.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A compact chip showing an icon and label, used in the employee detail header.
class EmployeeDetailChip extends StatelessWidget {
  const EmployeeDetailChip({super.key, required this.path, required this.label, required this.isDark});

  final String path;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAsset(assetPath: path, color: AppColors.primary, width: 16.w, height: 16.h),
        Gap(4.w),
        Text(label, style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: color)),
      ],
    );
  }
}
