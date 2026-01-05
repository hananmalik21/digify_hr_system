import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentActionBar extends StatelessWidget {
  final VoidCallback onAssignSchedule;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;

  const ScheduleAssignmentActionBar({
    super.key,
    required this.onAssignSchedule,
    required this.onBulkUpload,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.cardBorder),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Schedule Assignments',
                        style: TextStyle(
                          fontSize: 15.6.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildActionButton(
                      context,
                      label: 'Assign Schedule',
                      icon: Icons.add,
                      backgroundColor: AppColors.primary,
                      onPressed: onAssignSchedule,
                    ),
                    _buildActionButton(
                      context,
                      label: 'Bulk Upload',
                      svgPath: Assets.icons.bulkUploadIconFigma.path,
                      backgroundColor: AppColors.greenButton,
                      onPressed: onBulkUpload,
                    ),
                    _buildActionButton(
                      context,
                      label: 'Export',
                      svgPath: Assets.icons.downloadIcon.path,
                      backgroundColor: AppColors.textSecondary,
                      onPressed: onExport,
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule Assignments',
                  style: TextStyle(
                    fontSize: 15.6.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    AppButton(
                      onPressed: onAssignSchedule,
                      label: 'Assign Schedule',
                      icon: Icons.add,
                      height: 40.h,
                      width: null,
                      borderRadius: BorderRadius.circular(10.r),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.buttonTextLight,
                      fontSize: 15.1.sp,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    SizedBox(width: 8.w),
                    AppButton(
                      onPressed: onBulkUpload,
                      label: 'Bulk Upload',
                      svgPath: Assets.icons.bulkUploadIconFigma.path,
                      height: 40.h,
                      width: null,
                      borderRadius: BorderRadius.circular(10.r),
                      backgroundColor: AppColors.greenButton,
                      foregroundColor: AppColors.buttonTextLight,
                      fontSize: 15.4.sp,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    SizedBox(width: 8.w),
                    AppButton(
                      onPressed: onExport,
                      label: 'Export',
                      svgPath: Assets.icons.downloadIcon.path,
                      height: 40.h,
                      width: null,
                      borderRadius: BorderRadius.circular(10.r),
                      backgroundColor: AppColors.textSecondary,
                      foregroundColor: AppColors.buttonTextLight,
                      fontSize: 15.1.sp,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required String label,
    IconData? icon,
    String? svgPath,
    required Color backgroundColor,
  }) {
    return AppButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      svgPath: svgPath,
      height: 36.h,
      width: null,
      borderRadius: BorderRadius.circular(10.r),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      fontSize: 12.sp,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }
}
