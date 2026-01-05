import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/enterprise_error_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/enterprise_selector_widget.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
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

  final List<ScheduleAssignmentTableRowData> _mockAssignments = [
    ScheduleAssignmentTableRowData(
      assignedToName: 'Human Resources Department',
      assignedToCode: 'DEPT-HR',
      scheduleName: 'Admin Department Schedule 2024',
      startDate: '2024-01-01',
      endDate: '2024-12-31',
      isActive: true,
      assignedByName: 'HR Manager',
    ),
    ScheduleAssignmentTableRowData(
      assignedToName: 'Finance Department',
      assignedToCode: 'DEPT-FIN',
      scheduleName: 'Admin Department Schedule 2024',
      startDate: '2024-01-01',
      endDate: '2024-12-31',
      isActive: true,
      assignedByName: 'HR Manager',
    ),
    ScheduleAssignmentTableRowData(
      assignedToName: 'Operations Department',
      assignedToCode: 'DEPT-OPS',
      scheduleName: 'Operations Rotating Schedule',
      startDate: '2024-01-01',
      endDate: '2024-12-31',
      isActive: true,
      assignedByName: 'Operations Manager',
    ),
    ScheduleAssignmentTableRowData(
      assignedToName: 'Ahmed Al-Mutairi',
      assignedToCode: 'EMP-12345',
      scheduleName: 'Operations Rotating Schedule',
      startDate: '2024-03-01',
      endDate: '2024-12-31',
      isActive: true,
      assignedByName: 'Operations Manager',
    ),
    ScheduleAssignmentTableRowData(
      assignedToName: 'Sarah Mohammed',
      assignedToCode: 'EMP-67890',
      scheduleName: 'Admin Department Schedule 2024',
      startDate: '2024-02-15',
      endDate: '2024-12-31',
      isActive: true,
      assignedByName: 'HR Manager',
    ),
  ];

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  ScrollController? get scrollController => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onLoadMore() {}

  void _onEnterpriseChanged(int? enterpriseId) {
    if (enterpriseId == null) {
      setState(() {
        _selectedEnterpriseId = null;
      });
      return;
    }

    if (enterpriseId != _selectedEnterpriseId) {
      setState(() {
        _selectedEnterpriseId = enterpriseId;
        _isLoading = true;
        _hasError = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _handleAssignSchedule() {
    if (_selectedEnterpriseId == null) {
      ToastService.warning(context, 'Please select an enterprise first', title: 'Warning');
      return;
    }
    ToastService.info(context, 'Assign Schedule feature coming soon', title: 'Info');
  }

  void _handleBulkUpload() {
    if (_selectedEnterpriseId == null) {
      ToastService.warning(context, 'Please select an enterprise first', title: 'Warning');
      return;
    }
    ToastService.info(context, 'Bulk Upload feature coming soon', title: 'Info');
  }

  void _handleExport() {
    if (_selectedEnterpriseId == null) {
      ToastService.warning(context, 'Please select an enterprise first', title: 'Warning');
      return;
    }
    ToastService.info(context, 'Export feature coming soon', title: 'Info');
  }

  void _handleViewDetails(ScheduleAssignmentTableRowData assignment) {
    ToastService.info(context, 'View details feature coming soon', title: 'Info');
  }

  void _handleEdit(ScheduleAssignmentTableRowData assignment) {
    if (_selectedEnterpriseId == null) {
      return;
    }
    ToastService.info(context, 'Edit feature coming soon', title: 'Info');
  }

  Future<void> _handleDelete(ScheduleAssignmentTableRowData assignment) async {
    if (_selectedEnterpriseId == null) {
      return;
    }

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Schedule Assignment',
      message: 'Are you sure you want to delete this schedule assignment?',
      itemName: '${assignment.assignedToName} - ${assignment.scheduleName}',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
    );

    if (confirmed == true && mounted) {
      try {
        if (mounted) {
          ToastService.success(context, 'Schedule assignment deleted successfully', title: 'Success');
        }
      } catch (e) {
        if (mounted) {
          ToastService.error(context, 'Failed to delete schedule assignment: ${e.toString()}', title: 'Error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterprisesState = ref.watch(enterprisesProvider);

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
          ScheduleAssignmentActionBar(
            onAssignSchedule: _handleAssignSchedule,
            onBulkUpload: _handleBulkUpload,
            onExport: _handleExport,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          _buildContent(),
        ] else
          const Center(
            child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view schedule assignments'),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const ScheduleAssignmentsTableSkeleton(itemCount: 5);
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${_errorMessage ?? 'Unknown error'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_mockAssignments.isEmpty) {
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
            assignments: _mockAssignments,
            onView: _handleViewDetails,
            onEdit: _handleEdit,
            onDelete: _handleDelete,
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
            ),
        ],
      ),
    );
  }
}
