import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveStatusCard extends StatelessWidget {
  final String title;
  final String message;

  const ActiveStatusCard({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(12.w),
        tablet: EdgeInsetsDirectional.all(14.w),
        web: EdgeInsetsDirectional.all(17.w),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.successBgDark
            : const Color(0xFFF0FDF4),
        border: Border.all(
          color: isDark
              ? AppColors.successBorderDark
              : const Color(0xFFB9F8CF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 2.h),
            child: SvgIconWidget(
              assetPath: 'assets/icons/check_icon_green.svg',
              size: isMobile ? 18.sp : (isTablet ? 19.sp : 20.sp),
              color: isDark
                  ? AppColors.successTextDark
                  : const Color(0xFF008236),
            ),
          ),
          SizedBox(width: isMobile ? 10.w : 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.4.sp),
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.successTextDark
                        : const Color(0xFF0D542B),
                    height: 24 / 15.4,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.6.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.successTextDark
                        : const Color(0xFF008236),
                    height: 20 / 13.6,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

