import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/enums/workforce_enums.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_stats_cards.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_families_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/positions_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/reporting_structure_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceStructureScreen extends ConsumerStatefulWidget {
  final String? initialTab;

  const WorkforceStructureScreen({super.key, this.initialTab});

  @override
  ConsumerState<WorkforceStructureScreen> createState() =>
      _WorkforceStructureScreenState();
}

class _WorkforceStructureScreenState
    extends ConsumerState<WorkforceStructureScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(workforceTabStateProvider.notifier)
            .setTabFromRoute(widget.initialTab);
      });
    }

    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedTab = ref.watch(
      workforceTabStateProvider.select((s) => s.currentTab),
    );
    final stats = ref.watch(workforceStatsProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedTab == WorkforceTab.jobFamilies) {
              await ref.read(jobFamilyNotifierProvider.notifier).refresh();
            }
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              top: 88.h,
              start: 32.w,
              end: 32.w,
              bottom: 24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkforceHeader(localizations: localizations),
                SizedBox(height: 24.h),
                WorkforceStatsCards(
                  localizations: localizations,
                  stats: stats,
                  isDark: isDark,
                ),
                SizedBox(height: 24.h),
                _buildTabContent(selectedTab),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(WorkforceTab selectedTab) {
    switch (selectedTab) {
      case WorkforceTab.positions:
        return const PositionsTab();
      case WorkforceTab.jobFamilies:
        return JobFamiliesTab(scrollController: _scrollController);
      case WorkforceTab.jobLevels:
        return const JobLevelsTab();
      case WorkforceTab.gradeStructure:
        return const GradeStructureTab();
      case WorkforceTab.reportingStructure:
        return const ReportingStructureTab();
      case WorkforceTab.positionTree:
        return const Center(child: Text('Position Tree Placeholder'));
    }
  }
}
