import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:flutter/widgets.dart';

class TimesheetStatusChip extends StatelessWidget {
  final TimesheetStatus status;

  const TimesheetStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = _TimesheetStatusChipStyle.fromStatus(status);

    return DigifyCapsule(
      label: status.displayName,
      backgroundColor: style.backgroundColor,
      textColor: style.textColor,
    );
  }
}

class _TimesheetStatusChipStyle {
  final Color backgroundColor;
  final Color textColor;

  const _TimesheetStatusChipStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  static _TimesheetStatusChipStyle fromStatus(TimesheetStatus status) {
    switch (status) {
      case TimesheetStatus.draft:
        return const _TimesheetStatusChipStyle(
          backgroundColor: AppColors.cardBackgroundGrey,
          textColor: AppColors.grayText,
        );
      case TimesheetStatus.submitted:
        return const _TimesheetStatusChipStyle(
          backgroundColor: AppColors.infoBg,
          textColor: AppColors.infoText,
        );
      case TimesheetStatus.approved:
        return const _TimesheetStatusChipStyle(
          backgroundColor: AppColors.successBg,
          textColor: AppColors.successText,
        );
      case TimesheetStatus.rejected:
        return const _TimesheetStatusChipStyle(
          backgroundColor: AppColors.errorBg,
          textColor: AppColors.errorText,
        );
      case TimesheetStatus.withdrawn:
        return const _TimesheetStatusChipStyle(
          backgroundColor: AppColors.cardBackgroundGrey,
          textColor: AppColors.textSecondary,
        );
    }
  }
}
