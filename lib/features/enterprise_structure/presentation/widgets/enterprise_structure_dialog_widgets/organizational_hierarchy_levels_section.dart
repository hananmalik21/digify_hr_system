import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog.dart'
    show EnterpriseStructureDialogMode;
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Organizational hierarchy levels section widget
class OrganizationalHierarchyLevelsSection extends ConsumerWidget {
  final EnterpriseStructureDialogMode mode;
  final List<HierarchyLevel> levels;
  final EditEnterpriseStructureState? state;
  final EnterpriseStructureDialogState? dialogState;
  final EditDialogParams params;
  final AutoDisposeStateNotifierProviderFamily<
      EditEnterpriseStructureNotifier,
      EditEnterpriseStructureState,
      EditDialogParams> editDialogProvider;

  const OrganizationalHierarchyLevelsSection({
    super.key,
    required this.mode,
    required this.levels,
    this.state,
    this.dialogState,
    required this.params,
    required this.editDialogProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.organizationalHierarchyLevels,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : const Color(0xFF101828),
                    ),
                  ),
                  if (mode != EnterpriseStructureDialogMode.view &&
                      dialogState != null) ...[
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        final api = dialogState!.toHierarchyLevels(
                          localizations,
                        );
                        if (api.isNotEmpty) {
                          ref
                              .read(editDialogProvider(params).notifier)
                              .resetToDefault(api);
                        }
                      },
                      child: Text(
                        localizations.resetToDefault,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.organizationalHierarchyLevels,
                    style: TextStyle(
                      fontSize: isTablet ? 14.5.sp : 15.4.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : const Color(0xFF101828),
                    ),
                  ),
                  if (mode != EnterpriseStructureDialogMode.view &&
                      dialogState != null)
                    GestureDetector(
                      onTap: () {
                        final api = dialogState!.toHierarchyLevels(
                          localizations,
                        );
                        if (api.isNotEmpty) {
                          ref
                              .read(editDialogProvider(params).notifier)
                              .resetToDefault(api);
                        }
                      },
                      child: Text(
                        localizations.resetToDefault,
                        style: TextStyle(
                          fontSize: isTablet ? 12.5.sp : 13.6.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
        SizedBox(height: isMobile ? 12.h : 16.h),

        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: levels.length,
          onReorder: (oldIndex, newIndex) {
            // Disable reordering in view mode and edit mode (only allow in create mode)
            if (mode == EnterpriseStructureDialogMode.view ||
                mode == EnterpriseStructureDialogMode.edit) {
              return;
            }

            if (oldIndex < 0 || oldIndex >= levels.length) return;
            if (levels[oldIndex].isMandatory) return;

            // ReorderableListView gives insertion index AFTER removal
            int target = newIndex;
            if (target > oldIndex) target -= 1;

            // Clamp
            if (target < 0) target = 0;
            if (target >= levels.length) target = levels.length - 1;

            // ✅ If dropping onto a mandatory index, move target to nearest non-mandatory
            if (levels[target].isMandatory) {
              final int dir = (target > oldIndex) ? 1 : -1;

              int scan = target;
              while (scan >= 0 &&
                  scan < levels.length &&
                  levels[scan].isMandatory) {
                scan += dir;
              }

              // If no slot found in that direction, try the other direction
              if (scan < 0 || scan >= levels.length) {
                scan = target;
                while (scan >= 0 &&
                    scan < levels.length &&
                    levels[scan].isMandatory) {
                  scan -= dir;
                }
              }

              // If still no valid target, cancel reorder
              if (scan < 0 || scan >= levels.length) return;

              target = scan;
            }

            // ✅ Now reorder using the corrected target
            ref
                .read(editDialogProvider(params).notifier)
                .reorderLevels(oldIndex, target);
          },

          itemBuilder: (context, index) {
            final level = levels[index];

            final card = HierarchyLevelCard(
              name: level.name,
              icon: level.icon,
              levelNumber: level.level,
              isMandatory: level.isMandatory,
              isActive: level.isActive,
              canMoveUp: index > 0,
              canMoveDown: index < levels.length - 1,
              // Disable level controls in view mode and edit mode (only allow in create mode)
              onMoveUp:
                  (mode == EnterpriseStructureDialogMode.view ||
                      mode == EnterpriseStructureDialogMode.edit)
                  ? null
                  : () => ref
                        .read(editDialogProvider(params).notifier)
                        .moveLevelUp(index),
              onMoveDown:
                  (mode == EnterpriseStructureDialogMode.view ||
                      mode == EnterpriseStructureDialogMode.edit)
                  ? null
                  : () => ref
                        .read(editDialogProvider(params).notifier)
                        .moveLevelDown(index),
              onToggleActive:
                  (mode == EnterpriseStructureDialogMode.view ||
                      mode == EnterpriseStructureDialogMode.edit)
                  ? null
                  : (_) => ref
                        .read(editDialogProvider(params).notifier)
                        .toggleLevelActive(index),
            );

            // ✅ Mandatory: NOT draggable (no drag handle wrapper)
            // Also disable drag in edit mode (only allow in create mode)
            if (level.isMandatory ||
                mode == EnterpriseStructureDialogMode.view ||
                mode == EnterpriseStructureDialogMode.edit) {
              return Padding(
                key: ValueKey(level.id),
                padding: EdgeInsetsDirectional.only(bottom: 12.h),
                child: card,
              );
            }

            // ✅ Non-mandatory: draggable
            return Padding(
              key: ValueKey(level.id),
              padding: EdgeInsetsDirectional.only(bottom: 12.h),
              child: ReorderableDragStartListener(index: index, child: card),
            );
          },
        ),
      ],
    );
  }
}

