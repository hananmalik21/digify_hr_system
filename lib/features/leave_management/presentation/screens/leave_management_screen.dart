import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/my_leave_balance_view.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/team_leave_risk_screen.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_entitlements_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_filter_tabs.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_management_tab_bar.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveManagementScreen extends ConsumerStatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  ConsumerState<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends ConsumerState<LeaveManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedTabIndex = ref.watch(leaveManagementTabStateProvider.select((s) => s.currentTabIndex));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(top: 15.h, start: 32.w, end: 32.w, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(localizations),
                Gap(24.h),
                LeaveManagementTabBar(
                  localizations: localizations,
                  selectedTabIndex: selectedTabIndex,
                  onTabSelected: (index) {
                    ref.read(leaveManagementTabStateProvider.notifier).setTabIndex(index);
                  },
                  isDark: isDark,
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildTabContent(selectedTabIndex, localizations, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, AppLocalizations localizations, bool isDark) {
    switch (tabIndex) {
      case 0: // Leave Requests
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.only(start: 32.w, end: 32.w, bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeaveEntitlementsSection(localizations: localizations),
              Gap(24.h),
              LeaveFilterTabs(),
              Gap(16.h),
              LeaveRequestsTable(),
            ],
          ),
        );
      case 1: // Leave Balance
        return const MyLeaveBalanceView();
      case 2: // Team Leave Risk
        return const TeamLeaveRiskScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.leaveManagement,
                style: TextStyle(
                  fontSize: 18.6.sp,
                  fontWeight: FontWeight.w500,
                  color: context.themeTextPrimary,
                  height: 30 / 18.6,
                ),
              ),
              Gap(4.h),
              Text(
                localizations.manageEmployeeLeaveRequests,
                style: TextStyle(
                  fontSize: 15.1.sp,
                  fontWeight: FontWeight.w400,
                  color: context.themeTextSecondary,
                  height: 24 / 15.1,
                ),
              ),
            ],
          ),
        ),
        Gap(16.w),
        AppButton.primary(
          label: localizations.newLeaveRequest,
          icon: Icons.add,
          onPressed: () {
            NewLeaveRequestDialog.show(context);
          },
        ),
      ],
    );
  }
}
