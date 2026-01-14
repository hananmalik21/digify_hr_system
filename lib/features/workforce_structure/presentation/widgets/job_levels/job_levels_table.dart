import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/workforce_structure/data/config/job_levels_table_config.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelsTable extends StatelessWidget {
  final List<JobLevel> jobLevels;

  const JobLevelsTable({super.key, required this.jobLevels});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            _buildTableHeader(context, isDark),
            ...jobLevels.map((level) => JobLevelRow(level: level)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isDark) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (JobLevelsTableConfig.showLevelName) {
      headerCells.add(_buildHeaderCell(context, 'Level Name', JobLevelsTableConfig.levelNameWidth.w));
    }
    if (JobLevelsTableConfig.showCode) {
      headerCells.add(_buildHeaderCell(context, 'Code', JobLevelsTableConfig.codeWidth.w));
    }
    if (JobLevelsTableConfig.showDescription) {
      headerCells.add(_buildHeaderCell(context, 'Description', JobLevelsTableConfig.descriptionWidth.w));
    }
    if (JobLevelsTableConfig.showGradeRange) {
      headerCells.add(_buildHeaderCell(context, 'Grade Range', JobLevelsTableConfig.gradeRangeWidth.w));
    }
    if (JobLevelsTableConfig.showTotalPositions) {
      headerCells.add(_buildHeaderCell(context, 'Total Positions', JobLevelsTableConfig.totalPositionsWidth.w));
    }
    if (JobLevelsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, 'Actions', JobLevelsTableConfig.actionsWidth.w));
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
