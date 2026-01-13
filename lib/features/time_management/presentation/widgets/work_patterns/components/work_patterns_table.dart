import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_table_header.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_table_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_table_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/work_pattern_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkPatternsTable extends ConsumerWidget {
  final List<WorkPattern> workPatterns;
  final ValueChanged<WorkPattern>? onView;
  final ValueChanged<WorkPattern>? onEdit;
  final ValueChanged<WorkPattern>? onDelete;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ScrollController? scrollController;

  const WorkPatternsTable({
    super.key,
    required this.workPatterns,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.scrollController,
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
          enabled: isLoading && workPatterns.isEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkPatternTableHeader(isDark: isDark, localizations: localizations),
              if (isLoading && workPatterns.isEmpty)
                WorkPatternTableSkeleton(localizations: localizations)
              else if (hasError && workPatterns.isEmpty)
                _buildErrorState(isDark, localizations)
              else if (workPatterns.isEmpty && !isLoading)
                _buildEmptyState(isDark, localizations)
              else ...[
                ...workPatterns.map(
                  (pattern) => WorkPatternTableRow(
                    workPattern: pattern,
                    onView: onView != null
                        ? () => onView!(pattern)
                        : () => WorkPatternDetailsDialog.show(context, pattern),
                    onEdit: onEdit != null ? () => onEdit!(pattern) : null,
                    onDelete: onDelete != null ? () => onDelete!(pattern) : null,
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
