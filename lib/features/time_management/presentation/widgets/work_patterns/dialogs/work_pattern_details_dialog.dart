import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/mixins/datetime_conversion_mixin.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/core/widgets/data/custom_status_cell.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternDetailsDialog extends StatelessWidget with DateTimeConversionMixin {
  final WorkPattern workPattern;

  const WorkPatternDetailsDialog({super.key, required this.workPattern});

  static Future<void> show(BuildContext context, WorkPattern workPattern) {
    return showDialog(
      context: context,
      builder: (context) => WorkPatternDetailsDialog(workPattern: workPattern),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AppDialog(
      title: 'Work Pattern Details',
      width: 500.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          SizedBox(height: 20.h),
          const DigifyDivider(),
          SizedBox(height: 20.h),
          _buildDetailsGrid(isDark),
          SizedBox(height: 24.h),
          _buildWorkingDaysSection(isDark),
          SizedBox(height: 16.h),
          _buildRestDaysSection(isDark),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Close', width: null, onPressed: () => Navigator.of(context).pop()),
        SizedBox(width: 8.w),
        AppButton(
          label: 'Edit Pattern',
          width: null,
          onPressed: () {},
          svgPath: Assets.icons.editIcon.path,
          backgroundColor: AppColors.greenButton,
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      height: 113.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: AppColors.workPatternBadgeBgLight,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: DigifyAsset(
                  assetPath: Assets.icons.leaveManagementMainIcon.path,
                  width: 32.w,
                  height: 32.h,
                  color: AppColors.workPatternBadgeTextLight,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  workPattern.patternNameEn,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                if (workPattern.patternNameAr.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    workPattern.patternNameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.workPatternBadgeBgLight,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    workPattern.patternCode,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.workPatternBadgeTextLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      childAspectRatio: 4,
      children: [
        _buildDetailItem('Pattern Type', workPattern.patternType, isDark),
        _buildDetailItem(
          'Status',
          '',
          isDark,
          widget: CustomStatusCell(
            isActive: workPattern.status == PositionStatus.active,
            activeLabel: 'ACTIVE',
            inactiveLabel: 'INACTIVE',
          ),
        ),
        _buildDetailItem('Total Hours/Week', '${workPattern.totalHoursPerWeek} hours', isDark),
        _buildDetailItem('Created Date', formatDateFromDateTime(workPattern.creationDate), isDark),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark, {Widget? widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
        ),
        SizedBox(height: 4.h),
        widget ??
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
      ],
    );
  }

  Widget _buildWorkingDaysSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Days',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        _buildDaysRow(isDark, isWorking: true),
      ],
    );
  }

  Widget _buildRestDaysSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rest Days',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        _buildDaysRow(isDark, isWorking: false),
      ],
    );
  }

  Widget _buildDaysRow(bool isDark, {required bool isWorking}) {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final workingDayNumbers = workPattern.days
        .where((day) => day.dayType == 'WORK')
        .map((day) => day.dayOfWeek)
        .toSet();
    final restDayNumbers = workPattern.days.where((day) => day.dayType == 'REST').map((day) => day.dayOfWeek).toSet();

    return Row(
      children: List.generate(7, (index) {
        final dayNumber = index + 1;
        final isSelected = isWorking ? workingDayNumbers.contains(dayNumber) : restDayNumbers.contains(dayNumber);

        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: index < 6 ? 8.w : 0),
            child: _buildDayButton(dayNames[index], isSelected, isDark, isWorking: isWorking),
          ),
        );
      }),
    );
  }

  Widget _buildDayButton(String dayName, bool isSelected, bool isDark, {required bool isWorking}) {
    final backgroundColor = isSelected
        ? (isWorking
              ? (isDark ? AppColors.successBgDark : AppColors.successBg)
              : (isDark ? AppColors.errorBgDark : AppColors.errorBg))
        : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg);
    final textColor = isSelected
        ? (isWorking
              ? (isDark ? AppColors.successTextDark : AppColors.successText)
              : (isDark ? AppColors.errorTextDark : AppColors.errorText))
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final borderColor = isSelected
        ? (isWorking
              ? (isDark ? AppColors.successBorderDark : AppColors.successBorder)
              : (isDark ? AppColors.errorBorderDark : AppColors.errorBorder))
        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Center(
        child: Text(
          dayName,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: textColor),
        ),
      ),
    );
  }
}
