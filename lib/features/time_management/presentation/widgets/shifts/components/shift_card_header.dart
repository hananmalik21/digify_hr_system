import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_icon.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftCardHeader extends StatelessWidget {
  final ShiftOverview shift;
  final bool isDark;

  const ShiftCardHeader({super.key, required this.shift, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShiftCardIcon(shiftType: shift.shiftType, colorHex: shift.colorHex),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    shift.nameAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ShiftStatusBadge(isActive: shift.isActive),
          ],
        ),
        Gap(12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(4.r)),
          child: Text(
            shift.code.toUpperCase(),
            style: context.textTheme.labelMedium?.copyWith(color: AppColors.infoText),
          ),
        ),
      ],
    );
  }
}
