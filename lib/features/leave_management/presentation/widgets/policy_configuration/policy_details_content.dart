import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_list_item.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_edit_mode_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/carry_forward_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_criteria_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/encashment_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/forfeit_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/grade_based_entitlements_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

/// Policy configuration detail panel: header + eligibility, entitlement, rules, etc.
class PolicyDetailsContent extends ConsumerWidget {
  final PolicyListItem? selectedPolicy;
  final bool isDark;

  const PolicyDetailsContent({super.key, required this.selectedPolicy, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(policyEditModeProvider);
    final editNotifier = ref.read(policyEditModeProvider.notifier);

    if (selectedPolicy == null) {
      return const Gap(0);
    }

    final detail = selectedPolicy!.detail;
    if (detail == null) {
      return _buildMessage(context, 'Policy details not available');
    }

    final config = detail.toConfiguration();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PolicyDetailsHeader(
          policyName: config.policyName,
          policyNameArabic: config.policyNameArabic,
          lastModified: config.lastModified,
          selectedBy: config.selectedBy,
          isDark: isDark,
          isEditing: isEditing,
          onEditPressed: editNotifier.startEditing,
          onCancelPressed: editNotifier.cancelEditing,
          onSavePressed: editNotifier.saveChanges,
        ),
        EligibilityCriteriaSection(isDark: isDark, eligibility: config.eligibilityCriteria),
        GradeBasedEntitlementsSection(
          isDark: isDark,
          gradeRows: detail.gradeRows,
          effectiveDate: detail.formattedCreatedDate,
          enableProRata: config.entitlementAccrual.enableProRataCalculation,
          accrualMethod: detail.accrualMethod.displayName,
          isEditing: isEditing,
        ),
        AdvancedRulesSection(isDark: isDark, advanced: config.advancedRules),
        CarryForwardRulesSection(isDark: isDark, carryForward: config.carryForwardRules),
        ForfeitRulesSection(
          isDark: isDark,
          forfeit: config.forfeitRules,
          carryForwardLimit: config.carryForwardRules.carryForwardLimit,
          gracePeriod: config.carryForwardRules.gracePeriod,
        ),
        EncashmentRulesSection(isDark: isDark, encashment: config.encashmentRules),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: context.textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}
