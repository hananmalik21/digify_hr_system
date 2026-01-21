import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/approval_workflow_card.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/blackout_periods_card.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/days_and_notice_period_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/supporting_documentation_card.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/weekend_holiday_checkboxes_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvancedRulesSection extends StatelessWidget {
  final bool isDark;
  final AdvancedRules advanced;
  final ApprovalWorkflows approval;
  final BlackoutPeriods blackout;

  const AdvancedRulesSection({
    super.key,
    required this.isDark,
    required this.advanced,
    required this.approval,
    required this.blackout,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Advanced Rules',
      iconPath: Assets.icons.leaveManagement.filter.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.h,
        children: [
          DaysAndNoticePeriodSubsection(advanced: advanced, isDark: isDark),
          WeekendHolidayCheckboxesSubsection(advanced: advanced),
          SupportingDocumentationCard(advanced: advanced, isDark: isDark),
          ApprovalWorkflowCard(approval: approval, isDark: isDark),
          BlackoutPeriodsCard(blackout: blackout, isDark: isDark),
        ],
      ),
    );
  }
}
