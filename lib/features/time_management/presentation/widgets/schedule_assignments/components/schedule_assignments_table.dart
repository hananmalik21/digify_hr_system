import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_header.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleAssignmentsTable extends ConsumerWidget {
  final List<ScheduleAssignmentTableRowData> assignments;
  final Function(ScheduleAssignmentTableRowData)? onView;
  final Function(ScheduleAssignmentTableRowData)? onEdit;
  final Function(ScheduleAssignmentTableRowData)? onDelete;
  final int? deletingAssignmentId;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ScheduleAssignmentsTable({
    super.key,
    required this.assignments,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.deletingAssignmentId,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Skeletonizer(
          enabled: isLoading && assignments.isEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScheduleAssignmentTableHeader(isDark: isDark, localizations: localizations),
              if (isLoading && assignments.isEmpty)
                ScheduleAssignmentsTableSkeleton(itemCount: 5)
              else if (hasError && assignments.isEmpty)
                _buildErrorState(isDark, localizations)
              else if (assignments.isEmpty && !isLoading)
                _buildEmptyState(isDark, localizations)
              else ...[
                ...assignments.map(
                  (assignment) => ScheduleAssignmentTableRow(
                    data: assignment,
                    onView: onView != null ? () => onView!(assignment) : null,
                    onEdit: onEdit != null ? () => onEdit!(assignment) : null,
                    onDelete: onDelete != null ? () => onDelete!(assignment) : null,
                    isDeleting: deletingAssignmentId == assignment.scheduleAssignmentId,
                  ),
                ),
                if (isLoadingMore) _buildLoadingMoreState(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark, AppLocalizations localizations) {
    return Container(
      width: 1200.w,
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage ?? 'Something went wrong',
              style: TextStyle(fontSize: 16.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[Gap(16.h), ElevatedButton(onPressed: onRetry, child: const Text('Retry'))],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations localizations) {
    return Container(
      width: 1200.w,
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Text(
          localizations.noResultsFound,
          style: TextStyle(fontSize: 16.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreState() {
    return Container(
      width: 1200.w,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
