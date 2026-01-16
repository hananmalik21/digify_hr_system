import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_filter_provider.dart';
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
    final filter = ref.watch(leaveFilterProvider);

    // Mock data - replace with actual data from provider
    final mockRequests = _getMockLeaveRequests();
    final filteredRequests = _filterRequests(mockRequests, filter);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeaveRequestsTableHeader(isDark: isDark, localizations: localizations),
            if (filteredRequests.isEmpty)
              SizedBox(
                width: 1200.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: Center(
                    child: Text(
                      localizations.noResultsFound,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              )
            else
              ...filteredRequests.map(
                (request) => LeaveRequestsTableRow(
                  request: request,
                  localizations: localizations,
                  isDark: isDark,
                  onApprove: () {},
                  onReject: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<TimeOffRequest> _getMockLeaveRequests() {
    return [
      TimeOffRequest(
        id: 1,
        employeeId: 1,
        employeeName: '', // Empty as shown in design
        type: TimeOffType.annualLeave,
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 27),
        totalDays: 7,
        status: RequestStatus.pending,
        reason: 'Family vacation',
      ),
      TimeOffRequest(
        id: 2,
        employeeId: 2,
        employeeName: '', // Empty as shown in design
        type: TimeOffType.sickLeave,
        startDate: DateTime(2024, 12, 10),
        endDate: DateTime(2024, 12, 12),
        totalDays: 3,
        status: RequestStatus.approved,
        reason: 'Medical treatment',
      ),
    ];
  }

  List<TimeOffRequest> _filterRequests(List<TimeOffRequest> requests, LeaveFilter filter) {
    if (filter == LeaveFilter.all) {
      return requests;
    }

    final statusMap = {
      LeaveFilter.pending: RequestStatus.pending,
      LeaveFilter.approved: RequestStatus.approved,
      LeaveFilter.rejected: RequestStatus.rejected,
    };

    final targetStatus = statusMap[filter];
    return requests.where((request) => request.status == targetStatus).toList();
  }
}
