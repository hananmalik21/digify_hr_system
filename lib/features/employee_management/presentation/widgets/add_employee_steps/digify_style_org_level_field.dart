import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DigifyStyleOrgLevelField extends ConsumerWidget {
  const DigifyStyleOrgLevelField({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.isEnabled,
    this.displayLabel,
    this.showLabel = true,
    required this.onSelectionChanged,
  });

  final OrgStructureLevel level;
  final StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider;
  final bool isEnabled;
  final String? displayLabel;
  final bool showLabel;
  final void Function(String levelCode, OrgUnit? unit) onSelectionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final selectedUnit = selectionState.getSelection(level.levelCode);
    final options = selectionState.getOptions(level.levelCode);
    final isLoading = selectionState.isLoading(level.levelCode);
    final error = selectionState.getError(level.levelCode);
    final label = displayLabel ?? selectedUnit?.orgUnitNameEn ?? 'Select ${level.levelName}';

    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 14.h,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
              ),
            ],
          ),
        ),
      );
    }

    final content = InkWell(
      onTap: isEnabled
          ? () async {
              if (options.isEmpty && !isLoading && error == null) {
                ref.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode);
              }
              final selected = await OrgUnitSelectionDialog.show(
                context: context,
                level: level,
                selectionProvider: selectionProvider,
              );
              if (selected) {
                final newSelection = ref.read(selectionProvider).getSelection(level.levelCode);
                onSelectionChanged(level.levelCode, newSelection);
              }
            }
          : null,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : AppColors.inputBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: error != null ? AppColors.error : AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (displayLabel != null && displayLabel!.isNotEmpty) || selectedUnit != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            DigifyAsset(
              assetPath: Assets.icons.workforce.chevronRight.path,
              color: isEnabled ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.3),
              height: 15,
            ),
          ],
        ),
      ),
    );

    if (showLabel) {
      return PositionLabeledField(label: level.getLabel(), isRequired: true, child: content);
    }
    return content;
  }
}
