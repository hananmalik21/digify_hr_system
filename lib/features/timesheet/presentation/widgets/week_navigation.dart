import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WeekNavigation extends StatelessWidget {
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onCurrentWeek;
  final bool isDark;

  const WeekNavigation({super.key, required this.weekStartDate, required this.weekEndDate, required this.onPreviousWeek, required this.onNextWeek, required this.onCurrentWeek, required this.isDark});

  String _formatWeekPeriod(DateTime start, DateTime end) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final startStr = '${months[start.month - 1]} ${start.day}${start.year != end.year ? ', ${start.year}' : ''}';
    final endStr = '${months[end.month - 1]} ${end.day}, ${end.year}';
    return '$startStr - $endStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // #0000001A
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x1A000000), // #0000001A
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: context.isMobile
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(assetPath: Assets.icons.attendance.emptyCalander.path, width: 16.w, height: 16.h, color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon),
                    Gap(27.w),
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 20.r, color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                      onPressed: onPreviousWeek,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(14.w),
                    Text(
                      'Week: ${_formatWeekPeriod(weekStartDate, weekEndDate)}',
                      style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle, fontWeight: FontWeight.w500),
                    ),
                    Gap(14.w),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 20.r, color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                      onPressed: onNextWeek,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Gap(12.w),
                AppButton(
                  fontSize: 14.sp,
                  label: 'Current Week',
                  onPressed: onCurrentWeek,
                  height: 35.h,
                  type: AppButtonType.secondary,
                  backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.jobRoleBg,
                  foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                Gap(12.w),
              ],
            )
          : Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.attendance.emptyCalander.path, width: 16.w, height: 16.h, color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon),
                Gap(27.w),
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 20.r, color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                  onPressed: onPreviousWeek,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Gap(14.w),
                Text(
                  'Week: ${_formatWeekPeriod(weekStartDate, weekEndDate)}',
                  style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle, fontWeight: FontWeight.w500),
                ),
                Gap(14.w),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 20.r, color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                  onPressed: onNextWeek,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                AppButton(
                  fontSize: 14.sp,
                  label: 'Current Week',
                  onPressed: onCurrentWeek,
                  height: 35.h,
                  type: AppButtonType.secondary,
                  backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.jobRoleBg,
                  foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                Gap(80.w),
              ],
            ),
    );
  }
}
