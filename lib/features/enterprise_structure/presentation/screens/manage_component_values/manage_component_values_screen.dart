import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_level_tabs.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_stat_cards.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ManageComponentValuesScreen extends ConsumerWidget {
  const ManageComponentValuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyTabHeader(
                title: 'Manage Component Values',
                description: 'Manage component values for your enterprise structure.',
              ),
              Gap(24),
              ComponentValuesStatCards(),
              Gap(24),
              ComponentValuesLevelTabs(),
              Gap(24),
              ComponentValuesTabContent(),
            ],
          ),
        ),
      ),
    );
  }
}
