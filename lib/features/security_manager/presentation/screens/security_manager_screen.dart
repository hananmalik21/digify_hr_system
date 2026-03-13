import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/security_manager_tab_state_provider.dart';
import 'security_overview_screen.dart';
import 'user_management/user_management_screen.dart';

class _SecurityManagerTabIndex {
  static const int securityOverview = 0;
  static const int userManagement = 1;
}

class SecurityManagerScreen extends ConsumerWidget {
  const SecurityManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTabIndex = ref.watch(
      securityManagerTabStateProvider.select((s) => s.currentTabIndex),
    );

    return Container(
      color: isDark
          ? AppColors.backgroundDark
          : AppColors.tableHeaderBackground,
      child: _buildTabContent(selectedTabIndex),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case _SecurityManagerTabIndex.securityOverview:
        return const SecurityOverviewScreen();
      case _SecurityManagerTabIndex.userManagement:
        return const UserManagementScreen();
      default:
        return const SecurityOverviewScreen();
    }
  }
}
