import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_filters_bar.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_summary_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllLeaveBalancesTab extends ConsumerStatefulWidget {
  const AllLeaveBalancesTab({super.key});

  @override
  ConsumerState<AllLeaveBalancesTab> createState() => _AllLeaveBalancesTabState();
}

class _AllLeaveBalancesTabState extends ConsumerState<AllLeaveBalancesTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveEnterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24.h,
        children: [
          DigifyTabHeader(title: localizations.leaveBalance, description: localizations.leaveBalanceDescription),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
            subtitle: effectiveEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          LeaveBalancesSummaryCards(localizations: localizations, isDark: isDark),
          LeaveBalancesFiltersBar(
            localizations: localizations,
            searchController: _searchController,
            onSearchChanged: (value) => ref.read(leaveBalanceSummaryListProvider.notifier).setSearchQueryInput(value),
            onSearchSubmitted: (value) => ref.read(leaveBalanceSummaryListProvider.notifier).search(value.trim()),
            onExport: () {},
            onRefresh: () => ref.read(leaveBalanceSummaryListProvider.notifier).refresh(),
          ),
          const LeaveBalancesTable(),
        ],
      ),
    );
  }
}
