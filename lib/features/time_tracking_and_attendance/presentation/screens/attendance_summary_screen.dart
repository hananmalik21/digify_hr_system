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
import '../providers/attendance_summary/attendance_summary_enterprise_provider.dart';
import '../providers/overtime_configuration/overtime_configuration_enterprise_provider.dart';
import '../widgets/attendance_summary/component_attendance_summary_filters.dart';
import '../widgets/attendance_summary/component_attendance_summary_table.dart';

class AttendanceSummaryScreen extends ConsumerWidget {
  const AttendanceSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(
      overtimeConfigurationEnterpriseIdProvider,
    );

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
              title: 'Time & Labor Management - HR View',
              description:
                  'Comprehensive attendance, shifts, overtime and labor cost management',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton.primary(
                    label: "Log Attendance",
                    svgPath: Assets.icons.addNewIconFigma.path,
                    onPressed: () {},
                  ),
                  Gap(12.w),
                  AppButton(
                    label: localizations.exportReport,
                    onPressed: () {},
                    svgPath: Assets.icons.downloadIcon.path,
                    backgroundColor: AppColors.shiftExportButton,
                  ),
                ],
              ),
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref
                    .read(attendanceSummarySelectedEnterpriseProvider.notifier)
                    .setEnterpriseId(enterpriseId);
              },
              subtitle: effectiveEnterpriseId != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            Gap(24.h),
            ComponentAttendanceSummaryFilters(),
            Gap(24.h),
            ComponentAttendanceSummaryTable(),
          ],
        ),
      ),
    );
  }
}
