import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/forfeit_policy.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/forfeit_policy_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policies_list.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policy_details_content.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policy_stat_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitPolicyTab extends ConsumerStatefulWidget {
  const ForfeitPolicyTab({super.key});

  @override
  ConsumerState<ForfeitPolicyTab> createState() => _ForfeitPolicyTabState();
}

class _ForfeitPolicyTabState extends ConsumerState<ForfeitPolicyTab> {
  ForfeitPolicy? _selectedForfeitPolicy;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;
    final effectiveEnterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);
    final forfeitPoliciesAsync = ref.watch(forfeitPoliciesProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 21.h,
        children: [
          DigifyTabHeader(
            title: 'Forfeit Policy',
            description: 'Manage and configure forfeit policies for leave management.',
          ),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
            subtitle: effectiveEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          ForfeitPolicyStatCards(isDark: isDark),
          forfeitPoliciesAsync.when(
            data: (forfeitPolicies) {
              if (_selectedForfeitPolicy == null && forfeitPolicies.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final selected = forfeitPolicies.firstWhere(
                    (fp) => fp.isSelected,
                    orElse: () => forfeitPolicies.first,
                  );
                  setState(() => _selectedForfeitPolicy = selected);
                });
              }
              if (forfeitPolicies.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.w),
                    child: Text(
                      'No forfeit policies found',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }
              if (isMobile) {
                return _buildMobileLayout(isDark, forfeitPolicies);
              } else {
                return _buildDesktopLayout(isDark, forfeitPolicies);
              }
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error loading forfeit policies: ${error.toString()}',
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

  Widget _buildMobileLayout(bool isDark, List<ForfeitPolicy> forfeitPolicies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ForfeitPoliciesList(
            forfeitPolicies: forfeitPolicies,
            isDark: isDark,
            selectedForfeitPolicy: _selectedForfeitPolicy,
            onForfeitPolicySelected: (forfeitPolicy) {
              setState(() {
                _selectedForfeitPolicy = forfeitPolicy;
              });
            },
          ),
        ),
        _buildForfeitPolicyDetailsContent(isDark),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isDark, List<ForfeitPolicy> forfeitPolicies) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350.w, maxHeight: 800.h),
          child: ForfeitPoliciesList(
            forfeitPolicies: forfeitPolicies,
            isDark: isDark,
            selectedForfeitPolicy: _selectedForfeitPolicy,
            onForfeitPolicySelected: (forfeitPolicy) {
              setState(() {
                _selectedForfeitPolicy = forfeitPolicy;
              });
            },
          ),
        ),
        Gap(21.w),
        Expanded(child: _buildForfeitPolicyDetailsContent(isDark)),
      ],
    );
  }

  Widget _buildForfeitPolicyDetailsContent(bool isDark) {
    return ForfeitPolicyDetailsContent(selectedForfeitPolicy: _selectedForfeitPolicy, isDark: isDark);
  }
}
