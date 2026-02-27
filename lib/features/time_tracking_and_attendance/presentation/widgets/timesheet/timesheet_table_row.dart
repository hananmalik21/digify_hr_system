import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/config/timesheet_table_config.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_dialog.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_actions_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/timesheet_status_chip.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TimesheetTableRow extends ConsumerWidget {
  final Timesheet timesheet;
  final bool isDark;

  const TimesheetTableRow({super.key, required this.timesheet, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timesheetNotifierProvider);
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (TimesheetTableConfig.showEmployee)
            _buildDataCell(
              Row(
                children: [
                  AppAvatar(image: null, fallbackInitial: timesheet.employeeName, size: 35.w),
                  Gap(11.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timesheet.employeeName.toUpperCase(),
                          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                        ),
                        Gap(2.h),
                        Text(timesheet.employeeNumber, style: secondaryStyle),
                      ],
                    ),
                  ),
                ],
              ),
              TimesheetTableConfig.employeeWidth.w,
            ),
          if (TimesheetTableConfig.showDepartment)
            _buildDataCell(
              Text(timesheet.departmentName.toUpperCase(), style: textStyle),
              TimesheetTableConfig.departmentWidth.w,
            ),
          if (TimesheetTableConfig.showWeekPeriod)
            _buildDataCell(
              Text(timesheet.formattedWeekPeriod, style: textStyle),
              TimesheetTableConfig.weekPeriodWidth.w,
            ),
          if (TimesheetTableConfig.showRegularHours)
            _buildDataCell(
              Text('${timesheet.regularHours.toInt()}h', style: textStyle),
              TimesheetTableConfig.regularHoursWidth.w,
            ),
          if (TimesheetTableConfig.showOvertimeHours)
            _buildDataCell(
              Text('${timesheet.overtimeHours.toInt()}h', style: textStyle),
              TimesheetTableConfig.overtimeHoursWidth.w,
            ),
          if (TimesheetTableConfig.showTotalHours)
            _buildDataCell(
              Text('${timesheet.totalHours.toInt()}h', style: textStyle),
              TimesheetTableConfig.totalHoursWidth.w,
            ),
          if (TimesheetTableConfig.showStatus)
            _buildDataCell(TimesheetStatusChip(status: timesheet.status), TimesheetTableConfig.statusWidth.w),
          if (TimesheetTableConfig.showActions)
            _buildDataCell(_buildActionsCell(context, ref, state), TimesheetTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: TimesheetTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildActionsCell(BuildContext context, WidgetRef ref, TimesheetState state) {
    if (timesheet.status == TimesheetStatus.draft) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAssetButton(
            assetPath: Assets.icons.editIconGreen.path,
            onTap: () => EditTimesheetDialog.show(context, timesheet),
            width: 17.w,
            height: 17.h,
            color: AppColors.editIconGreen,
          ),
        ],
      );
    }

    if (timesheet.status == TimesheetStatus.submitted) {
      final isApproving = state.approvingTimesheetGuid == timesheet.guid;
      final isRejecting = state.rejectingTimesheetGuid == timesheet.guid;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAssetButton(
            assetPath: Assets.icons.viewIconBlue.path,
            onTap: () => context.push(AppRoutes.timeTrackingTimesheetDetail, extra: timesheet),
            color: AppColors.viewIconBlue,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.checkIconGreen.path,
            isLoading: isApproving,
            onTap: isApproving || isRejecting ? null : () => TimesheetActions.approveTimesheet(context, ref, timesheet),
            width: 17.w,
            height: 17.h,
            color: AppColors.success,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.closeIcon.path,
            isLoading: isRejecting,
            onTap: isApproving || isRejecting ? null : () => TimesheetActions.rejectTimesheet(context, ref, timesheet),
            width: 17.w,
            height: 17.h,
            color: AppColors.error,
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.viewIconBlue.path,
          onTap: () => context.push(AppRoutes.timeTrackingTimesheetDetail, extra: timesheet),
          color: AppColors.viewIconBlue,
        ),
      ],
    );
  }
}
