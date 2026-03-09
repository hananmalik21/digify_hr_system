import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/features/workforce_structure/data/config/job_levels_table_config.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_row.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelsTable extends StatelessWidget {
  final List<JobLevel> jobLevels;
  final PaginationState<JobLevel>? paginationState;

  const JobLevelsTable({super.key, required this.jobLevels, this.paginationState});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  _buildTableHeader(context, isDark),
                  ...jobLevels.map((level) => JobLevelRow(level: level)),
                ],
              ),
            ),
          ),
          if (paginationState != null && paginationState!.totalPages > 0) ...[
            Gap(24.h),
            Consumer(
              builder: (context, ref, _) {
                return PaginationControls.fromPaginationInfo(
                  paginationInfo: PaginationInfo(
                    currentPage: paginationState!.currentPage,
                    totalPages: paginationState!.totalPages,
                    totalItems: paginationState!.totalItems,
                    pageSize: paginationState!.pageSize,
                    hasNext: paginationState!.hasNextPage,
                    hasPrevious: paginationState!.hasPreviousPage,
                  ),
                  currentPage: paginationState!.currentPage,
                  pageSize: paginationState!.pageSize,
                  onPrevious: paginationState!.hasPreviousPage
                      ? () => ref.read(jobLevelNotifierProvider.notifier).goToPage(paginationState!.currentPage - 1)
                      : null,
                  onNext: paginationState!.hasNextPage
                      ? () => ref.read(jobLevelNotifierProvider.notifier).goToPage(paginationState!.currentPage + 1)
                      : null,
                  isLoading: paginationState!.isLoading,
                  style: PaginationStyle.simple,
                );
              },
            ),
            Gap(24.h),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isDark) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final l10n = AppLocalizations.of(context)!;
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
    if (JobLevelsTableConfig.showMinGrade) {
      headerCells.add(_buildHeaderCell(context, l10n.minimumGrade, JobLevelsTableConfig.minGradeWidth.w));
    }
    if (JobLevelsTableConfig.showMaxGrade) {
      headerCells.add(_buildHeaderCell(context, l10n.maximumGrade, JobLevelsTableConfig.maxGradeWidth.w));
    }
    if (JobLevelsTableConfig.showTotalPositions) {
      headerCells.add(_buildHeaderCell(context, 'Position Count', JobLevelsTableConfig.totalPositionsWidth.w));
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
