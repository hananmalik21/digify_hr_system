import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/data/config/workforce_positions_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const PositionTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (WorkforcePositionsTableConfig.showPositionCode) {
      headerCells.add(
        _buildHeaderCell(context, localizations.positionCode, WorkforcePositionsTableConfig.positionCodeWidth.w),
      );
    }
    if (WorkforcePositionsTableConfig.showTitle) {
      headerCells.add(_buildHeaderCell(context, localizations.title, WorkforcePositionsTableConfig.titleWidth.w));
    }
    if (WorkforcePositionsTableConfig.showDepartment) {
      headerCells.add(
        _buildHeaderCell(context, localizations.department, WorkforcePositionsTableConfig.departmentWidth.w),
      );
    }
    if (WorkforcePositionsTableConfig.showJobFamily) {
      headerCells.add(
        _buildHeaderCell(context, localizations.jobFamily, WorkforcePositionsTableConfig.jobFamilyWidth.w),
      );
    }
    if (WorkforcePositionsTableConfig.showJobLevel) {
      headerCells.add(_buildHeaderCell(context, localizations.jobLevel, WorkforcePositionsTableConfig.jobLevelWidth.w));
    }
    if (WorkforcePositionsTableConfig.showGradeStep) {
      headerCells.add(
        _buildHeaderCell(context, localizations.gradeStep, WorkforcePositionsTableConfig.gradeStepWidth.w),
      );
    }
    if (WorkforcePositionsTableConfig.showReportsTo) {
      headerCells.add(
        _buildHeaderCell(context, localizations.reportsTo, WorkforcePositionsTableConfig.reportsToWidth.w),
      );
    }
    if (WorkforcePositionsTableConfig.showHeadcount) {
      headerCells.add(
        _buildHeaderCell(context, localizations.headcount, WorkforcePositionsTableConfig.headcountWidth.w),
      );
    }
    if (WorkforcePositionsTableConfig.showVacancy) {
      headerCells.add(_buildHeaderCell(context, localizations.vacancy, WorkforcePositionsTableConfig.vacancyWidth.w));
    }
    if (WorkforcePositionsTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, WorkforcePositionsTableConfig.statusWidth.w));
    }
    if (WorkforcePositionsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, localizations.actions, WorkforcePositionsTableConfig.actionsWidth.w));
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
