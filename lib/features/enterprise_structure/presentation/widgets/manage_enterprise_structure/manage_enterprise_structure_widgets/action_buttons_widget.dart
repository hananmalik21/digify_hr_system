import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/dialogs/enterprise_structure_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/action_button_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_activate_handler.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_delete_handler.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActionButtonsWidget extends ConsumerWidget {
  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isActive;
  final String title;
  final String description;
  final List<StructureLevelItem>? structureLevels;
  final int? enterpriseId;
  final String? structureId;
  final bool? structureIsActive;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>
  saveEnterpriseStructureProvider;

  const ActionButtonsWidget({
    super.key,
    required this.context,
    required this.localizations,
    required this.isDark,
    required this.isActive,
    required this.title,
    required this.description,
    this.structureLevels,
    this.enterpriseId,
    this.structureId,
    this.structureIsActive,
    required this.structureListProvider,
    required this.saveEnterpriseStructureProvider,
  });

  List<HierarchyLevel> get _viewLevels => (structureLevels?.isNotEmpty ?? false)
      ? structureLevels!.map(convertToHierarchyLevel).toList().cast<HierarchyLevel>()
      : <HierarchyLevel>[];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveState = ref.watch(saveEnterpriseStructureProvider);
    final isActivating = saveState.isSaving && saveState.loadingStructureId == structureId;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isActive)
          ActionButtonWidget(
            context: context,
            localizations: localizations,
            isDark: isDark,
            label: localizations.activate,
            icon: Assets.icons.checkIconGreen.path,
            backgroundColor: AppColors.greenButton,
            textColor: AppColors.buttonTextLight,
            isLoading: isActivating,
            onTap: () => handleStructureActivate(
              context,
              ref,
              title: title,
              description: description,
              structureId: structureId,
              enterpriseId: enterpriseId,
              localizations: localizations,
              saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
              structureListProvider: structureListProvider,
            ),
          ),
        if (!isActive) Gap(8.h),
        ActionButtonWidget(
          context: context,
          localizations: localizations,
          isDark: isDark,
          label: localizations.view,
          icon: Assets.icons.viewIconBlue.path,
          backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
          textColor: AppColors.primary,
          onTap: () => EnterpriseStructureDialog.showView(
            context,
            structureName: title,
            description: description,
            enterpriseId: enterpriseId,
            initialLevels: _viewLevels,
            provider: structureListProvider,
          ),
        ),
        Gap(8.h),
        ActionButtonWidget(
          context: context,
          localizations: localizations,
          isDark: isDark,
          label: localizations.edit,
          icon: Assets.icons.editIconPurple.path,
          backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
          iconColor: AppColors.primary,
          textColor: AppColors.primary,
          onTap: () => EnterpriseStructureDialog.showEdit(
            context,
            structureName: title,
            description: description,
            initialLevels: _viewLevels,
            enterpriseId: enterpriseId,
            structureId: structureId,
            isActive: structureIsActive,
            provider: structureListProvider,
          ),
        ),
        if (!isActive) ...[
          Gap(8.h),
          ActionButtonWidget(
            context: context,
            localizations: localizations,
            isDark: isDark,
            label: localizations.delete,
            icon: Assets.icons.deleteIconRed.path,
            backgroundColor: isDark ? AppColors.errorBgDark : AppColors.redBg,
            textColor: AppColors.brandRed,
            onTap: () => handleStructureDelete(
              context,
              ref,
              title: title,
              structureId: structureId,
              localizations: localizations,
              structureListProvider: structureListProvider,
            ),
          ),
        ],
      ],
    );
  }
}
