import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/org_structure_selection_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_field.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/specialized_org_unit_fields.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentEnterpriseStructureFields extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final int enterpriseId;
  final Map<String, String?> selectedUnitIds;
  final Function(String levelCode, String? unitId) onSelectionChanged;

  const ScheduleAssignmentEnterpriseStructureFields({
    super.key,
    required this.localizations,
    required this.enterpriseId,
    required this.selectedUnitIds,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<ScheduleAssignmentEnterpriseStructureFields> createState() =>
      _ScheduleAssignmentEnterpriseStructureFieldsState();
}

class _ScheduleAssignmentEnterpriseStructureFieldsState
    extends ConsumerState<ScheduleAssignmentEnterpriseStructureFields> {
  StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState>? _selectionProvider;
  String? _currentStructureId;

  @override
  Widget build(BuildContext context) {
    final enterpriseState = ref.watch(enterpriseOrgStructureNotifierProvider(widget.enterpriseId));
    final selectedStructure = enterpriseState.orgStructure;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 16.h),
          _buildStructureSelector(enterpriseState.allStructures, selectedStructure),
          if (selectedStructure != null) ...[
            SizedBox(height: 16.h),
            _buildStructureFieldsForStructure(selectedStructure),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Enterprise Structure',
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
    );
  }

  Widget _buildStructureSelector(List<OrgStructure> structures, OrgStructure? selectedStructure) {
    final enterpriseNotifier = ref.read(enterpriseOrgStructureNotifierProvider(widget.enterpriseId).notifier);

    String displayName = 'Select Structure';
    OrgStructure? structureToUse;

    if (selectedStructure != null) {
      structureToUse = selectedStructure;
      displayName = selectedStructure.structureName;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Organizational Structure',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 13.8,
                color: AppColors.inputLabel,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '*',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 13.8,
                color: AppColors.deleteIconRed,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () async {
            final currentState = ref.read(enterpriseOrgStructureNotifierProvider(widget.enterpriseId));

            if (currentState.allStructures.isEmpty) {
              enterpriseNotifier.fetchOrgStructureByEnterpriseId(widget.enterpriseId);
            }

            final selected = await OrgStructureSelectionDialog.show(
              context: context,
              selectedStructure: structureToUse,
              structures: currentState.allStructures,
              enterpriseId: widget.enterpriseId,
            );

            if (selected != null) {
              setState(() {
                _selectionProvider = null;
                _currentStructureId = null;
              });

              ref
                  .read(enterpriseOrgStructureNotifierProvider(widget.enterpriseId).notifier)
                  .selectStructure(selected.structureId);

              for (final levelCode in widget.selectedUnitIds.keys.toList()) {
                widget.onSelectionChanged(levelCode, null);
              }
            }
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedStructure != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(
                  assetPath: Assets.icons.workforce.chevronRight.path,
                  color: AppColors.textSecondary,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStructureFieldsForStructure(OrgStructure selectedStructure) {
    final activeLevels = selectedStructure.activeLevels;

    if (activeLevels.isEmpty) {
      return const SizedBox.shrink();
    }

    final structureId = selectedStructure.structureId;

    if (_selectionProvider == null || _currentStructureId != structureId) {
      _currentStructureId = structureId;
      _selectionProvider = enterpriseSelectionNotifierProvider((levels: activeLevels, structureId: structureId));
    }

    final selectionProvider = _selectionProvider!;
    final selectionState = ref.watch(selectionProvider);

    return _buildStructureFields(activeLevels, selectionProvider, selectionState);
  }

  Widget _buildStructureFields(
    List<OrgStructureLevel> activeLevels,
    StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider,
    EnterpriseSelectionState selectionState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activeLevels.isNotEmpty) ...[
          CompanySelectionField(
            level: activeLevels[0],
            selectionProvider: selectionProvider,
            onSelectionChanged: widget.onSelectionChanged,
          ),
          SizedBox(height: 16.h),
        ],
        if (activeLevels.length > 1) ...[
          BusinessUnitSelectionField(
            level: activeLevels[1],
            selectionProvider: selectionProvider,
            isEnabled: selectionState.getSelection(activeLevels[0].levelCode) != null,
            onSelectionChanged: widget.onSelectionChanged,
          ),
          if (activeLevels.length > 2) SizedBox(height: 16.h),
        ],
        if (activeLevels.length > 2)
          ...activeLevels.asMap().entries.skip(2).map((entry) {
            final index = entry.key;
            final level = entry.value;
            final parentLevel = activeLevels[index - 1];
            final isEnabled = selectionState.getSelection(parentLevel.levelCode) != null;

            return Column(
              children: [
                OrgUnitSelectionField(
                  level: level,
                  selectionProvider: selectionProvider,
                  isEnabled: isEnabled,
                  onSelectionChanged: widget.onSelectionChanged,
                ),
                if (index < activeLevels.length - 1) SizedBox(height: 16.h),
              ],
            );
          }),
      ],
    );
  }
}
