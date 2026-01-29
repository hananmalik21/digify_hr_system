import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_list_item.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_skeleton.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_stat_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_details_content.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/policy_list_with_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyConfigurationTab extends ConsumerWidget {
  const PolicyConfigurationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;
    final policiesAsync = ref.watch(absPoliciesProvider);
    final notifierState = ref.watch(absPoliciesNotifierProvider);
    final pagination = ref.watch(absPoliciesPaginationProvider);
    final effectiveEnterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);
    final selectedPolicy = ref.watch(selectedPolicyConfigurationProvider);
    final setSelectedGuid = ref.read(selectedPolicyGuidProvider.notifier).setSelectedPolicyGuid;

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
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (id) =>
                ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
            subtitle: effectiveEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          PolicyConfigurationStatCards(isDark: isDark),
          policiesAsync.when(
            data: (paginated) {
              return isMobile
                  ? _buildMobileLayout(
                      ref,
                      context,
                      isDark,
                      paginated.policies,
                      pagination,
                      notifierState,
                      selectedPolicy,
                      setSelectedGuid,
                    )
                  : _buildDesktopLayout(
                      ref,
                      context,
                      isDark,
                      paginated.policies,
                      pagination,
                      notifierState,
                      selectedPolicy,
                      setSelectedGuid,
                    );
            },
            loading: () => PolicyConfigurationSkeleton(isDark: isDark, isMobile: isMobile),
            error: (e, _) => _buildError(context, isDark, e.toString()),
          ),
        ],
      ),
    );
  }

  static void _goToPage(WidgetRef ref, int page) {
    final pagination = ref.read(absPoliciesPaginationProvider);
    ref.read(absPoliciesPaginationProvider.notifier).state = (page: page, pageSize: pagination.pageSize);
  }

  static Widget _buildListWithPagination({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
    required List<PolicyListItem> policies,
    required ({int page, int pageSize}) pagination,
    required AbsPoliciesState notifierState,
    required BoxConstraints listConstraints,
    required PolicyListItem? selectedPolicy,
    required void Function(String?) onPolicySelected,
    double? width,
  }) {
    final meta = notifierState.data;
    final paginationInfo = meta != null && meta.policies.isNotEmpty ? meta.pagination : null;

    return PolicyListWithPagination(
      policies: policies,
      selectedPolicy: selectedPolicy,
      onPolicySelected: (p) => onPolicySelected(p.policyGuid),
      isDark: isDark,
      listConstraints: listConstraints,
      paginationInfo: paginationInfo,
      currentPage: pagination.page,
      pageSize: pagination.pageSize,
      onPrevious: () => _goToPage(ref, pagination.page - 1),
      onNext: () => _goToPage(ref, pagination.page + 1),
      isLoading: notifierState.isLoading,
      width: width,
    );
  }

  static Widget _buildMobileLayout(
    WidgetRef ref,
    BuildContext context,
    bool isDark,
    List<PolicyListItem> policies,
    ({int page, int pageSize}) pagination,
    AbsPoliciesState notifierState,
    PolicyListItem? selectedPolicy,
    void Function(String?) setSelectedGuid,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        _buildListWithPagination(
          context: context,
          ref: ref,
          isDark: isDark,
          policies: policies,
          pagination: pagination,
          notifierState: notifierState,
          listConstraints: BoxConstraints(maxHeight: 300.h),
          selectedPolicy: selectedPolicy,
          onPolicySelected: setSelectedGuid,
        ),
        PolicyDetailsContent(selectedPolicy: selectedPolicy, isDark: isDark),
      ],
    );
  }

  static Widget _buildDesktopLayout(
    WidgetRef ref,
    BuildContext context,
    bool isDark,
    List<PolicyListItem> policies,
    ({int page, int pageSize}) pagination,
    AbsPoliciesState notifierState,
    PolicyListItem? selectedPolicy,
    void Function(String?) setSelectedGuid,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListWithPagination(
          context: context,
          ref: ref,
          isDark: isDark,
          policies: policies,
          pagination: pagination,
          notifierState: notifierState,
          listConstraints: BoxConstraints(maxHeight: 800.h),
          selectedPolicy: selectedPolicy,
          onPolicySelected: setSelectedGuid,
          width: 350.w,
        ),
        Gap(21.w),
        Expanded(
          child: PolicyDetailsContent(selectedPolicy: selectedPolicy, isDark: isDark),
        ),
      ],
    );
  }

  static Widget _buildError(BuildContext context, bool isDark, String message) {
    return Center(
      child: Text(
        'Error loading leave policies: $message',
        style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.errorTextDark : AppColors.errorText),
      ),
    );
  }
}
