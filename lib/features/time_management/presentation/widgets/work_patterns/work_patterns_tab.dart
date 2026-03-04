import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/feedback/empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_patterns_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/delete_work_pattern_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternsTab extends ConsumerWidget {
  const WorkPatternsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveEnterpriseId = ref.watch(workPatternsTabEnterpriseIdProvider);

    if (effectiveEnterpriseId == null) {
      return Padding(
        padding: EdgeInsets.only(top: 24.h),
        child: EmptyStateWidget(
          icon: Icons.business_outlined,
          title: 'Select an Enterprise',
          message: 'Please select an enterprise from above to view and manage work patterns',
        ),
      );
    }

    final state = ref.watch(workPatternsNotifierProvider(effectiveEnterpriseId));
    final notifier = ref.read(workPatternsNotifierProvider(effectiveEnterpriseId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Gap(24.h), _buildContent(context, state, notifier, effectiveEnterpriseId)],
    );
  }

  Widget _buildContent(BuildContext context, WorkPatternState state, WorkPatternsNotifier notifier, int enterpriseId) {
    if (state.isLoading && state.items.isEmpty) {
      return WorkPatternsTable(workPatterns: const [], isLoading: true, onRetry: () => notifier.refresh());
    }

    if (state.hasError && state.items.isEmpty) {
      return DigifyErrorState(
        message: state.errorMessage ?? 'Failed to load work patterns',
        onRetry: () => notifier.refresh(),
      );
    }

    if (state.items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_view_week_outlined,
        title: 'No Work Patterns Found',
        message: 'There are no work patterns available for this enterprise.',
      );
    }

    final paginationInfo = state.totalPages > 0
        ? PaginationInfo(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: state.pageSize,
            hasNext: state.hasNextPage,
            hasPrevious: state.hasPreviousPage,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkPatternsTable(
          workPatterns: state.items,
          isLoading: state.isLoading,
          isLoadingMore: state.isLoadingMore,
          hasError: state.hasError,
          errorMessage: state.errorMessage,
          onRetry: () => notifier.refresh(),
          onEdit: (pattern) => EditWorkPatternDialog.show(context, enterpriseId, pattern),
          onDelete: (pattern) => DeleteWorkPatternDialog.show(context, pattern, enterpriseId),
          paginationInfo: paginationInfo,
          currentPage: state.currentPage,
          pageSize: state.pageSize,
          onPrevious: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
          onNext: state.hasNextPage ? () => notifier.goToPage(state.currentPage + 1) : null,
          paginationIsLoading: state.isLoading || state.isLoadingMore,
        ),
        Gap(24.h),
      ],
    );
  }
}
