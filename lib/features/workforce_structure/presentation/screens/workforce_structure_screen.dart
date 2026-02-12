import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_stats_cards.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_bar.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_families_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/positions_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/reporting_structure_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkforceStructureScreen extends ConsumerStatefulWidget {
  const WorkforceStructureScreen({super.key});

  @override
  ConsumerState<WorkforceStructureScreen> createState() => _WorkforceStructureScreenState();
}

class _WorkforceStructureScreenState extends ConsumerState<WorkforceStructureScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(workforceTabStateProvider.select((s) => s.currentTabIndex));
    final tabs = WorkforceTab.values;
    final currentTab = (currentTabIndex >= 0 && currentTabIndex < tabs.length)
        ? tabs[currentTabIndex]
        : WorkforceTab.positions;
    final headerTitle = currentTab.label(localizations);
    final headerDescription = localizations.managePositions;
    final isPositionsTab = currentTab == WorkforceTab.positions;
    final Widget? headerTrailing = isPositionsTab
        ? AppButton.primary(
            label: localizations.addPosition,
            svgPath: Assets.icons.addDivisionIcon.path,
            onPressed: () {
              PositionFormDialog.show(context, position: Position.empty(), isEdit: false);
            },
          )
        : null;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DigifyTabHeader(title: headerTitle, description: headerDescription, trailing: headerTrailing),
                  Gap(24.h),
                  WorkforceStatsCards(localizations: localizations, isDark: isDark),
                  Gap(24.h),
                  WorkforceTabBar(
                    localizations: localizations,
                    selectedTabIndex: currentTabIndex,
                    onTabSelected: (index) {
                      ref.read(workforceTabStateProvider.notifier).setTabIndex(index);
                    },
                    isDark: isDark,
                  ),
                  Gap(16.h),
                ],
              ),
            ),
            Expanded(child: _buildTabContent(currentTabIndex)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const PositionsTab();
      case 1:
        return JobFamiliesTab(scrollController: _scrollController);
      case 2:
        return JobLevelsTab(scrollController: _scrollController);
      case 3:
        return GradeStructureTab(scrollController: _scrollController);
      case 4:
        return const ReportingStructureTab();
      case 5:
        return const Center(child: Text('Position Tree Placeholder'));
      default:
        return const PositionsTab();
    }
  }
}
