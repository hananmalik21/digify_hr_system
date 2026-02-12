import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_requests_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const LeaveRequestsTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (LeaveRequestsTableConfig.showLeaveNumber) {
      headerCells.add(_buildHeaderCell(context, 'Leave #', LeaveRequestsTableConfig.leaveNumberWidth.w));
    }
    if (LeaveRequestsTableConfig.showEmployeeNumber) {
      headerCells.add(
        _buildHeaderCell(context, localizations.employeeNumber, LeaveRequestsTableConfig.employeeNumberWidth.w),
      );
    }
    if (LeaveRequestsTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, localizations.employeeName, LeaveRequestsTableConfig.employeeWidth.w));
    }
    if (LeaveRequestsTableConfig.showDepartment) {
      headerCells.add(_buildHeaderCell(context, localizations.department, LeaveRequestsTableConfig.departmentWidth.w));
    }
    if (LeaveRequestsTableConfig.showPosition) {
      headerCells.add(_buildHeaderCell(context, localizations.position, LeaveRequestsTableConfig.positionWidth.w));
    }
    if (LeaveRequestsTableConfig.showLeaveType) {
      headerCells.add(_buildHeaderCell(context, localizations.tmType, LeaveRequestsTableConfig.leaveTypeWidth.w));
    }
    if (LeaveRequestsTableConfig.showStartDate) {
      headerCells.add(_buildHeaderCell(context, localizations.startDate, LeaveRequestsTableConfig.startDateWidth.w));
    }
    if (LeaveRequestsTableConfig.showEndDate) {
      headerCells.add(_buildHeaderCell(context, localizations.endDate, LeaveRequestsTableConfig.endDateWidth.w));
    }
    if (LeaveRequestsTableConfig.showDays) {
      headerCells.add(_buildHeaderCell(context, localizations.days, LeaveRequestsTableConfig.daysWidth.w));
    }
    if (LeaveRequestsTableConfig.showReason) {
      headerCells.add(_buildHeaderCell(context, localizations.reason, LeaveRequestsTableConfig.reasonWidth.w));
    }
    if (LeaveRequestsTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, LeaveRequestsTableConfig.statusWidth.w));
    }
    if (LeaveRequestsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, localizations.actions, LeaveRequestsTableConfig.actionsWidth.w));
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(text.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
