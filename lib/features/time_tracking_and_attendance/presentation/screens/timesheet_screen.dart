import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_dialog.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_header.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_search_and_filter.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_stats.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_table.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_week_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesheetScreen extends ConsumerStatefulWidget {
  const TimesheetScreen({super.key});

  @override
  ConsumerState<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends ConsumerState<TimesheetScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(timesheetEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(timesheetNotifierProvider.notifier).setCompanyId(enterpriseId.toString());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final effectiveEnterpriseId = ref.watch(timesheetEnterpriseIdProvider);
    final state = ref.watch(timesheetNotifierProvider);
    final notifier = ref.read(timesheetNotifierProvider.notifier);

    final totalPages = state.totalItems == 0 ? 1 : (state.totalItems / state.pageSize).ceil();
    final paginationInfo = PaginationInfo(
      currentPage: state.currentPage,
      totalPages: totalPages,
      totalItems: state.totalItems,
      pageSize: state.pageSize,
      hasNext: state.currentPage < totalPages,
      hasPrevious: state.currentPage > 1,
    );

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            TimesheetScreenHeader(onNewTimesheet: () => NewTimesheetDialog.show(context)),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(timesheetSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
              subtitle: effectiveEnterpriseId != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            WeekNavigation(
              weekStartDate: state.weekStartDate,
              weekEndDate: state.weekEndDate,
              onPreviousWeek: notifier.goToPreviousWeek,
              onNextWeek: notifier.goToNextWeek,
              onCurrentWeek: notifier.goToCurrentWeek,
              onClearFilter: notifier.clearWeekFilter,
              onApplyFilter: notifier.applyWeekFilter,
              isDark: isDark,
              isCurrentWeek: state.isCurrentWeek,
              isWeekFilterEnabled: state.isWeekFilterEnabled,
            ),
            TimesheetStatsGrid(
              total: state.total,
              draft: state.draft,
              submitted: state.submitted,
              approved: state.approved,
              rejected: state.rejected,
              regularHours: state.regularHours,
              overtimeHours: state.overtimeHours,
              isDark: isDark,
            ),
            TimesheetSearchAndFilter(
              searchController: _searchController,
              statusFilter: state.statusFilter,
              onSearchChanged: notifier.setSearchQuery,
              onStatusFilterChanged: notifier.setStatusFilter,
              isDark: isDark,
            ),
            TimesheetTable(
              localizations: localizations,
              records: state.records,
              isDark: isDark,
              isLoading: state.isLoading,
              paginationInfo: paginationInfo,
              currentPage: state.currentPage,
              pageSize: state.pageSize,
              onPrevious: state.currentPage > 1 ? () => notifier.setPage(state.currentPage - 1) : null,
              onNext: state.currentPage < totalPages ? () => notifier.setPage(state.currentPage + 1) : null,
            ),
          ],
        ),
      ),
    );
  }
}
