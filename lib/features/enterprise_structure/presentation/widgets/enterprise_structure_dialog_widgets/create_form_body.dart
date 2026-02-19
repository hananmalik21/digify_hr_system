import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
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
import 'shimmer_loading_widget.dart';

class CreateFormBody extends ConsumerWidget {
  final List<HierarchyLevel> levels;
  final EditEnterpriseStructureState editState;
  final EnterpriseStructureDialogState? dialogState;
  final EditDialogParams params;
  final int? enterpriseId;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final AppLocalizations localizations;

  const CreateFormBody({
    super.key,
    required this.levels,
    required this.editState,
    required this.dialogState,
    required this.params,
    required this.enterpriseId,
    required this.nameController,
    required this.descriptionController,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isLoading = dialogState != null && dialogState!.isLoading;
    final hasError = dialogState != null && dialogState!.hasError;
    final errorMessage = dialogState?.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EnterpriseDropdownSection(
          params: params,
          editDialogProvider: editEnterpriseStructureDialogProvider,
          initialEnterpriseId: enterpriseId,
        ),
        EnterpriseStructureTextField(
          label: localizations.structureName,
          isRequired: true,
          controller: nameController,
          value: null,
          readOnly: false,
          hintText: localizations.structureNamePlaceholder,
          onChanged: (value) =>
              ref.read(editEnterpriseStructureDialogProvider(params).notifier).updateStructureName(value),
        ),
        Gap(16.h),
        EnterpriseStructureTextArea(
          label: localizations.description,
          isRequired: true,
          controller: descriptionController,
          value: null,
          readOnly: false,
          hintText: localizations.descriptionPlaceholder,
          onChanged: (value) =>
              ref.read(editEnterpriseStructureDialogProvider(params).notifier).updateDescription(value),
        ),
        Gap(16.h),
        ActiveSwitchSection(params: params, editDialogProvider: editEnterpriseStructureDialogProvider),
        _buildLevelsSection(context, ref, isDark, isLoading, hasError, errorMessage),
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

  Widget _buildLevelsSection(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    bool isLoading,
    bool hasError,
    String? errorMessage,
  ) {
    if (isLoading) {
      return const ShimmerLoadingWidget();
    }
    if (hasError) {
      return Padding(
        padding: EdgeInsetsDirectional.all(16.w),
        child: Text(
          errorMessage ?? 'Failed to load structure levels',
          style: TextStyle(fontSize: 13.sp, color: Colors.red),
        ),
      );
    }
    if (levels.isEmpty) {
      return Padding(
        padding: EdgeInsetsDirectional.all(16.w),
        child: Center(
          child: Text(
            'No structure levels found',
            style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565)),
          ),
        ),
      );
    }
    return OrganizationalHierarchyLevelsSection(
      mode: EnterpriseStructureDialogMode.create,
      levels: levels,
      state: editState,
      dialogState: dialogState,
      params: params,
      editDialogProvider: editEnterpriseStructureDialogProvider,
    );
  }
}
