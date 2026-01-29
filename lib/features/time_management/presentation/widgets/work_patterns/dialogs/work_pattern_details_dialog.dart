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
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_type_badge.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WorkPatternDetailsDialog extends ConsumerWidget with DateTimeConversionMixin {
  final WorkPattern workPattern;

  const WorkPatternDetailsDialog({super.key, required this.workPattern});

  static Future<void> show(BuildContext context, WorkPattern workPattern) {
    return showDialog(
      context: context,
      builder: (context) => WorkPatternDetailsDialog(workPattern: workPattern),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    return AppDialog(
      title: 'Work Pattern Details',
      width: 700.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark),
          DigifyDivider(margin: EdgeInsets.symmetric(vertical: 24.h)),
          _buildDetailsGrid(context),
          _buildWorkingDaysSection(context, isDark),
          Gap(16.h),
          _buildRestDaysSection(context, isDark),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Close', onPressed: () => context.pop()),
        Gap(8.w),
        AppButton(
          label: 'Edit Pattern',
          onPressed: () {
            context.pop();
            final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);
            if (enterpriseId != null) {
              EditWorkPatternDialog.show(context, enterpriseId, workPattern);
            }
          },
          svgPath: Assets.icons.editIcon.path,
          backgroundColor: AppColors.greenButton,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.workPatternBadgeBgLight,
            borderRadius: BorderRadius.circular(14.r),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.leaveManagementMainIcon.path,
            width: 32.w,
            height: 32.h,
            color: AppColors.statIconPurple,
          ),
        ),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                workPattern.patternNameEn,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 19.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              if (workPattern.patternNameAr.isNotEmpty) ...[
                Gap(2.h),
                Text(
                  workPattern.patternNameAr,
                  textDirection: TextDirection.rtl,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
              Gap(4.h),
              WorkPatternTypeBadge(type: workPattern.patternType),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 0.h,
      crossAxisSpacing: 0.w,
      childAspectRatio: 4,
      children: [
        _buildDetailItem(context, 'Pattern Type', workPattern.patternType),
        _buildDetailItem(
          context,
          'Status',
          '',
          widget: CustomStatusCell(
            isActive: workPattern.status == PositionStatus.active,
            activeLabel: 'ACTIVE',
            inactiveLabel: 'INACTIVE',
          ),
        ),
        _buildDetailItem(context, 'Total Hours/Week', '${workPattern.totalHoursPerWeek} hours'),
        _buildDetailItem(context, 'Created Date', formatDateFromDateTime(workPattern.creationDate)),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, {Widget? widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Gap(4.h),
        widget ?? Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.dialogTitle)),
      ],
    );
  }

  Widget _buildWorkingDaysSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Days',
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(12.h),
        _buildDaysRow(context, isDark, isWorking: true),
      ],
    );
  }

  Widget _buildRestDaysSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rest Days',
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(12.h),
        _buildDaysRow(context, isDark, isWorking: false),
      ],
    );
  }

  Widget _buildDaysRow(BuildContext context, bool isDark, {required bool isWorking}) {
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
            child: _buildDayButton(context, dayNames[index], isSelected, isDark, isWorking: isWorking),
          ),
        );
      }),
    );
  }

  Widget _buildDayButton(
    BuildContext context,
    String dayName,
    bool isSelected,
    bool isDark, {
    required bool isWorking,
  }) {
    final backgroundColor = isSelected
        ? (isWorking ? AppColors.shiftActiveStatusBg : AppColors.workPatternRestDayBg)
        : AppColors.workPatternDisabledDayBg;
    final textColor = isSelected
        ? (isWorking ? AppColors.shiftActiveStatusText : AppColors.workPatternRestDayText)
        : AppColors.workPatternDisabledDayText;

    return Container(
      height: 44.h,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
      alignment: Alignment.center,
      child: Text(
        dayName,
        textAlign: TextAlign.center,
        style: context.textTheme.titleSmall?.copyWith(color: textColor),
      ),
    );
  }
}
