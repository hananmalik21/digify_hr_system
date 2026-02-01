import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/employee_management/data/config/manage_employees_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const EmployeeTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (ManageEmployeesTableConfig.showIndex) {
      headerCells.add(_buildHeaderCell(context, '#', ManageEmployeesTableConfig.indexWidth.w));
    }
    if (ManageEmployeesTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, localizations.employee, ManageEmployeesTableConfig.employeeWidth.w));
    }
    if (ManageEmployeesTableConfig.showPosition) {
      headerCells.add(_buildHeaderCell(context, localizations.position, ManageEmployeesTableConfig.positionWidth.w));
    }
    if (ManageEmployeesTableConfig.showDepartment) {
      headerCells.add(
        _buildHeaderCell(context, localizations.department, ManageEmployeesTableConfig.departmentWidth.w),
      );
    }
    if (ManageEmployeesTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, ManageEmployeesTableConfig.statusWidth.w));
    }
    if (ManageEmployeesTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, localizations.actions, ManageEmployeesTableConfig.actionsWidth.w));
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
