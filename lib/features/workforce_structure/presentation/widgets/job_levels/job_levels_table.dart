import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
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

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(context, 'Level Name', 244.57.w),
          _buildHeaderCell(context, 'Code', 133.38.w),
          _buildHeaderCell(context, 'Description', 446.61.w),
          _buildHeaderCell(context, 'Grade Range', 248.44.w),
          _buildHeaderCell(context, 'Total Positions', 216.64.w),
          _buildHeaderCell(context, 'Actions', 170.w),
        ],
      ),
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
