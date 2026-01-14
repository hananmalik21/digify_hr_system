import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/data/config/work_patterns_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const WorkPatternTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (WorkPatternsTableConfig.showCode) {
      headerCells.add(_buildHeaderCell(context, localizations.code, WorkPatternsTableConfig.codeWidth.w));
    }
    if (WorkPatternsTableConfig.showName) {
      headerCells.add(_buildHeaderCell(context, 'NAME', WorkPatternsTableConfig.nameWidth.w));
    }
    if (WorkPatternsTableConfig.showType) {
      headerCells.add(_buildHeaderCell(context, 'TYPE', WorkPatternsTableConfig.typeWidth.w));
    }
    if (WorkPatternsTableConfig.showWorkingDays) {
      headerCells.add(_buildHeaderCell(context, 'WORKING DAYS', WorkPatternsTableConfig.workingDaysWidth.w));
    }
    if (WorkPatternsTableConfig.showRestDays) {
      headerCells.add(_buildHeaderCell(context, 'REST DAYS', WorkPatternsTableConfig.restDaysWidth.w));
    }
    if (WorkPatternsTableConfig.showHoursPerWeek) {
      headerCells.add(_buildHeaderCell(context, 'HOURS/WEEK', WorkPatternsTableConfig.hoursPerWeekWidth.w));
    }
    if (WorkPatternsTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, WorkPatternsTableConfig.statusWidth.w));
    }
    if (WorkPatternsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, localizations.actions, WorkPatternsTableConfig.actionsWidth.w));
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
