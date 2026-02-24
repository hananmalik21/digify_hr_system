import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/overtime/table/component_overtime_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../workforce_structure/presentation/providers/workforce_enterprise_provider.dart';
import '../widgets/overtime/component_overtime_filter_bar.dart';
import '../widgets/overtime/search/component_overtime_search_and_actions.dart';
import '../widgets/overtime/component_overtime_stats.dart';

class OvertimeScreen extends ConsumerStatefulWidget {
  const OvertimeScreen({super.key});

  @override
  ConsumerState<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends ConsumerState<OvertimeScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

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
              title: localizations.overtimeManagment,
              description: localizations.overtimeManagmentDescription,
              trailing: AppButton.primary(
                label: localizations.requestOvertime,
                svgPath: Assets.icons.addNewIconFigma.path,
                onPressed: () {},
              ),
            ),
            Gap(24.h),
            const ComponentOvertimeFilterBar(),
            Gap(24.h),
            const ComponentOvertimeStats(),
            Gap(24.h),
            Consumer(
              builder: (context, ref, child) {
                final selectedEnterpriseId = ref.watch(
                  workforceEnterpriseIdProvider,
                );
                return EnterpriseSelectorWidget(
                  selectedEnterpriseId: selectedEnterpriseId,
                  onEnterpriseChanged: (id) {
                    ref
                        .read(workforceSelectedEnterpriseProvider.notifier)
                        .setEnterpriseId(id);
                  },
                  subtitle: selectedEnterpriseId != null
                      ? 'Viewing data for selected enterprise'
                      : 'Select an enterprise to view data',
                );
              },
            ),
            Gap(24.h),
            OvertimeSearchAndActions(
              localizations: localizations,
              isDark: isDark,
            ),
            Gap(24.h),
            OvertimeTable(
              localizations: localizations,
              records: [],
              isDark: isDark,
              onView: (_) {},
              onEdit: (_) {},
              onDelete: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
