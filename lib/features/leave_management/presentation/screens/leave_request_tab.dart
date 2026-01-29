import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/kuwait_law_entitlements_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_entitlements_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_filter_tabs.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveRequestTab extends ConsumerWidget {
  const LeaveRequestTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final effectiveEnterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveEntitlementsSection(localizations: localizations),
          Gap(24.h),
          KuwaitLawEntitlementsSection(localizations: localizations),
          Gap(24.h),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(leaveManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
            subtitle: effectiveEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          Gap(24.h),
          LeaveFilterTabs(),
          Gap(16.h),
          LeaveRequestsTable(),
        ],
      ),
    );
  }
}
