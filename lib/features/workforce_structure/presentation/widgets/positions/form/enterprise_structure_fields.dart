import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/enterprise_structure_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/specialized_org_unit_fields.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseStructureFields extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final Map<String, int?> selectedUnitIds;
  final Function(String levelCode, int? unitId) onSelectionChanged;

  const EnterpriseStructureFields({
    super.key,
    required this.localizations,
    required this.selectedUnitIds,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<EnterpriseStructureFields> createState() =>
      _EnterpriseStructureFieldsState();
}

class _EnterpriseStructureFieldsState
    extends ConsumerState<EnterpriseStructureFields> {
  StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState>?
  _cachedSelectionProvider;
  int? _cachedStructureId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orgStructureNotifierProvider.notifier).fetchOrgStructureLevels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orgStructureState = ref.watch(orgStructureNotifierProvider);
    final activeLevels = orgStructureState.orgStructure?.activeLevels ?? [];

    if (orgStructureState.isLoading) {
      return const EnterpriseStructureSkeleton();
    }

    if (orgStructureState.error != null) {
      return _buildErrorBox(orgStructureState.error!);
    }

    if (activeLevels.isEmpty) {
      return const SizedBox.shrink();
    }

    final structureId = orgStructureState.orgStructure!.structureId;

    if (_cachedSelectionProvider == null || _cachedStructureId != structureId) {
      _cachedStructureId = structureId;
      _cachedSelectionProvider = enterpriseSelectionNotifierProvider((
        levels: activeLevels,
        structureId: structureId,
      ));
    }

    final selectionProvider = _cachedSelectionProvider!;
    final selectionState = ref.watch(selectionProvider);

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

          // Step 1: Company Field
          if (activeLevels.isNotEmpty) ...[
            CompanySelectionField(
              level: activeLevels[0],
              selectionProvider: selectionProvider,
              onSelectionChanged: widget.onSelectionChanged,
            ),
            SizedBox(height: 16.h),
          ],

          // Step 2: Business Unit Field
          if (activeLevels.length > 1) ...[
            BusinessUnitSelectionField(
              level: activeLevels[1],
              selectionProvider: selectionProvider,
              isEnabled:
                  selectionState.getSelection(activeLevels[0].levelCode) !=
                  null,
              onSelectionChanged: widget.onSelectionChanged,
            ),
            if (activeLevels.length > 2) SizedBox(height: 16.h),
          ],

          // Remaining Levels (Division, Department, etc.)
          if (activeLevels.length > 2)
            ...activeLevels.asMap().entries.skip(2).map((entry) {
              final index = entry.key;
              final level = entry.value;
              final parentLevel = activeLevels[index - 1];
              final isEnabled =
                  selectionState.getSelection(parentLevel.levelCode) != null;

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
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Enterprise Structure',
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildErrorBox(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enterprise Structure',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load structure levels: $error',
            style: TextStyle(fontSize: 12.sp, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
