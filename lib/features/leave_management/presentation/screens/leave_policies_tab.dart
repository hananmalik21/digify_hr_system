import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/add_leave_policy_dialog.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/leave_policies_filters_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/leave_policies_stat_cards.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_policies/leave_policy_cards_grid.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeavePoliciesTab extends StatelessWidget {
  const LeavePoliciesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

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
            trailing: AppButton.primary(
              label: 'Add Policy',
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: () => AddLeavePolicyDialog.show(context),
            ),
          ),
          LeavePoliciesStatCards(isDark: isDark),
          LeavePoliciesFiltersSection(localizations: localizations, isDark: isDark),
          LeavePolicyCardsGrid(localizations: localizations, isDark: isDark),
        ],
      ),
    );
  }
}
