import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_list_item.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_empty_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgUnitSelectionDialog extends ConsumerWidget {
  final OrgStructureLevel level;
  final StateNotifierProvider<
    EnterpriseSelectionNotifier,
    EnterpriseSelectionState
  >
  selectionProvider;

  const OrgUnitSelectionDialog({
    super.key,
    required this.level,
    required this.selectionProvider,
  });

  static Future<bool> show({
    required BuildContext context,
    required OrgStructureLevel level,
    required StateNotifierProvider<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState
    >
    selectionProvider,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrgUnitSelectionDialog(
        level: level,
        selectionProvider: selectionProvider,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final options = selectionState.getOptions(level.levelCode);
    final isLoading = selectionState.isLoading(level.levelCode);
    final error = selectionState.getError(level.levelCode);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 8,
      child: Container(
        width: 550.w,
        constraints: BoxConstraints(maxHeight: 650.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrgUnitSelectionHeader(
              levelName: level.levelName,
              onClose: () => Navigator.of(context).pop(false),
            ),
            Flexible(
              child: _buildContent(context, ref, options, isLoading, error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List options,
    bool isLoading,
    String? error,
  ) {
    if (isLoading) {
      return const OrgUnitSelectionSkeleton();
    }

    if (error != null) {
      return OrgUnitSelectionErrorState(
        error: error,
        onRetry: () {
          ref
              .read(selectionProvider.notifier)
              .loadOptionsForLevel(level.levelCode);
        },
      );
    }

    if (options.isEmpty) {
      return const OrgUnitSelectionEmptyState(message: 'No options available');
    }

    return _buildOptionsList(context, ref, options);
  }

  Widget _buildOptionsList(BuildContext context, WidgetRef ref, List options) {
    final selectionState = ref.watch(selectionProvider);
    final selectedUnit = selectionState.getSelection(level.levelCode);

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(16.w),
      itemCount: options.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final unit = options[index];
        final isSelected = selectedUnit?.orgUnitId == unit.orgUnitId;

        return OrgUnitListItem(
          unit: unit,
          isSelected: isSelected,
          onTap: () {
            ref
                .read(selectionProvider.notifier)
                .selectUnit(level.levelCode, unit);
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }
}
