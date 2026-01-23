import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/employee_info_card.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/leave_balance_cards_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/leave_balance_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Leave Balance Tab - displays employee's personal leave balances
class LeaveBalanceTab extends ConsumerStatefulWidget {
  const LeaveBalanceTab({super.key});

  @override
  ConsumerState<LeaveBalanceTab> createState() => _LeaveBalanceTabState();
}

class _LeaveBalanceTabState extends ConsumerState<LeaveBalanceTab> {
  // Mock employee data - replace with actual data from provider
  final Map<String, dynamic> _employeeData = {
    'name': 'Ahmed Al-Mutairi',
    'employeeNumber': 'EMP001',
    'department': 'IT',
    'joinDate': '2020-01-15',
  };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedEnterpriseId = ref.watch(leaveManagementSelectedEnterpriseProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveBalanceTabHeader(localizations: localizations, isDark: isDark),
          Gap(24.h),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: selectedEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
            subtitle: selectedEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          Gap(21.h),
          EmployeeInfoCard(localizations: localizations, isDark: isDark, employeeData: _employeeData),
          Gap(21.h),
          LeaveBalanceCardsSection(localizations: localizations, isDark: isDark),
        ],
      ),
    );
  }
}
