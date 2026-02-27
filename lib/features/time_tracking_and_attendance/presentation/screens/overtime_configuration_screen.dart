import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../providers/overtime_configuration/overtime_configuration_enterprise_provider.dart';
import '../providers/overtime_configuration/overtime_configuration_provider.dart';
import '../widgets/overtime_configuration/component_approval_workflow.dart';
import '../widgets/overtime_configuration/component_compliance_score.dart';
import '../widgets/overtime_configuration/component_labor_law_limits.dart';
import '../widgets/overtime_configuration/component_rate_multipliers.dart';

class OvertimeConfigurationScreen extends ConsumerStatefulWidget {
  const OvertimeConfigurationScreen({super.key});

  @override
  ConsumerState<OvertimeConfigurationScreen> createState() =>
      _OvertimeConfigurationScreenState();
}

class _OvertimeConfigurationScreenState
    extends ConsumerState<OvertimeConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(
      overtimeConfigurationEnterpriseIdProvider,
    );
    final _formKey = ref.read(overtimeConfigurationProvider).formKey;

    return Container(
      color: isDark
          ? AppColors.backgroundDark
          : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: 'Overtime Configuration',
              description:
                  'Configure overtime rates, limits, and compliance rules according to Kuwait Labor Law',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton.outline(
                    label: 'Reset Defaults',
                    svgPath: Assets.icons.resetIcon.path,
                    onPressed: () {},
                  ),
                  Gap(12.w),
                  AppButton.primary(
                    label: localizations.saveConfiguration,
                    svgPath: Assets.icons.saveConfigIcon.path,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref
                    .read(
                      overtimeConfigurationSelectedEnterpriseProvider.notifier,
                    )
                    .setEnterpriseId(enterpriseId);
              },
              subtitle: effectiveEnterpriseId != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            Gap(24.h),
            Form(
              key: _formKey,
              child: StaggeredGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 24.h,
                crossAxisSpacing: 24.w,
                children: [
                  StaggeredGridTile.fit(
                    crossAxisCellCount: context.isMobile ? 3 : 2,
                    child: ComponentRateMultipliers(),
                  ),
                  StaggeredGridTile.fit(
                    crossAxisCellCount: context.isMobile ? 3 : 1,
                    child: ComponentLaborLawLimit(),
                  ),
                  StaggeredGridTile.fit(
                    crossAxisCellCount: context.isMobile ? 3 : 2,
                    child: ComponentApprovalWorkflow(),
                  ),
                  StaggeredGridTile.fit(
                    crossAxisCellCount: context.isMobile ? 3 : 1,
                    child: ComponentComplianceScore(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
