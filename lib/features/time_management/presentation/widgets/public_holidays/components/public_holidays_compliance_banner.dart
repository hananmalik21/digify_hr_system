import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class PublicHolidaysComplianceBanner extends StatelessWidget {
  const PublicHolidaysComplianceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.infoIconGreen.path,
            width: 20,
            height: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kuwait Labor Law Compliance',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'According to Kuwait Labor Law No. 6/2010, employees are entitled to paid public holidays. Islamic holidays follow the Hijri calendar and dates may vary.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '، يحق للموظفين الحصول على إجازات عطلة رسمية مدفوعة الأجر. الأعياد الإسلامية تتبع التقويم الهجري وقد تختلف التواريخ.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
