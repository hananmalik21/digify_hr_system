import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_balances_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalancesTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const LeaveBalancesTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (LeaveBalancesTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, localizations.employee, LeaveBalancesTableConfig.employeeWidth.w));
    }
    if (LeaveBalancesTableConfig.showDepartment) {
      headerCells.add(_buildHeaderCell(context, 'Department', LeaveBalancesTableConfig.departmentWidth.w));
    }
    if (LeaveBalancesTableConfig.showJoinDate) {
      headerCells.add(_buildHeaderCell(context, 'Join Date', LeaveBalancesTableConfig.joinDateWidth.w));
    }
    if (LeaveBalancesTableConfig.showAnnualLeave) {
      headerCells.add(
        _buildHeaderCell(context, 'Annual Leave', LeaveBalancesTableConfig.annualLeaveWidth.w, center: true),
      );
    }
    if (LeaveBalancesTableConfig.showSickLeave) {
      headerCells.add(_buildHeaderCell(context, 'Sick Leave', LeaveBalancesTableConfig.sickLeaveWidth.w, center: true));
    }
    if (LeaveBalancesTableConfig.showUnpaidLeave) {
      headerCells.add(
        _buildHeaderCell(context, 'Unpaid Leave', LeaveBalancesTableConfig.unpaidLeaveWidth.w, center: true),
      );
    }
    if (LeaveBalancesTableConfig.showTotalAvailable) {
      headerCells.add(
        _buildHeaderCell(context, 'Total Available', LeaveBalancesTableConfig.totalAvailableWidth.w, center: true),
      );
    }
    if (LeaveBalancesTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(context, localizations.actions, LeaveBalancesTableConfig.actionsWidth.w, center: true),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {bool center = false}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(text.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
