import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/mappers/schedule_assignment_mapper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/enterprise_error_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/enterprise_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentsTab extends ConsumerStatefulWidget {
  const ScheduleAssignmentsTab({super.key});

  @override
  ConsumerState<ScheduleAssignmentsTab> createState() => _ScheduleAssignmentsTabState();
}

class _ScheduleAssignmentsTabState extends ConsumerState<ScheduleAssignmentsTab> with ScrollPaginationMixin {
  int? _selectedEnterpriseId;
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
    if (_selectedEnterpriseId == null) return;
    ref.read(scheduleAssignmentsNotifierProvider(_selectedEnterpriseId!).notifier).loadNextPage();
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    setState(() {
      _selectedEnterpriseId = enterpriseId;
    });
    if (enterpriseId != null) {
      ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterprisesState = ref.watch(enterprisesProvider);
    final scheduleAssignmentsState = _selectedEnterpriseId != null
        ? ref.watch(scheduleAssignmentsNotifierProvider(_selectedEnterpriseId!))
        : const ScheduleAssignmentState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EnterpriseSelectorWidget(
          selectedEnterpriseId: _selectedEnterpriseId,
          onEnterpriseChanged: _onEnterpriseChanged,
        ),
        if (enterprisesState.hasError) EnterpriseErrorWidget(enterprisesState: enterprisesState),
        if (_selectedEnterpriseId != null && !enterprisesState.hasError) ...[
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          ScheduleAssignmentActionBar(onAssignSchedule: () {}, onBulkUpload: () {}, onExport: () {}),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          _buildContent(scheduleAssignmentsState),
        ] else
          const Center(
            child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view schedule assignments'),
          ),
      ],
    );
  }

  Widget _buildContent(ScheduleAssignmentState scheduleAssignmentsState) {
    if (scheduleAssignmentsState.isLoading && scheduleAssignmentsState.items.isEmpty) {
      return const ScheduleAssignmentsTableSkeleton(itemCount: 5);
    }

    if (scheduleAssignmentsState.hasError && scheduleAssignmentsState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${scheduleAssignmentsState.errorMessage ?? 'Unknown error'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedEnterpriseId != null) {
                  ref.read(scheduleAssignmentsNotifierProvider(_selectedEnterpriseId!).notifier).refresh();
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (scheduleAssignmentsState.items.isEmpty) {
      return const Center(
        child: TimeManagementEmptyStateWidget(
          message: 'No schedule assignments found. Create your first assignment to get started.',
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          ScheduleAssignmentsTable(
            assignments: ScheduleAssignmentMapper.toTableRowDataList(scheduleAssignmentsState.items),
          ),
          if (scheduleAssignmentsState.isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
            ),
        ],
      ),
    );
  }
}
