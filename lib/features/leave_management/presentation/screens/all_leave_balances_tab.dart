import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_balances_local_data_source.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_filters_bar.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_labor_law_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_summary_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_table_section.dart';
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
  final LeaveBalancesLocalDataSource _dataSource = LeaveBalancesLocalDataSource();

  List<Map<String, dynamic>> get _employees => _dataSource.getEmployees();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(leaveManagementSelectedEnterpriseProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24.h,
        children: [
          LeaveBalancesHeader(localizations: localizations),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: selectedEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
            subtitle: selectedEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          LeaveBalancesSummaryCards(localizations: localizations),
          LeaveBalancesLaborLawSection(localizations: localizations),
          LeaveBalancesFiltersBar(
            localizations: localizations,
            searchController: _searchController,
            onExport: () {},
            onRefresh: () {},
          ),
          LeaveBalancesTableSection(localizations: localizations, employees: _employees, isDark: context.isDark),
        ],
      ),
    );
  }
}
