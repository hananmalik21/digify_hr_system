import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/all_leave_balances_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/leave_balance_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/leave_calendar_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/leave_policies_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/leave_request_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/policy_configuration_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/forfeit_policy_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/forfeit_processing_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/forfeit_reports_tab.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/team_leave_risk_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _LeaveManagementTabIndex {
  static const int leaveRequests = 0;
  static const int leaveBalance = 1;
  static const int myLeaveBalance = 2;
  static const int teamLeaveRisk = 3;
  static const int leavePolicies = 4;
  static const int policyConfiguration = 5;
  static const int forfeitPolicy = 6;
  static const int forfeitProcessing = 7;
  static const int forfeitReports = 8;
  static const int leaveCalendar = 9;
}

class LeaveManagementScreen extends ConsumerWidget {
  const LeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTabIndex = ref.watch(leaveManagementTabStateProvider.select((s) => s.currentTabIndex));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: _buildTabContent(selectedTabIndex),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case _LeaveManagementTabIndex.leaveRequests:
        return const LeaveRequestTab();
      case _LeaveManagementTabIndex.leaveBalance:
        return const AllLeaveBalancesTab();
      case _LeaveManagementTabIndex.myLeaveBalance:
        return const LeaveBalanceTab();
      case _LeaveManagementTabIndex.teamLeaveRisk:
        return const TeamLeaveRiskTab();
      case _LeaveManagementTabIndex.leavePolicies:
        return const LeavePoliciesTab();
      case _LeaveManagementTabIndex.policyConfiguration:
        return const PolicyConfigurationTab();
      case _LeaveManagementTabIndex.forfeitPolicy:
        return const ForfeitPolicyTab();
      case _LeaveManagementTabIndex.forfeitProcessing:
        return const ForfeitProcessingTab();
      case _LeaveManagementTabIndex.forfeitReports:
        return const ForfeitReportsTab();
      case _LeaveManagementTabIndex.leaveCalendar:
        return const LeaveCalendarTab();
      default:
        return const LeaveRequestTab();
    }
  }
}
