import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/create_schedule_assignment_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/edit_schedule_assignment_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/view_schedule_assignment_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/mappers/schedule_assignment_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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
        Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
        _buildContent(scheduleAssignmentsState),
      ],
    );
  }

  Widget _buildContent(ScheduleAssignmentState scheduleAssignmentsState) {
    final selectedEnterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (selectedEnterpriseId == null) return const SizedBox.shrink();

    return ScheduleAssignmentsTable(
      assignments: ScheduleAssignmentMapper.toTableRowDataList(scheduleAssignmentsState.items),
      deletingAssignmentId: scheduleAssignmentsState.deletingAssignmentId,
      isLoading: scheduleAssignmentsState.isLoading && scheduleAssignmentsState.items.isEmpty,
      isLoadingMore: scheduleAssignmentsState.isLoadingMore,
      hasError: scheduleAssignmentsState.hasError && scheduleAssignmentsState.items.isEmpty,
      errorMessage: scheduleAssignmentsState.errorMessage,
      onRetry: () {
        ref.read(scheduleAssignmentsNotifierProvider(selectedEnterpriseId).notifier).refresh();
      },
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
        EditScheduleAssignmentDialog.show(context, selectedEnterpriseId, assignment);
      },
      onDelete: (item) => _handleDelete(context, item, scheduleAssignmentsState),
    );
  }
}
