import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/team_leave_risk_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/manager_action_recommendations_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_filters_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_stat_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamLeaveRiskTab extends ConsumerWidget {
  const TeamLeaveRiskTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(teamLeaveRiskProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 21.h,
        children: [
          DigifyTabHeader(
            title: localizations.teamLeaveRiskDashboard,
            description: localizations.monitorAndManageTeamMembersAtRisk,
          ),
          TeamLeaveRiskStatCards(stats: state.stats, isDark: isDark),
          TeamLeaveRiskFiltersSection(localizations: localizations, isDark: isDark),
          TeamLeaveRiskTable(
            employees: state.employees,
            localizations: localizations,
            isDark: isDark,
            onApprove: (value) {},
            onView: (value) {},
          ),
        ],
      ),
    );
  }
}
