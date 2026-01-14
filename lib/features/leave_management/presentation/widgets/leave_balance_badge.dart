import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Badge widget for displaying leave days with different color variants
class LeaveBalanceBadge extends StatelessWidget {
  final String text;
  final LeaveBadgeType type;

  const LeaveBalanceBadge({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final colors = _getColors(type, isDark);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.5.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(16777200.r), // Very rounded (pill shape)
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w400,
          color: colors.textColor,
          height: 21 / 13.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _BadgeColors _getColors(LeaveBadgeType type, bool isDark) {
    switch (type) {
      case LeaveBadgeType.annualLeave:
      case LeaveBadgeType.sickLeave:
        return _BadgeColors(
          backgroundColor: isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7),
          textColor: isDark ? AppColors.successTextDark : const Color(0xFF008236),
        );
      case LeaveBadgeType.unpaidLeave:
        return _BadgeColors(
          backgroundColor: isDark ? AppColors.grayBgDark : const Color(0xFFF3F4F6),
          textColor: isDark ? AppColors.grayTextDark : AppColors.textPrimary,
        );
      case LeaveBadgeType.totalAvailable:
        return _BadgeColors(
          backgroundColor: isDark ? AppColors.infoBgDark : const Color(0xFFE0E7FF),
          textColor: isDark ? AppColors.infoTextDark : const Color(0xFF432DD7),
        );
    }
  }
}

enum LeaveBadgeType {
  annualLeave,
  sickLeave,
  unpaidLeave,
  totalAvailable,
}

class _BadgeColors {
  final Color backgroundColor;
  final Color textColor;

  _BadgeColors({
    required this.backgroundColor,
    required this.textColor,
  });
}
