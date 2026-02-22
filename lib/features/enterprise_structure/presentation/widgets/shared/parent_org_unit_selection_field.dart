import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ParentOrgUnitSelectionField extends StatelessWidget {
  final String? parentName;
  final VoidCallback? onTap;
  final bool isLoading;
  final String label;
  final bool isRequired;

  const ParentOrgUnitSelectionField({
    super.key,
    this.parentName,
    this.onTap,
    this.isLoading = false,
    this.label = 'Parent',
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    parentName ?? 'Select parent org unit',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: parentName != null
                          ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                          : (isDark ? AppColors.textPlaceholderDark : AppColors.textSecondary.withValues(alpha: 0.6)),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(
                  assetPath: Assets.icons.workforce.chevronRight.path,
                  color: !isLoading
                      ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                      : (isDark ? AppColors.textPlaceholderDark : AppColors.textSecondary.withValues(alpha: 0.3)),
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
