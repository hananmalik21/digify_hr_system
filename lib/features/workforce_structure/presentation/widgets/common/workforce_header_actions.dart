import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/create_grade_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WorkforceHeaderActions {
  static Widget? getTrailingAction(BuildContext context, WorkforceTab currentTab) {
    final localizations = AppLocalizations.of(context)!;

    switch (currentTab) {
      case WorkforceTab.positions:
        return AppButton.primary(
          label: localizations.addPosition,
          svgPath: Assets.icons.addDivisionIcon.path,
          onPressed: () {
            PositionFormDialog.show(context, position: Position.empty(), isEdit: false);
          },
        );
      case WorkforceTab.jobFamilies:
        return AppButton.primary(
          label: localizations.addJobFamily,
          svgPath: Assets.icons.addNewIconFigma.path,
          onPressed: () => JobFamilyFormDialog.show(context),
        );
      case WorkforceTab.jobLevels:
        return AppButton.primary(
          label: localizations.addJobLevel,
          svgPath: Assets.icons.addNewIconFigma.path,
          onPressed: () => JobLevelFormDialog.show(context, onSave: (level) {}),
        );
      case WorkforceTab.gradeStructure:
        return AppButton.primary(
          label: localizations.addGrade,
          svgPath: Assets.icons.addNewIconFigma.path,
          onPressed: () => CreateGradeDialog.show(context),
        );
      default:
        return null;
    }
  }
}
