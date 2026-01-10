import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/enterprise_structure_fields.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/position_form_helpers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/job_family_selection_field.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/job_level_selection_field.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/grade_selection_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicInfoSection extends StatelessWidget {
  final AppLocalizations localizations;
  final TextEditingController codeController;
  final TextEditingController titleEnglishController;
  final TextEditingController titleArabicController;
  final bool isEdit;
  final bool isActive;
  final ValueChanged<bool?> onStatusChanged;

  const BasicInfoSection({
    super.key,
    required this.localizations,
    required this.codeController,
    required this.titleEnglishController,
    required this.titleArabicController,
    required this.isActive,
    required this.onStatusChanged,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.basicInformation,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: localizations.positionCode,
              isRequired: true,
              child: PositionFormHelpers.buildFormField(
                controller: codeController,
                hint: 'e.g, FIN-MGR-001',
                enabled: !isEdit,
              ),
            ),
            PositionLabeledField(
              label: localizations.status,
              isRequired: true,
              child: PositionFormHelpers.buildDropdownField<bool>(
                value: isActive,
                items: const [true, false],
                onChanged: onStatusChanged,
                itemLabelProvider: (val) => val == true ? localizations.active : localizations.inactive,
              ),
            ),
          ],
        ),
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: '${localizations.positionTitle} (English)',
              isRequired: true,
              child: PositionFormHelpers.buildFormField(
                controller: titleEnglishController,
                hint: 'e.g. Finance Manager',
              ),
            ),
            PositionLabeledField(
              label: '${localizations.positionTitle} (Arabic)',
              isRequired: true,
              child: PositionFormHelpers.buildFormField(
                controller: titleArabicController,
                hint: 'مثال: مدير مالي',
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrganizationalSection extends ConsumerWidget {
  final AppLocalizations localizations;
  final Map<String, String?> selectedUnitIds;
  final Map<String, OrgUnit>? initialSelections;
  final Function(String levelCode, String? unitId) onEnterpriseSelectionChanged;
  final TextEditingController costCenterController;
  final TextEditingController locationController;

  const OrganizationalSection({
    super.key,
    required this.localizations,
    required this.selectedUnitIds,
    required this.onEnterpriseSelectionChanged,
    required this.costCenterController,
    required this.locationController,
    this.initialSelections,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositionDialogSection(
      title: localizations.organizationalInformation,
      children: [
        EnterpriseStructureFields(
          localizations: localizations,
          selectedUnitIds: selectedUnitIds,
          onSelectionChanged: onEnterpriseSelectionChanged,
          initialSelections: initialSelections,
        ),
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: localizations.costCenter,
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: costCenterController, hint: 'e.g., CC-1000'),
            ),
            PositionLabeledField(
              label: localizations.location,
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: locationController, hint: 'e.g., Kuwait City HQ'),
            ),
          ],
        ),
      ],
    );
  }
}

class JobClassificationSection extends StatelessWidget {
  final AppLocalizations localizations;
  final String? selectedStep;
  final ValueChanged<String?> onStepChanged;

  const JobClassificationSection({
    super.key,
    required this.localizations,
    required this.selectedStep,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.jobClassification,
      children: [
        PositionFormRow(
          children: [
            JobFamilySelectionField(label: localizations.jobFamily),
            JobLevelSelectionField(label: localizations.jobLevel),
          ],
        ),
        PositionFormRow(
          children: [
            GradeSelectionField(label: localizations.gradeStep),
            PositionLabeledField(
              label: localizations.step,
              isRequired: true,
              child: PositionFormHelpers.buildDropdownField<String>(
                value: selectedStep,
                items: const ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5'],
                onChanged: onStepChanged,
                hint: 'Select Step',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HeadcountSection extends StatelessWidget {
  final AppLocalizations localizations;
  final TextEditingController positionsController;
  final TextEditingController filledController;
  final String? selectedEmploymentType;
  final ValueChanged<String?> onEmploymentTypeChanged;

  const HeadcountSection({
    super.key,
    required this.localizations,
    required this.positionsController,
    required this.filledController,
    required this.selectedEmploymentType,
    required this.onEmploymentTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.headcountInformation,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: "Number of Positions",
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: positionsController, hint: 'e.g, 5'),
            ),
            PositionLabeledField(
              label: "Filled Positions",
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: filledController, hint: 'e.g, 3'),
            ),
            PositionLabeledField(
              label: "Employment Type",
              isRequired: true,
              child: PositionFormHelpers.buildDropdownField<String>(
                value: selectedEmploymentType,
                items: const ['FULL_TIME', 'PART_TIME', 'CONTRACT', 'TEMP'],
                onChanged: onEmploymentTypeChanged,
                itemLabelProvider: (val) => val.replaceAll('_', ' '),
                hint: 'Select Type',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SalarySection extends StatelessWidget {
  final AppLocalizations localizations;
  final TextEditingController budgetedMinController;
  final TextEditingController budgetedMaxController;
  final TextEditingController actualAverageController;

  const SalarySection({
    super.key,
    required this.localizations,
    required this.budgetedMinController,
    required this.budgetedMaxController,
    required this.actualAverageController,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.salaryInformation,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: "${localizations.budgetedMin} (KD)",
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: budgetedMinController, hint: '1000'),
            ),
            PositionLabeledField(
              label: "${localizations.budgetedMax} (KD)",
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: budgetedMaxController, hint: '1500'),
            ),
            PositionLabeledField(
              label: "${localizations.actualAverage} (KD)",
              isRequired: true,
              child: PositionFormHelpers.buildFormField(controller: actualAverageController, hint: '1250'),
            ),
          ],
        ),
      ],
    );
  }
}

class ReportingSection extends StatelessWidget {
  final AppLocalizations localizations;
  final TextEditingController reportsTitleController;
  final TextEditingController reportsCodeController;

  const ReportingSection({
    super.key,
    required this.localizations,
    required this.reportsTitleController,
    required this.reportsCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.reportingRelationship,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: '${localizations.reportsTo} (Position Title)',
              isRequired: false,
              child: PositionFormHelpers.buildFormField(controller: reportsTitleController, hint: 'e.g, CFO'),
            ),
            PositionLabeledField(
              label: '${localizations.reportsTo} (Position Code)',
              isRequired: false,
              child: PositionFormHelpers.buildFormField(controller: reportsCodeController, hint: 'e.g, POS-CFO-001'),
            ),
          ],
        ),
      ],
    );
  }
}
