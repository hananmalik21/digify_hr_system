import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedules_list.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedules_list_skeleton.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/create_work_schedule_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/update_work_schedule_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkSchedulesTab extends ConsumerStatefulWidget {
  const WorkSchedulesTab({super.key});

  @override
  ConsumerState<WorkSchedulesTab> createState() => _WorkSchedulesTabState();
}

class _WorkSchedulesTabState extends ConsumerState<WorkSchedulesTab> with ScrollPaginationMixin {
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

    final state = ref.read(workSchedulesNotifierProvider(enterpriseId));
    if (state.hasNextPage && !state.isLoadingMore) {
      ref.read(workSchedulesNotifierProvider(enterpriseId).notifier).loadNextPage();
    }
  }

  void _handleCreateSchedule() {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;
    CreateWorkScheduleDialog.show(context, enterpriseId);
  }

  void _handleUpload() {}

  void _handleExport() {}

  void _handleViewDetails(WorkSchedule schedule) {}

  void _handleEdit(WorkSchedule schedule) {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;
    UpdateWorkScheduleDialog.show(context, enterpriseId, schedule);
  }

  Future<void> _handleDelete(WorkSchedule schedule) async {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Work Schedule',
      message: 'Are you sure you want to delete this work schedule?',
      itemName: schedule.scheduleNameEn,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(workSchedulesNotifierProvider(enterpriseId).notifier)
            .deleteWorkSchedule(schedule.workScheduleId, hard: true);
        if (mounted) {
          ToastService.success(context, 'Work schedule deleted successfully', title: 'Success');
        }
      } catch (e) {
        if (mounted) {
          ToastService.error(context, 'Failed to delete work schedule: ${e.toString()}', title: 'Error');
        }
      }
    }
  }

  WorkScheduleItem _convertToItem(WorkSchedule schedule) {
    return WorkScheduleItem(
      title: schedule.scheduleNameEn,
      titleArabic: schedule.scheduleNameAr,
      year: schedule.year,
      code: schedule.scheduleCode,
      isActive: schedule.isActive,
      workPatternName: '',
      assignmentMode: schedule.assignmentMode,
      effectiveStartDate: schedule.formattedStartDate,
      effectiveEndDate: schedule.formattedEndDate,
      weeklySchedule: schedule.weeklySchedule,
      workScheduleId: schedule.workScheduleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(timeManagementSelectedEnterpriseProvider);
    final workSchedulesState = selectedEnterpriseId != null
        ? ref.watch(workSchedulesNotifierProvider(selectedEnterpriseId))
        : const WorkScheduleState();

    if (selectedEnterpriseId == null) {
      return const Center(
        child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view work schedules'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WorkScheduleActionBar(
          onCreateSchedule: _handleCreateSchedule,
          onUpload: _handleUpload,
          onExport: _handleExport,
        ),
        Gap(24.h),
        _buildContent(workSchedulesState),
      ],
    );
  }

  Widget _buildContent(WorkScheduleState workSchedulesState) {
    if (workSchedulesState.isLoading && workSchedulesState.items.isEmpty) {
      return const WorkSchedulesListSkeleton(itemCount: 3);
    }

    if (workSchedulesState.hasError && workSchedulesState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${workSchedulesState.errorMessage ?? 'Unknown error'}'),
            Gap(16.h),
            ElevatedButton(
              onPressed: () {
                final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
                if (enterpriseId != null) {
                  ref.read(workSchedulesNotifierProvider(enterpriseId).notifier).refresh();
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (workSchedulesState.items.isEmpty) {
      return const Center(
        child: TimeManagementEmptyStateWidget(
          message: 'No work schedules found. Create your first schedule to get started.',
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          WorkSchedulesList(
            schedules: workSchedulesState.items.map(_convertToItem).toList(),
            deletingScheduleIds: workSchedulesState.deletingScheduleIds,
            onViewDetails: (item) {
              final schedule = workSchedulesState.items.firstWhere((s) => s.scheduleCode == item.code);
              _handleViewDetails(schedule);
            },
            onEdit: (item) {
              final schedule = workSchedulesState.items.firstWhere((s) => s.scheduleCode == item.code);
              _handleEdit(schedule);
            },
            onDelete: (item) {
              final schedule = workSchedulesState.items.firstWhere((s) => s.workScheduleId == item.workScheduleId);
              _handleDelete(schedule);
            },
          ),
          if (workSchedulesState.isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
            ),
        ],
      ),
    );
  }
}
