import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/action_button_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Action buttons widget
class ActionButtonsWidget extends ConsumerWidget {
  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isActive;
  final String title;
  final String description;
  final List<StructureLevelItem>? structureLevels;
  final int? enterpriseId;
  final int? structureId;
  final bool? structureIsActive;
  final AutoDisposeStateNotifierProvider<
      StructureListNotifier,
      StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<
      SaveEnterpriseStructureNotifier,
      SaveEnterpriseStructureState> saveEnterpriseStructureProvider;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);

    // Watch the save state to show loader only on the specific button being activated
    final saveState = ref.watch(saveEnterpriseStructureProvider);
    final isActivating =
        saveState.isSaving && saveState.loadingStructureId == structureId;

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        if (!isActive)
          ActionButtonWidget(
            context: context,
            localizations: localizations,
            isDark: isDark,
            label: localizations.activate,
            icon: 'assets/icons/activate_icon.svg',
            backgroundColor: const Color(0xFF00A63E),
            textColor: Colors.white,
            isLoading: isActivating,
            onTap: () async {
              if (structureId == null) {
                if (context.mounted) {
          ToastService.error(
            context,
            'Structure ID is required',
          );
                }
                return;
              }

              if (!context.mounted) return;

              // Get the notifier before the async operation
              final saveNotifier = ref.read(
                saveEnterpriseStructureProvider.notifier,
              );

              try {
                // Call update API with isActive: true
                await saveNotifier.saveStructure(
                  structureName: title,
                  description: description,
                  levels: const [],
                  // Empty for updates
                  enterpriseId: enterpriseId,
                  isActive: true,
                  structureId: structureId,
                );

                // Check result and refresh
                if (!context.mounted) return;

              ToastService.success(
                context,
                'Structure activated successfully',
              );
                // Refresh the list
                ref.read(structureListProvider.notifier).refresh();
              } on AppException catch (e) {
                // Handle error - use exception message directly
                if (!context.mounted) return;

              ToastService.error(
                context,
                e.message,
              );
              } catch (e) {
                // Handle unexpected errors
                if (!context.mounted) return;

              ToastService.error(
                context,
                'Failed to activate structure: ${e.toString()}',
              );
              }
            },
          ),
        if (!isActive) SizedBox(height: 8.h),
        ActionButtonWidget(
          context: context,
          localizations: localizations,
          isDark: isDark,
          label: localizations.view,
          icon: 'assets/icons/view_icon_blue.svg',
          backgroundColor: isDark
              ? AppColors.infoBgDark
              : const Color(0xFFEFF6FF),
          textColor: AppColors.primary,
          onTap: () {
            // Convert StructureLevelItem to HierarchyLevel for view mode
            final viewLevels = (structureLevels?.isNotEmpty ?? false)
                ? structureLevels!
                      .map((level) => convertToHierarchyLevel(level))
                      .toList()
                      .cast<HierarchyLevel>()
                : <HierarchyLevel>[];

            EnterpriseStructureDialog.showView(
              context,
              structureName: title,
              description: description,
              enterpriseId: enterpriseId,
              initialLevels: viewLevels,
              provider: structureListProvider,
            );
          },
        ),
        SizedBox(height: 8.h),
        ActionButtonWidget(
          context: context,
          localizations: localizations,
          isDark: isDark,
          label: localizations.edit,
          icon: 'assets/icons/edit_icon_purple.svg',
          backgroundColor: isDark
              ? AppColors.purpleBgDark
              : const Color(0xFFFAF5FF),
          textColor: const Color(0xFF9810FA),
          onTap: () {
            // Convert StructureLevelItem to HierarchyLevel
            final initialLevels = (structureLevels?.isNotEmpty ?? false)
                ? structureLevels!
                      .map((level) => convertToHierarchyLevel(level))
                      .toList()
                      .cast<HierarchyLevel>()
                : <HierarchyLevel>[];

            EnterpriseStructureDialog.showEdit(
              context,
              structureName: title,
              description: description,
              initialLevels: initialLevels,
              enterpriseId: enterpriseId,
              structureId: structureId,
              isActive: structureIsActive,
              provider: structureListProvider,
            );
          },
        ),
        // SizedBox(height: 8.h),
        // ActionButtonWidget(
        //   context: context,
        //   localizations: localizations,
        //   isDark: isDark,
        //   label: localizations.duplicate,
        //   icon: 'assets/icons/duplicate_icon.svg',
        //   backgroundColor: isDark
        //       ? AppColors.cardBackgroundGreyDark
        //       : const Color(0xFFF9FAFB),
        //   textColor: isDark
        //       ? AppColors.textSecondaryDark
        //       : const Color(0xFF4A5565),
        //   onTap: () {
        //     // TODO: Duplicate structure
        //   },
        // ),
        if (!isActive) ...[
          SizedBox(height: 8.h),
          ActionButtonWidget(
            context: context,
            localizations: localizations,
            isDark: isDark,
            label: localizations.delete,
            icon: 'assets/icons/delete_icon_red.svg',
            backgroundColor: isDark
                ? AppColors.errorBgDark
                : const Color(0xFFFEF2F2),
            textColor: AppColors.brandRed,
            onTap: () {
              // TODO: Delete structure
            },
          ),
        ],
      ],
    );
  }
}

