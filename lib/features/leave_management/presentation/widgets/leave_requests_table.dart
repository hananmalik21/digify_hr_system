import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_requests_table_config.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_actions_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table/leave_requests_table_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table/leave_requests_table_row.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTable extends ConsumerWidget {
  const LeaveRequestsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final requestsAsync = ref.watch(leaveRequestsProvider);
    final filter = ref.watch(leaveFilterProvider);
    final pagination = ref.watch(leaveRequestsPaginationProvider);
    final notifierState = ref.watch(leaveRequestsNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollableSingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeaveRequestsTableHeader(isDark: isDark, localizations: localizations),
                requestsAsync.when(
                  data: (paginatedResponse) {
                    final filtered = _filterRequests(paginatedResponse.requests, filter);
                    if (filtered.isEmpty) {
                      return _buildEmptyState(localizations);
                    }
                    final approveLoading = ref.watch(leaveRequestsApproveLoadingProvider);
                    final rejectLoading = ref.watch(leaveRequestsRejectLoadingProvider);
                    final deleteLoading = ref.watch(leaveRequestsDeleteLoadingProvider);
                    return Column(
                      children: filtered
                          .map(
                            (request) => LeaveRequestsTableRow(
                              request: request,
                              localizations: localizations,
                              isDark: isDark,
                              isApproveLoading: approveLoading.contains(request.guid),
                              isRejectLoading: rejectLoading.contains(request.guid),
                              isDeleteLoading: deleteLoading.contains(request.guid),
                              onApprove: () =>
                                  LeaveRequestsActions.approveLeaveRequest(context, ref, request, localizations),
                              onReject: () =>
                                  LeaveRequestsActions.rejectLeaveRequest(context, ref, request, localizations),
                              onDelete: () =>
                                  LeaveRequestsActions.deleteLeaveRequest(context, ref, request, localizations),
                              onUpdate: () =>
                                  LeaveRequestsActions.updateLeaveRequest(context, ref, request, localizations),
                            ),
                          )
                          .toList(),
                    );
                  },
                  loading: () => _buildLoadingRows(),
                  error: (error, stack) => _buildErrorState(localizations, error.toString()),
                ),
              ],
            ),
          ),
          if (notifierState.data != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: notifierState.data!.pagination,
              currentPage: pagination.page,
              pageSize: pagination.pageSize,
              onPrevious: notifierState.data!.pagination.hasPrevious
                  ? () {
                      ref.read(leaveRequestsPaginationProvider.notifier).state = (
                        page: pagination.page - 1,
                        pageSize: pagination.pageSize,
                      );
                    }
                  : null,
              onNext: notifierState.data!.pagination.hasNext
                  ? () {
                      ref.read(leaveRequestsPaginationProvider.notifier).state = (
                        page: pagination.page + 1,
                        pageSize: pagination.pageSize,
                      );
                    }
                  : null,
              isLoading: false,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return SizedBox(
      width: 1200.w,
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

  Widget _buildLoadingRows() {
    return Column(children: List.generate(5, (index) => _buildLoadingRow()));
  }

  Widget _buildLoadingRow() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (LeaveRequestsTableConfig.showEmployee) _buildLoadingCell(LeaveRequestsTableConfig.employeeWidth.w),
          if (LeaveRequestsTableConfig.showLeaveType) _buildLoadingCell(LeaveRequestsTableConfig.leaveTypeWidth.w),
          if (LeaveRequestsTableConfig.showStartDate) _buildLoadingCell(LeaveRequestsTableConfig.startDateWidth.w),
          if (LeaveRequestsTableConfig.showEndDate) _buildLoadingCell(LeaveRequestsTableConfig.endDateWidth.w),
          if (LeaveRequestsTableConfig.showDays) _buildLoadingCell(LeaveRequestsTableConfig.daysWidth.w),
          if (LeaveRequestsTableConfig.showReason) _buildLoadingCell(LeaveRequestsTableConfig.reasonWidth.w),
          if (LeaveRequestsTableConfig.showStatus) _buildLoadingCell(LeaveRequestsTableConfig.statusWidth.w),
          if (LeaveRequestsTableConfig.showActions) _buildLoadingCell(LeaveRequestsTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  Widget _buildLoadingCell(double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Container(
        height: 16.h,
        decoration: BoxDecoration(color: AppColors.cardBackgroundGrey, borderRadius: BorderRadius.circular(4.r)),
      ),
    );
  }

  List<TimeOffRequest> _filterRequests(List<TimeOffRequest> requests, LeaveFilter filter) {
    if (filter == LeaveFilter.all) {
      return requests;
    }

    final statusMap = {
      LeaveFilter.draft: RequestStatus.draft,
      LeaveFilter.pending: RequestStatus.pending,
      LeaveFilter.approved: RequestStatus.approved,
      LeaveFilter.rejected: RequestStatus.rejected,
    };

    final targetStatus = statusMap[filter];
    if (targetStatus == null) return requests;

    return requests.where((request) => request.status == targetStatus).toList();
  }

  Widget _buildErrorState(AppLocalizations localizations, String error) {
    return SizedBox(
      width: 1200.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            'Error: $error',
            style: TextStyle(fontSize: 16.sp, color: AppColors.error),
          ),
        ),
      ),
    );
  }
}
