import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/data/config/schedule_assignments_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ScheduleAssignmentTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (ScheduleAssignmentsTableConfig.showAssignedTo) {
      headerCells.add(_buildHeaderCell(context, 'Assigned To', ScheduleAssignmentsTableConfig.assignedToWidth.w));
    }
    if (ScheduleAssignmentsTableConfig.showSchedule) {
      headerCells.add(_buildHeaderCell(context, 'Schedule', ScheduleAssignmentsTableConfig.scheduleWidth.w));
    }
    if (ScheduleAssignmentsTableConfig.showStartDate) {
      headerCells.add(_buildHeaderCell(context, 'Start Date', ScheduleAssignmentsTableConfig.startDateWidth.w));
    }
    if (ScheduleAssignmentsTableConfig.showEndDate) {
      headerCells.add(_buildHeaderCell(context, 'End Date', ScheduleAssignmentsTableConfig.endDateWidth.w));
    }
    if (ScheduleAssignmentsTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, ScheduleAssignmentsTableConfig.statusWidth.w));
    }
    if (ScheduleAssignmentsTableConfig.showAssignedBy) {
      headerCells.add(_buildHeaderCell(context, 'Assigned By', ScheduleAssignmentsTableConfig.assignedByWidth.w));
    }
    if (ScheduleAssignmentsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, localizations.actions, ScheduleAssignmentsTableConfig.actionsWidth.w));
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(text, style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
