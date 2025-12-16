import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseStructureDialogHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback? onClose;

  const EnterpriseStructureDialogHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.cardBorderDark
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SvgIconWidget(
            assetPath: iconPath,
            size: 20.sp,
            color: isDark
                ? AppColors.textPrimaryDark
                : const Color(0xFF101828),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.6.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF101828),
                    height: 24 / 15.6,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.6.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : const Color(0xFF4A5565),
                    height: 20 / 13.6,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: SvgIconWidget(
                assetPath: 'assets/icons/close_icon.svg',
                size: 24.sp,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
              ),
            ),
        ],
      ),
    );
  }
}

