import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/core/widgets/feedback/empty_state_widget.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/adjust_leave_balance_dialog.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/leave_balance_tab_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalanceTab extends ConsumerStatefulWidget {
  const LeaveBalanceTab({super.key});

  @override
  ConsumerState<LeaveBalanceTab> createState() => _LeaveBalanceTabState();
}

class _LeaveBalanceTabState extends ConsumerState<LeaveBalanceTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadPage());
  }

  void _maybeLoadPage() {
    final enterpriseId = ref.read(leaveManagementEnterpriseIdProvider);
    final state = ref.read(leaveBalanceSummaryListProvider);
    if (enterpriseId != null && state.items.isEmpty && !state.isLoading && state.error == null) {
      ref.read(leaveBalanceSummaryListProvider.notifier).loadPage(enterpriseId, 1);
    }
  }

  void _onAdjustRequested(BuildContext context, LeaveBalanceSummaryItem item) {
    AdjustLeaveBalanceDialog.show(context, item: item);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);
    final listState = ref.watch(leaveBalanceSummaryListProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveBalanceTabHeader(localizations: localizations, isDark: isDark),
          Gap(24.h),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
            subtitle: effectiveEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          Gap(21.h),
          if (listState.error != null)
            DigifyErrorState(
              message: localizations.somethingWentWrong,
              retryLabel: localizations.retry,
              onRetry: () => ref.read(leaveBalanceSummaryListProvider.notifier).refresh(),
            )
          else if (effectiveEnterpriseId == null)
            SizedBox(
              height: 320.h,
              child: EmptyStateWidget(icon: Icons.business_rounded, title: localizations.selectCompany),
            )
          else if (listState.items.isEmpty && !listState.isLoading)
            SizedBox(
              height: 320.h,
              child: EmptyStateWidget(icon: Icons.calendar_today_rounded, title: localizations.noResultsFound),
            )
          else ...[
            LeaveBalancesTableSection(
              localizations: localizations,
              items: listState.items,
              isDark: isDark,
              isLoading: listState.isLoading,
              error: listState.error != null ? localizations.somethingWentWrong : null,
              onAdjustRequested: _onAdjustRequested,
            ),
            if (listState.pagination != null) ...[
              Gap(16.h),
              PaginationControls.fromPaginationInfo(
                paginationInfo: listState.pagination!,
                currentPage: listState.currentPage,
                pageSize: listState.pagination!.pageSize,
                onPrevious: listState.pagination!.hasPrevious
                    ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage - 1)
                    : null,
                onNext: listState.pagination!.hasNext
                    ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage + 1)
                    : null,
                isLoading: false,
                style: PaginationStyle.simple,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
