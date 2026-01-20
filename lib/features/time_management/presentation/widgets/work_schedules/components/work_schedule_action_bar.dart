import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleActionBar extends StatelessWidget {
  final VoidCallback onCreateSchedule;
  final VoidCallback onUpload;
  final VoidCallback onExport;

  const WorkScheduleActionBar({
    super.key,
    required this.onCreateSchedule,
    required this.onUpload,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localizations.workSchedules, style: context.textTheme.titleMedium),
        Row(
          children: [
            AppButton(
              label: localizations.createWorkSchedule,
              onPressed: onCreateSchedule,
              svgPath: Assets.icons.addDivisionIcon.path,
            ),
            Gap(12.w),
            AppButton(
              label: localizations.import,
              onPressed: onUpload,
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
