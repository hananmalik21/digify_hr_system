import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_row.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportingStructureTable extends StatelessWidget {
  final List<ReportingPosition> positions;
  final bool isLoading;
  final bool isDark;
  final AppLocalizations localizations;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Function(ReportingPosition)? onView;
  final Function(ReportingPosition)? onEdit;

  const ReportingStructureTable({
    super.key,
    required this.positions,
    required this.isLoading,
    required this.isDark,
    required this.localizations,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = 10,
    this.onPrevious,
    this.onNext,
    this.onView,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportingTableHeader(isDark: isDark, localizations: localizations),
                    if (isLoading && positions.isEmpty)
                      ReportingTableSkeleton(localizations: localizations)
                    else if (positions.isEmpty && !isLoading)
                      _buildEmptyState()
                    else
                      ...positions.asMap().entries.map(
                        (entry) => ReportingTableRow(
                          position: entry.value,
                          isDark: isDark,
                          localizations: localizations,
                          onView: onView,
                          onEdit: onEdit,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (paginationInfo != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo!,
              currentPage: currentPage,
              pageSize: pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              isLoading: isLoading,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      width: 900.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}
