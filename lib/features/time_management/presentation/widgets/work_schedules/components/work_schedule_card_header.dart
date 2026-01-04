import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_status_badge.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkScheduleCardHeader extends StatelessWidget {
  final String title;
  final String? titleArabic;
  final String year;
  final String code;
  final bool isActive;

  const WorkScheduleCardHeader({
    super.key,
    required this.title,
    this.titleArabic,
    required this.year,
    required this.code,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleFontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 13, tablet: 14, web: 15.6);
    final subtitleFontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 11, tablet: 12, web: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyAsset(
              assetPath: Assets.icons.sidebar.workSchedules.path,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (titleArabic != null && titleArabic!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      titleArabic!,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: subtitleFontSize,
                        fontFamily: 'SF Arabic',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),
            WorkScheduleStatusBadge(isActive: isActive),
          ],
        ),
        SizedBox(height: 9.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(4.r)),
          child: Text(
            code.toUpperCase(),
            style: TextStyle(
              color: AppColors.infoTextSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
