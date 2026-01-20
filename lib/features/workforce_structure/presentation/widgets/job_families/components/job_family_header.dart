import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class JobFamilyHeader extends StatelessWidget {
  final AppLocalizations localizations;

  const JobFamilyHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localizations.jobFamilies, style: context.textTheme.titleMedium),
        AppButton.primary(
          svgPath: Assets.icons.addNewIconFigma.path,
          label: localizations.addJobFamily,
          onPressed: () => JobFamilyFormDialog.show(context),
        ),
      ],
    );
  }
}
