import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_icon.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardHeader extends StatelessWidget {
  final ShiftOverview shift;
  final bool isDark;

  const ShiftCardHeader({super.key, required this.shift, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleFontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 13, tablet: 14, web: 14);
    final subtitleFontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 11, tablet: 12, web: 12);
    final iconSize = ResponsiveHelper.getResponsiveWidth(context, mobile: 32, tablet: 36, web: 40);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: ShiftCardIcon(shiftType: shift.shiftType, colorHex: shift.colorHex),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    shift.nameAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      fontSize: subtitleFontSize,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            ShiftStatusBadge(isActive: shift.isActive),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.infoBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            shift.code.toUpperCase(),
            style: TextStyle(
              color: AppColors.infoText,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
