import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/employee_management_tab_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/screens/employee_actions_screen.dart';
import 'package:digify_hr_system/features/employee_management/presentation/screens/employee_contracts_screen.dart';
import 'package:digify_hr_system/features/employee_management/presentation/screens/manage_employees_screen.dart';
import 'package:digify_hr_system/features/employee_management/presentation/screens/workforce_planning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _EmployeeManagementTabIndex {
  static const int manageEmployees = 0;
  static const int employeeActions = 1;
  static const int workforcePlanning = 2;
  static const int contracts = 3;
}

class EmployeeManagementScreen extends ConsumerWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTabIndex = ref.watch(employeeManagementTabStateProvider.select((s) => s.currentTabIndex));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: _buildTabContent(selectedTabIndex),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case _EmployeeManagementTabIndex.manageEmployees:
        return const ManageEmployeesScreen();
      case _EmployeeManagementTabIndex.employeeActions:
        return const EmployeeActionsScreen();
      case _EmployeeManagementTabIndex.workforcePlanning:
        return const WorkforcePlanningScreen();
      case _EmployeeManagementTabIndex.contracts:
        return const EmployeeContractsScreen();
      default:
        return const ManageEmployeesScreen();
    }
  }
}
