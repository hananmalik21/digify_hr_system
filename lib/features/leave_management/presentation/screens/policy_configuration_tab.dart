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

class PolicyConfigurationTab extends ConsumerStatefulWidget {
  const PolicyConfigurationTab({super.key});

  @override
  ConsumerState<PolicyConfigurationTab> createState() => _PolicyConfigurationTabState();
}

class _PolicyConfigurationTabState extends ConsumerState<PolicyConfigurationTab> {
  PolicyListItem? _selectedPolicy;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;
    final policiesAsync = ref.watch(absPoliciesProvider);
    final notifierState = ref.watch(absPoliciesNotifierProvider);
    final pagination = ref.watch(absPoliciesPaginationProvider);
    final selectedEnterpriseId = ref.watch(leaveManagementSelectedEnterpriseProvider);

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
            selectedEnterpriseId: selectedEnterpriseId,
            onEnterpriseChanged: (id) =>
                ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
            subtitle: selectedEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          PolicyConfigurationStatCards(isDark: isDark),
          policiesAsync.when(
            data: (paginated) {
              _syncSelection(paginated.policies);
              return isMobile
                  ? _buildMobileLayout(isDark, paginated.policies, pagination, notifierState)
                  : _buildDesktopLayout(isDark, paginated.policies, pagination, notifierState);
            },
            loading: () => PolicyConfigurationSkeleton(isDark: isDark, isMobile: isMobile),
            error: (e, _) => _buildError(context, isDark, e.toString()),
          ),
        ],
      ),
    );
  }

  void _syncSelection(List<PolicyListItem> policies) {
    final needSelection = _selectedPolicy == null && policies.isNotEmpty;
    final selectionMissing =
        _selectedPolicy != null &&
        policies.isNotEmpty &&
        !policies.any((p) => p.policyGuid == _selectedPolicy!.policyGuid);
    if (needSelection || selectionMissing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedPolicy = policies.isNotEmpty ? policies.first : null);
        }
      });
    }
  }

  void _goToPage(int page) {
    final pagination = ref.read(absPoliciesPaginationProvider);
    ref.read(absPoliciesPaginationProvider.notifier).state = (page: page, pageSize: pagination.pageSize);
  }

  Widget _buildListWithPagination({
    required bool isDark,
    required List<PolicyListItem> policies,
    required ({int page, int pageSize}) pagination,
    required AbsPoliciesState notifierState,
    required BoxConstraints listConstraints,
    double? width,
  }) {
    final meta = notifierState.data;
    final paginationInfo = meta != null && meta.policies.isNotEmpty ? meta.pagination : null;

    return PolicyListWithPagination(
      policies: policies,
      selectedPolicy: _selectedPolicy,
      onPolicySelected: (p) => setState(() => _selectedPolicy = p),
      isDark: isDark,
      listConstraints: listConstraints,
      paginationInfo: paginationInfo,
      currentPage: pagination.page,
      pageSize: pagination.pageSize,
      onPrevious: () => _goToPage(pagination.page - 1),
      onNext: () => _goToPage(pagination.page + 1),
      isLoading: notifierState.isLoading,
      width: width,
    );
  }

  Widget _buildMobileLayout(
    bool isDark,
    List<PolicyListItem> policies,
    ({int page, int pageSize}) pagination,
    AbsPoliciesState notifierState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        _buildListWithPagination(
          isDark: isDark,
          policies: policies,
          pagination: pagination,
          notifierState: notifierState,
          listConstraints: BoxConstraints(maxHeight: 300.h),
        ),
        PolicyDetailsContent(selectedPolicy: _selectedPolicy, isDark: isDark),
      ],
    );
  }

  Widget _buildDesktopLayout(
    bool isDark,
    List<PolicyListItem> policies,
    ({int page, int pageSize}) pagination,
    AbsPoliciesState notifierState,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListWithPagination(
          isDark: isDark,
          policies: policies,
          pagination: pagination,
          notifierState: notifierState,
          listConstraints: BoxConstraints(maxHeight: 800.h),
          width: 350.w,
        ),
        Gap(21.w),
        Expanded(
          child: PolicyDetailsContent(selectedPolicy: _selectedPolicy, isDark: isDark),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, bool isDark, String message) {
    return Center(
      child: Text(
        'Error loading leave policies: $message',
        style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.errorTextDark : AppColors.errorText),
      ),
    );
  }
}
