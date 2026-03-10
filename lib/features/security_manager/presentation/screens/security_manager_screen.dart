import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/security_manager/presentation/providers/security_manager_tab_state_provider.dart';
import 'package:digify_hr_system/features/security_manager/presentation/screens/security_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SecurityManagerTabIndex {
  static const int securityOverview = 0;
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
      default:
        return const SecurityOverviewScreen();
    }
  }
}
