import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/page_header_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_stats_cards.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_bar.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_families_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/positions_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/reporting_structure_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final stats = ref.watch(workforceStatsProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (currentTabIndex == 1) {
              await ref.read(jobFamilyNotifierProvider.notifier).refresh();
            } else if (currentTabIndex == 2) {
              await ref.read(jobLevelNotifierProvider.notifier).refresh();
            }
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(top: 88.h, start: 32.w, end: 32.w, bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeaderWidget(
                  localizations: localizations,
                  title: localizations.workforceStructure,
                  icon: Assets.icons.workforceStructureMainIcon.path,
                ),
                SizedBox(height: 24.h),
                WorkforceStatsCards(localizations: localizations, stats: stats, isDark: isDark),
                SizedBox(height: 24.h),
                WorkforceTabBar(
                  localizations: localizations,
                  selectedTabIndex: currentTabIndex,
                  onTabSelected: (index) {
                    ref.read(workforceTabStateProvider.notifier).setTabIndex(index);
                  },
                  isDark: isDark,
                ),
                SizedBox(height: 24.h),
                _buildTabContent(currentTabIndex),
              ],
            ),
          ),
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
