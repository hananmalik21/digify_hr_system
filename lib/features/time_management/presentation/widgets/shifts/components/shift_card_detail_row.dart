import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ShiftCardDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 11, tablet: 12, web: 12);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                fontSize: fontSize,
                fontFamily: 'Inter',
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
