import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_tab_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseStructureScreen extends ConsumerWidget {
  const EnterpriseStructureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(enterpriseStructureTabStateProvider.select((s) => s.currentTabIndex));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: _buildTabContent(context, currentTabIndex),
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const ManageEnterpriseStructureScreen();
      case 1:
        return const ManageComponentValuesScreen();
      default:
        return const ManageEnterpriseStructureScreen();
    }
  }
}
