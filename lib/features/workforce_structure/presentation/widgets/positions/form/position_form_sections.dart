import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
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

  const BasicInfoSection({
    super.key,
    required this.localizations,
    required this.codeController,
    required this.titleEnglishController,
    required this.titleArabicController,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.basicInformation,
      children: [
        PositionFormHelpers.buildFormField(
          label: localizations.positionCode,
          controller: codeController,
          hint: 'e.g, FIN-MGR-001',
        ),

        PositionFormRow(
          children: [
            PositionFormHelpers.buildFormField(
              label: '${localizations.positionTitle} (English)',
              controller: titleEnglishController,
              hint: 'e.g. Finance Manager',
            ),
            PositionFormHelpers.buildFormField(
              label: '${localizations.positionTitle} (Arabic)',
              controller: titleArabicController,
              hint: 'مثال: مدير مالي',
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ],
    );
  }
}

class OrganizationalSection extends ConsumerWidget {
  final AppLocalizations localizations;
  final Map<String, int?> selectedUnitIds;
  final Function(String levelCode, int? unitId) onEnterpriseSelectionChanged;
  final TextEditingController costCenterController;
  final TextEditingController locationController;

  const OrganizationalSection({
    super.key,
    required this.localizations,
    required this.selectedUnitIds,
    required this.onEnterpriseSelectionChanged,
    required this.costCenterController,
    required this.locationController,
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
        ),
        PositionFormRow(
          children: [
            PositionFormHelpers.buildFormField(
              label: localizations.costCenter,
              controller: costCenterController,
              hint: 'e.g., CC-1000',
            ),
            PositionFormHelpers.buildFormField(
              label: localizations.location,
              controller: locationController,
              hint: 'e.g., Kuwait City HQ',
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
            PositionFormHelpers.buildDropdownField<String>(
              label: localizations.step,
              value: selectedStep,
              items: const ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5'],
              onChanged: onStepChanged,
              hint: 'Select Step',
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
            PositionFormHelpers.buildFormField(
              label: "Number of Positions",
              controller: positionsController,
              hint: 'e.g, 5',
            ),
            PositionFormHelpers.buildFormField(
              label: "Filled Positions",
              controller: filledController,
              hint: 'e.g, 3',
            ),
            PositionFormHelpers.buildDropdownField<String>(
              label: "Employment Type",
              value: selectedEmploymentType,
              items: const ['FULL_TIME', 'PART_TIME', 'CONTRACT', 'TEMP'],
              onChanged: onEmploymentTypeChanged,
              itemLabelProvider: (val) => val.replaceAll('_', ' '),
              hint: 'Select Type',
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
            PositionFormHelpers.buildFormField(
              label: "${localizations.budgetedMin} (KD)",
              controller: budgetedMinController,
              hint: '1000',
            ),
            PositionFormHelpers.buildFormField(
              label: "${localizations.budgetedMax} (KD)",
              controller: budgetedMaxController,
              hint: '1500',
            ),
            PositionFormHelpers.buildFormField(
              label: "${localizations.actualAverage} (KD)",
              controller: actualAverageController,
              hint: '1250',
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
            PositionFormHelpers.buildFormField(
              label: '${localizations.reportsTo} (Position Title)',
              controller: reportsTitleController,
              hint: 'e.g, CFO',
              isRequired: false,
            ),
            PositionFormHelpers.buildFormField(
              label: '${localizations.reportsTo} (Position Code)',
              controller: reportsCodeController,
              hint: 'e.g, POS-CFO-001',
              isRequired: false,
            ),
          ],
        ),
      ],
    );
  }
}

class StatusSection extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isActive;
  final ValueChanged<bool> onStatusChanged;

  const StatusSection({
    super.key,
    required this.localizations,
    required this.isActive,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.status,
      children: [
        Row(
          children: [
            Switch(
              value: isActive,
              onChanged: onStatusChanged,
              activeThumbColor: AppColors.background,
              activeTrackColor: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }
}
