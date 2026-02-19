import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'enterprise_structure_dialog_mode.dart';

class OrganizationalHierarchyLevelsSection extends ConsumerWidget {
  final EnterpriseStructureDialogMode mode;
  final List<HierarchyLevel> levels;
  final EditEnterpriseStructureState? state;
  final EnterpriseStructureDialogState? dialogState;
  final EditDialogParams params;
  final AutoDisposeStateNotifierProviderFamily<
    EditEnterpriseStructureNotifier,
    EditEnterpriseStructureState,
    EditDialogParams
  >
  editDialogProvider;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.organizationalHierarchyLevels,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            if (mode != EnterpriseStructureDialogMode.view && dialogState != null)
              GestureDetector(
                onTap: () {
                  final api = dialogState!.toHierarchyLevels(localizations);
                  if (api.isNotEmpty) {
                    ref.read(editDialogProvider(params).notifier).resetToDefault(api);
                  }
                },
                child: Text(
                  localizations.resetToDefault,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.primary),
                ),
              ),
          ],
        ),
        Gap(16.h),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: levels.length,
          onReorder: (oldIndex, newIndex) {
            if (mode == EnterpriseStructureDialogMode.view || mode == EnterpriseStructureDialogMode.edit) {
              return;
            }

            if (oldIndex < 0 || oldIndex >= levels.length) return;
            if (levels[oldIndex].isMandatory) return;

            int target = newIndex;
            if (target > oldIndex) target -= 1;

            // Clamp
            if (target < 0) target = 0;
            if (target >= levels.length) target = levels.length - 1;

            if (levels[target].isMandatory) {
              final int dir = (target > oldIndex) ? 1 : -1;

              int scan = target;
              while (scan >= 0 && scan < levels.length && levels[scan].isMandatory) {
                scan += dir;
              }

              if (scan < 0 || scan >= levels.length) {
                scan = target;
                while (scan >= 0 && scan < levels.length && levels[scan].isMandatory) {
                  scan -= dir;
                }
              }

              if (scan < 0 || scan >= levels.length) return;
              target = scan;
            }

            ref.read(editDialogProvider(params).notifier).reorderLevels(oldIndex, target);
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
              onMoveUp: (mode == EnterpriseStructureDialogMode.view || mode == EnterpriseStructureDialogMode.edit)
                  ? null
                  : () => ref.read(editDialogProvider(params).notifier).moveLevelUp(index),
              onMoveDown: (mode == EnterpriseStructureDialogMode.view || mode == EnterpriseStructureDialogMode.edit)
                  ? null
                  : () => ref.read(editDialogProvider(params).notifier).moveLevelDown(index),
              onToggleActive: (mode == EnterpriseStructureDialogMode.view || mode == EnterpriseStructureDialogMode.edit)
                  ? null
                  : (_) => ref.read(editDialogProvider(params).notifier).toggleLevelActive(index),
              showArrows: mode != EnterpriseStructureDialogMode.view,
            );

            if (level.isMandatory ||
                mode == EnterpriseStructureDialogMode.view ||
                mode == EnterpriseStructureDialogMode.edit) {
              return Padding(
                key: ValueKey(level.id),
                padding: EdgeInsetsDirectional.only(bottom: 12.h),
                child: card,
              );
            }

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
