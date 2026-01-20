import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ScheduleAssignmentActionBar extends StatelessWidget {
  final VoidCallback onAssignSchedule;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;

  const ScheduleAssignmentActionBar({
    super.key,
    required this.onAssignSchedule,
    required this.onBulkUpload,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localizations.scheduleAssignments, style: context.textTheme.titleMedium),
        Row(
          children: [
            AppButton(
              label: localizations.tmAssignSchedule,
              onPressed: onAssignSchedule,
              svgPath: Assets.icons.addDivisionIcon.path,
            ),
            Gap(12.w),
            AppButton(
              label: localizations.import,
              onPressed: onBulkUpload,
              svgPath: Assets.icons.bulkUploadIconFigma.path,
              backgroundColor: AppColors.shiftUploadButton,
            ),
            Gap(12.w),
            AppButton(
              label: localizations.export,
              onPressed: onExport,
              svgPath: Assets.icons.downloadIcon.path,
              backgroundColor: AppColors.shiftExportButton,
            ),
          ],
        ),
      ],
    );
  }
}
