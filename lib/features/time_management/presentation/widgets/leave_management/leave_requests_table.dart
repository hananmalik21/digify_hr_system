import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/leave_requests_table_header.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/leave_requests_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTable extends StatelessWidget {
  final String filter;

  const LeaveRequestsTable({
    super.key,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    // Mock data - replace with actual data from provider
    final leaveRequests = _getMockLeaveRequests(filter);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LeaveRequestsTableHeader(),
            if (leaveRequests.isEmpty)
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
              ...leaveRequests.map(
                (request) => LeaveRequestsTableRow(
                  data: request,
                  onApprove: () {
                    // TODO: Handle approve action
                  },
                  onReject: () {
                    // TODO: Handle reject action
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<LeaveRequestRowData> _getMockLeaveRequests(String filter) {
    final allRequests = [
      const LeaveRequestRowData(
        employee: '',
        type: 'Annual',
        startDate: '12/20/2024',
        endDate: '12/27/2024',
        days: '7',
        reason: 'Family vacation',
        status: 'Pending',
      ),
      const LeaveRequestRowData(
        employee: '',
        type: 'Sick',
        startDate: '12/10/2024',
        endDate: '12/12/2024',
        days: '3',
        reason: 'Medical treatment',
        status: 'Approved',
      ),
    ];

    if (filter == 'all') {
      return allRequests;
    }

    return allRequests
        .where((request) => request.status.toLowerCase() == filter.toLowerCase())
        .toList();
  }
}
