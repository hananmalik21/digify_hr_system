import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/create_schedule_assignment_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/edit_schedule_assignment_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/view_schedule_assignment_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/mappers/schedule_assignment_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentsTab extends ConsumerStatefulWidget {
  const ScheduleAssignmentsTab({super.key});

  @override
  ConsumerState<ScheduleAssignmentsTab> createState() => _ScheduleAssignmentsTabState();
}

class _ScheduleAssignmentsTabState extends ConsumerState<ScheduleAssignmentsTab> with ScrollPaginationMixin {
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
    ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier).loadNextPage();
  }

  Future<void> _handleDelete(
    BuildContext context,
    ScheduleAssignmentTableRowData item,
    ScheduleAssignmentState state,
  ) async {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;

    final assignment = state.items.firstWhere((a) => a.scheduleAssignmentId == item.scheduleAssignmentId);

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Schedule Assignment',
      message: 'Are you sure you want to delete this schedule assignment?',
      itemName: '${assignment.assignedToName} - ${assignment.workSchedule?.scheduleNameEn ?? 'N/A'}',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
    );

    if (confirmed == true && mounted) {
      await ref
          .read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier)
          .deleteScheduleAssignment(assignment.scheduleAssignmentId, hard: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(timeManagementSelectedEnterpriseProvider);
    final scheduleAssignmentsState = selectedEnterpriseId != null
        ? ref.watch(scheduleAssignmentsNotifierProvider(selectedEnterpriseId))
        : const ScheduleAssignmentState();

    if (selectedEnterpriseId != null) {
      ref.listen<ScheduleAssignmentState>(scheduleAssignmentsNotifierProvider(selectedEnterpriseId), (previous, next) {
        final wasDeleting = previous?.deletingAssignmentId != null;
        final isDeleting = next.deletingAssignmentId != null;

        if (wasDeleting && !isDeleting) {
          final deletedId = previous!.deletingAssignmentId!;
          final itemWasRemoved = !next.items.any((a) => a.scheduleAssignmentId == deletedId);

          if (itemWasRemoved && context.mounted) {
            ToastService.success(context, 'Schedule assignment deleted successfully', title: 'Success');
          } else if (!itemWasRemoved && context.mounted) {
            ToastService.error(context, 'Failed to delete schedule assignment', title: 'Error');
          }
        }
      });
    }

    if (selectedEnterpriseId == null) {
      return const Center(
        child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view schedule assignments'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ScheduleAssignmentActionBar(
          onAssignSchedule: () {
            CreateScheduleAssignmentDialog.show(context, selectedEnterpriseId);
          },
          onBulkUpload: () {},
          onExport: () {},
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
        _buildContent(scheduleAssignmentsState),
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
                final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
                if (enterpriseId != null) {
                  ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier).refresh();
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
            deletingAssignmentId: scheduleAssignmentsState.deletingAssignmentId,
            onView: (item) {
              final assignment = scheduleAssignmentsState.items.firstWhere(
                (a) => a.scheduleAssignmentId == item.scheduleAssignmentId,
              );
              ViewScheduleAssignmentDialog.show(context, assignment);
            },
            onEdit: (item) {
              final assignment = scheduleAssignmentsState.items.firstWhere(
                (a) => a.scheduleAssignmentId == item.scheduleAssignmentId,
              );
              final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
              if (enterpriseId != null) {
                EditScheduleAssignmentDialog.show(context, enterpriseId, assignment);
              }
            },
            onDelete: (item) => _handleDelete(context, item, scheduleAssignmentsState),
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
