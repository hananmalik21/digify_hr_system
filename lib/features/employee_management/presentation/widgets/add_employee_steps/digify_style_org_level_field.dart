import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifyStyleOrgLevelField extends ConsumerWidget {
  const DigifyStyleOrgLevelField({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.isEnabled,
    required this.onSelectionChanged,
  });

  final OrgStructureLevel level;
  final StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider;
  final bool isEnabled;
  final void Function(String levelCode, String? unitId) onSelectionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final selectedUnit = selectionState.getSelection(level.levelCode);
    final options = selectionState.getOptions(level.levelCode);
    final isLoading = selectionState.isLoading(level.levelCode);
    final error = selectionState.getError(level.levelCode);

    return PositionLabeledField(
      label: level.getLabel(),
      isRequired: true,
      child: InkWell(
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
                  onSelectionChanged(level.levelCode, newSelection?.orgUnitId);
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
                  selectedUnit?.orgUnitNameEn ?? 'Select ${level.levelName}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedUnit != null
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
      ),
    );
  }
}
