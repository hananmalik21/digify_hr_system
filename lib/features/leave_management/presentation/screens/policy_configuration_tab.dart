import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_type.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_configuration_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/approval_workflows_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/blackout_periods_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/carry_forward_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/compliance_check_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_criteria_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/encashment_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/entitlement_accrual_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/forfeit_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/leave_types_list.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_stat_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyConfigurationTab extends ConsumerStatefulWidget {
  const PolicyConfigurationTab({super.key});

  @override
  ConsumerState<PolicyConfigurationTab> createState() => _PolicyConfigurationTabState();
}

class _PolicyConfigurationTabState extends ConsumerState<PolicyConfigurationTab> {
  LeaveType? _selectedLeaveType;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;
    final leaveTypesAsync = ref.watch(leaveTypesProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 21.h,
        children: [
          DigifyTabHeader(
            title: 'Leave Policy Configuration',
            description: 'Configure comprehensive leave policies with eligibility criteria and advanced rules.',
          ),
          PolicyConfigurationStatCards(isDark: isDark),
          leaveTypesAsync.when(
            data: (leaveTypes) {
              if (_selectedLeaveType == null && leaveTypes.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final selected = leaveTypes.firstWhere((lt) => lt.isSelected, orElse: () => leaveTypes.first);
                  setState(() => _selectedLeaveType = selected);
                });
              }
              if (isMobile) {
                return _buildMobileLayout(isDark, leaveTypes);
              } else {
                return _buildDesktopLayout(isDark, leaveTypes);
              }
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error loading leave types: ${error.toString()}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.errorTextDark : AppColors.errorText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(bool isDark, List<LeaveType> leaveTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: LeaveTypesList(
            leaveTypes: leaveTypes,
            isDark: isDark,
            selectedLeaveType: _selectedLeaveType,
            onLeaveTypeSelected: (leaveType) {
              setState(() {
                _selectedLeaveType = leaveType;
              });
            },
          ),
        ),
        _buildPolicyDetailsContent(isDark),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isDark, List<LeaveType> leaveTypes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350.w, maxHeight: 800.h),
          child: LeaveTypesList(
            leaveTypes: leaveTypes,
            isDark: isDark,
            selectedLeaveType: _selectedLeaveType,
            onLeaveTypeSelected: (leaveType) {
              setState(() {
                _selectedLeaveType = leaveType;
              });
            },
          ),
        ),
        Gap(21.w),
        Expanded(child: _buildPolicyDetailsContent(isDark)),
      ],
    );
  }

  Widget _buildPolicyDetailsContent(bool isDark) {
    if (_selectedLeaveType == null) {
      return const Gap(0);
    }

    final configAsync = ref.watch(policyConfigurationProvider(_selectedLeaveType!.name));

    return configAsync.when(
      data: (config) {
        if (config == null) {
          return Center(
            child: Text(
              'Policy configuration not found',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PolicyDetailsHeader(
              policyName: config.policyName,
              policyNameArabic: config.policyNameArabic,
              version: config.version,
              lastModified: config.lastModified,
              selectedBy: config.selectedBy,
              isDark: isDark,
              onHistoryPressed: () {},
              onEditPressed: () {},
            ),
            EligibilityCriteriaSection(isDark: isDark, eligibility: config.eligibilityCriteria),
            EntitlementAccrualSection(isDark: isDark, entitlement: config.entitlementAccrual),
            AdvancedRulesSection(isDark: isDark, advanced: config.advancedRules),
            ApprovalWorkflowsSection(isDark: isDark, approval: config.approvalWorkflows),
            BlackoutPeriodsSection(isDark: isDark, blackout: config.blackoutPeriods),
            CarryForwardRulesSection(isDark: isDark, carryForward: config.carryForwardRules),
            ForfeitRulesSection(isDark: isDark, forfeit: config.forfeitRules),
            EncashmentRulesSection(isDark: isDark, encashment: config.encashmentRules),
            ComplianceCheckSection(isDark: isDark, compliance: config.complianceCheck),
          ],
        );
      },
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error loading policy configuration: ${error.toString()}',
          style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.errorTextDark : AppColors.errorText),
        ),
      ),
    );
  }
}
