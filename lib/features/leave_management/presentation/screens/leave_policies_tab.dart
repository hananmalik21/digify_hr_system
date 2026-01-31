import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/leave_policies_filters_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/leave_policies_stat_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/leave_policy_cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeavePoliciesTab extends ConsumerWidget {
  const LeavePoliciesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 21.h,
        children: [
          DigifyTabHeader(
            title: localizations.leavePolicies,
            description: 'Configure leave policies per Kuwait Labor Law No. 6/2010',
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
          LeavePoliciesStatCards(isDark: isDark),
          LeavePoliciesFiltersSection(localizations: localizations, isDark: isDark),
          LeavePolicyCardsGrid(localizations: localizations, isDark: isDark),
        ],
      ),
    );
  }
}
