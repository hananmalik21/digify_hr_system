import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/employee_info_card.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/leave_balance_cards_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_tab/leave_balance_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Leave Balance Tab - displays employee's personal leave balances
class LeaveBalanceTab extends StatefulWidget {
  const LeaveBalanceTab({super.key});

  @override
  State<LeaveBalanceTab> createState() => _LeaveBalanceTabState();
}

class _LeaveBalanceTabState extends State<LeaveBalanceTab> {
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

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveBalanceTabHeader(localizations: localizations, isDark: isDark),
          Gap(21.h),
          EmployeeInfoCard(localizations: localizations, isDark: isDark, employeeData: _employeeData),
          Gap(21.h),
          LeaveBalanceCardsSection(localizations: localizations, isDark: isDark),
        ],
      ),
    );
  }
}
