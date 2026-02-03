import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailDocumentCard extends StatelessWidget {
  const EmployeeDetailDocumentCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.statusLabel,
    required this.number,
    required this.expiryDate,
    required this.isDark,
  });

  final String title;
  final String iconPath;
  final String statusLabel;
  final String number;
  final String expiryDate;
  final bool isDark;

  static const double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.infoBorderDark : AppColors.dashboardCardBorder;
    final iconBg = isDark ? AppColors.infoBgDark : AppColors.infoBg;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: _borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: DigifyAsset(assetPath: iconPath, width: 22.w, height: 22.h, color: AppColors.primary),
              ),
              Gap(12.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
                ),
              ),
              DigifyCapsule(
                label: statusLabel,
                backgroundColor: isDark ? AppColors.successBgDark : AppColors.successBg,
                textColor: isDark ? AppColors.successTextDark : AppColors.successText,
              ),
            ],
          ),
          Gap(20.h),
          Text(
            'Number',
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          Gap(4.h),
          Text(
            number,
            style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
          ),
          Gap(8.h),
          Text(
            'Expiry Date',
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          Gap(4.h),
          Text(
            expiryDate,
            style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
