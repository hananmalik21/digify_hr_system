import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/team_leave_risk_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/manager_action_recommendations_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_filters_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_stat_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TeamLeaveRiskTab extends ConsumerWidget {
  const TeamLeaveRiskTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(teamLeaveRiskProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(top: 45.5.h, start: 21.w, end: 21.w, bottom: 30.h),
        child: SizedBox(
          width: 1470.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(localizations, isDark),
              Gap(21.h),
              TeamLeaveRiskStatCards(stats: state.stats, isDark: isDark),
              Gap(21.h),
              TeamLeaveRiskFiltersSection(localizations: localizations, isDark: isDark),
              Gap(21.h),
              TeamLeaveRiskTable(employees: state.employees, localizations: localizations, isDark: isDark),
              Gap(21.h),
              ManagerActionRecommendationsSection(localizations: localizations, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.teamLeaveRiskDashboard,
          style: TextStyle(
            fontSize: 24.9.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 31.5 / 24.9,
            letterSpacing: 0,
          ),
        ),
        Gap(3.5.h),
        Text(
          localizations.monitorAndManageTeamMembersAtRisk,
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 21 / 13.6,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
