import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternHeader extends ConsumerWidget {
  final AppLocalizations localizations;

  const WorkPatternHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localizations.workPatterns, style: context.textTheme.titleMedium),
        Row(
          children: [
            AppButton(
              label: localizations.createWorkPattern,
              onPressed: () {
                final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
                if (enterpriseId != null) {
                  CreateWorkPatternDialog.show(context, enterpriseId);
                }
              },
              svgPath: Assets.icons.addDivisionIcon.path,
            ),
            Gap(12.w),
            AppButton(
              label: localizations.import,
              onPressed: () {},
              svgPath: Assets.icons.bulkUploadIconFigma.path,
              backgroundColor: AppColors.shiftUploadButton,
            ),
            Gap(12.w),
            AppButton(
              label: localizations.export,
              onPressed: () {},
              svgPath: Assets.icons.downloadIcon.path,
              backgroundColor: AppColors.shiftExportButton,
            ),
          ],
        ),
      ],
    );
  }
}
