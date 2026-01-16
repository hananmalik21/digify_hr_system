import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table/leave_requests_table_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table/leave_requests_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTable extends ConsumerWidget {
  const LeaveRequestsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final filteredRequestsAsync = ref.watch(filteredLeaveRequestsProvider);

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
            filteredRequestsAsync.when(
              data: (filteredRequests) {
                if (filteredRequests.isEmpty) {
                  return _buildEmptyState(localizations);
                }
                return Column(
                  children: filteredRequests
                      .map(
                        (request) => LeaveRequestsTableRow(
                          request: request,
                          localizations: localizations,
                          isDark: isDark,
                          onApprove: () {},
                          onReject: () {},
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(localizations, error.toString()),
            ),
          ],
        ),
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

  Widget _buildLoadingState() {
    return SizedBox(
      width: 1200.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
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
