import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_patterns_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/delete_work_pattern_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternsTab extends ConsumerStatefulWidget {
  const WorkPatternsTab({super.key});

  @override
  ConsumerState<WorkPatternsTab> createState() => _WorkPatternsTabState();
}

class _WorkPatternsTabState extends ConsumerState<WorkPatternsTab> with ScrollPaginationMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  ScrollController? get scrollController => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onLoadMore() {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;

    final state = ref.read(workPatternsNotifierProvider(enterpriseId));
    if (state.hasNextPage && !state.isLoadingMore) {
      ref.read(workPatternsNotifierProvider(enterpriseId).notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(timeManagementSelectedEnterpriseProvider);
    final workPatternsState = selectedEnterpriseId != null
        ? ref.watch(workPatternsNotifierProvider(selectedEnterpriseId))
        : const WorkPatternState();

    if (selectedEnterpriseId == null) {
      return const TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view work patterns');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final minHeight = 400.h;
        final maxHeight = 800.h;
        final tableHeight = availableHeight > 0 ? (availableHeight * 0.6).clamp(minHeight, maxHeight) : maxHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkPatternActionBar(
              onCreatePattern: () {
                CreateWorkPatternDialog.show(context, selectedEnterpriseId);
              },
              onUpload: () {},
              onExport: () {},
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: tableHeight, minHeight: 200.h),
              child: WorkPatternsTable(
                workPatterns: workPatternsState.items,
                isLoading: workPatternsState.isLoading,
                isLoadingMore: workPatternsState.isLoadingMore,
                hasError: workPatternsState.hasError,
                errorMessage: workPatternsState.errorMessage,
                scrollController: _scrollController,
                onRetry: () {
                  ref.read(workPatternsNotifierProvider(selectedEnterpriseId).notifier).refresh();
                },
                onEdit: (pattern) {
                  EditWorkPatternDialog.show(context, selectedEnterpriseId, pattern);
                },
                onDelete: (pattern) {
                  DeleteWorkPatternDialog.show(context, pattern, selectedEnterpriseId);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
