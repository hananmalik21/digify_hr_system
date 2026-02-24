import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/configs/reporting_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportingTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ReportingTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (ReportingTableConfig.showCode) {
      headerCells.add(_buildHeaderCell(context, localizations.positionCode, ReportingTableConfig.codeWidth.w));
    }
    if (ReportingTableConfig.showTitle) {
      headerCells.add(_buildHeaderCell(context, localizations.titleEnglish, ReportingTableConfig.titleWidth.w));
    }
    if (ReportingTableConfig.showDepartment) {
      headerCells.add(_buildHeaderCell(context, localizations.department, ReportingTableConfig.departmentWidth.w));
    }
    if (ReportingTableConfig.showLevel) {
      headerCells.add(_buildHeaderCell(context, localizations.jobLevel, ReportingTableConfig.levelWidth.w));
    }
    if (ReportingTableConfig.showGrade) {
      headerCells.add(_buildHeaderCell(context, localizations.gradeStep, ReportingTableConfig.gradeWidth.w));
    }
    if (ReportingTableConfig.showReportsTo) {
      headerCells.add(_buildHeaderCell(context, localizations.reportsTo, ReportingTableConfig.reportsToWidth.w));
    }
    if (ReportingTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, ReportingTableConfig.statusWidth.w));
    }
    if (ReportingTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, localizations.actions, ReportingTableConfig.actionsWidth.w));
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String label, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ReportingTableConfig.cellPaddingHorizontal.w,
        vertical: 14.h,
      ),
      alignment: Alignment.centerLeft,
      child: Text(label.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
