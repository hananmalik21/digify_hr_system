import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DateSelectionField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final VoidCallback onTap;

  const DateSelectionField({super.key, required this.label, this.isRequired = true, this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deleteIconRed,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'Select Date',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: value != null && value!.isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(assetPath: Assets.icons.sidebar.workSchedules.path, width: 20, height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
