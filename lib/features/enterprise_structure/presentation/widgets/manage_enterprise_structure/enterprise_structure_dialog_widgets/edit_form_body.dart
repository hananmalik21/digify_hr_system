import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_area.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'active_switch_section.dart';
import 'enterprise_dropdown_section.dart';
import 'enterprise_structure_dialog_mode.dart';
import 'enterprise_structure_dialog_providers.dart';
import 'hierarchy_preview_section.dart';
import 'organizational_hierarchy_levels_section.dart';

class EditFormBody extends ConsumerWidget {
  final EditEnterpriseStructureState editState;
  final EditDialogParams params;
  final int? enterpriseId;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final AppLocalizations localizations;

  const EditFormBody({
    super.key,
    required this.editState,
    required this.params,
    required this.enterpriseId,
    required this.nameController,
    required this.descriptionController,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = editState.levels;
    final formNotifier = ref.read(editEnterpriseStructureDialogProvider(params).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EnterpriseDropdownSection(formState: editState, formNotifier: formNotifier, initialEnterpriseId: enterpriseId),
        EnterpriseStructureTextField(
          label: localizations.structureName,
          isRequired: true,
          controller: nameController,
          value: null,
          readOnly: false,
          hintText: null,
          onChanged: formNotifier.updateStructureName,
        ),
        Gap(16.h),
        EnterpriseStructureTextArea(
          label: localizations.description,
          isRequired: true,
          controller: descriptionController,
          value: null,
          readOnly: false,
          hintText: null,
          onChanged: formNotifier.updateDescription,
        ),
        Gap(16.h),
        ActiveSwitchSection(formState: editState, formNotifier: formNotifier),
        OrganizationalHierarchyLevelsSection(
          mode: EnterpriseStructureDialogMode.edit,
          levels: levels,
          formState: editState,
          formNotifier: formNotifier,
          dialogState: null,
        ),
        Gap(24.h),
        HierarchyPreviewSection(levels: levels),
        Gap(24.h),
        ConfigurationSummaryWidget(
          totalLevels: levels.length,
          activeLevels: levels.where((l) => l.isActive).length,
          hierarchyDepth: levels.where((l) => l.isActive).length,
          topLevel: levels.isNotEmpty ? levels.first.name : '',
        ),
      ],
    );
  }
}
