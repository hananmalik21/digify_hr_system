import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/utils/workforce_tab_manager.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_stats_cards.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_bar.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_families_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_details_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_positions_table.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_search_and_actions.dart';
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
  String? selectedTab;

  @override
  void didUpdateWidget(WorkforceStructureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab &&
        widget.initialTab != null) {
      _updateSelectedTab();
    }
  }

  void _updateSelectedTab() {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      selectedTab = WorkforceTabManager.getTabFromRoute(
        widget.initialTab,
        localizations,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    // Initialize selectedTab if it's null
    selectedTab ??= WorkforceTabManager.getTabFromRoute(
      widget.initialTab,
      localizations,
    );

    final stats = ref.watch(workforceStatsProvider);
    final filteredPositions = ref.watch(filteredPositionsProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
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
              WorkforceTabBar(
                localizations: localizations,
                selectedTab: selectedTab!,
                onTabSelected: (tab) => setState(() => selectedTab = tab),
                isDark: isDark,
              ),
              SizedBox(height: 24.h),
              _buildTabContent(localizations, filteredPositions, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    AppLocalizations localizations,
    List<Position> filteredPositions,
    bool isDark,
  ) {
    if (selectedTab == localizations.positions) {
      return Column(
        children: [
          WorkforceSearchAndActions(
            localizations: localizations,
            isDark: isDark,
            onAddPosition: () =>
                _showPositionFormDialog(context, Position.empty(), false),
          ),
          SizedBox(height: 24.h),
          WorkforcePositionsTable(
            localizations: localizations,
            positions: filteredPositions,
            isDark: isDark,
            onView: (position) => _showPositionDetailsDialog(context, position),
            onEdit: (position) =>
                _showPositionFormDialog(context, position, true),
            onDelete: (position) {},
          ),
        ],
      );
    } else if (selectedTab == localizations.jobFamilies) {
      return const JobFamiliesTab();
    } else if (selectedTab == localizations.jobLevels) {
      return const JobLevelsTab();
    } else if (selectedTab == localizations.gradeStructure) {
      return const GradeStructureTab();
    } else if (selectedTab == localizations.reportingStructure) {
      return const ReportingStructureTab();
    }
    return const SizedBox.shrink();
  }

  void _showPositionDetailsDialog(BuildContext context, Position position) {
    showDialog(
      context: context,
      builder: (context) => PositionDetailsDialog(position: position),
    );
  }

  void _showPositionFormDialog(
    BuildContext context,
    Position position,
    bool isEdit,
  ) {
    PositionFormDialog.show(context, position: position, isEdit: isEdit);
  }
}
