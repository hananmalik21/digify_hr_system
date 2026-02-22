import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_list_item.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_empty_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

/// Provider for parent org units
final parentOrgUnitsProvider = FutureProvider.autoDispose.family<List<OrgStructureLevel>, ParentOrgUnitsParams>((
  ref,
  params,
) async {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return await repository.getParentOrgUnits(params.structureId, params.levelCode);
});

class ParentOrgUnitsParams {
  final String structureId;
  final String levelCode;

  ParentOrgUnitsParams({required this.structureId, required this.levelCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentOrgUnitsParams &&
          runtimeType == other.runtimeType &&
          structureId == other.structureId &&
          levelCode == other.levelCode;

  @override
  int get hashCode => structureId.hashCode ^ levelCode.hashCode;
}

/// Dialog for selecting a parent org unit
class ParentOrgUnitPickerDialog extends ConsumerStatefulWidget {
  final String structureId;
  final String levelCode;
  final String? selectedParentId;

  const ParentOrgUnitPickerDialog({
    super.key,
    required this.structureId,
    required this.levelCode,
    this.selectedParentId,
  });

  static Future<OrgStructureLevel?> show(
    BuildContext context, {
    required String structureId,
    required String levelCode,
    String? selectedParentId,
  }) {
    return showDialog<OrgStructureLevel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) =>
          ParentOrgUnitPickerDialog(structureId: structureId, levelCode: levelCode, selectedParentId: selectedParentId),
    );
  }

  @override
  ConsumerState<ParentOrgUnitPickerDialog> createState() => _ParentOrgUnitPickerDialogState();
}

class _ParentOrgUnitPickerDialogState extends ConsumerState<ParentOrgUnitPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final parentUnitsAsync = ref.watch(
      parentOrgUnitsProvider(ParentOrgUnitsParams(structureId: widget.structureId, levelCode: widget.levelCode)),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
          vertical: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
        ),
        child: Container(
          width: 550.w,
          constraints: BoxConstraints(maxHeight: 650.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              OrgUnitSelectionHeader(
                levelName: 'Parent Org Unit',
                onClose: () => context.pop(),
                onSearchChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                initialSearchQuery: _searchQuery,
              ),
              // Content
              Flexible(
                child: parentUnitsAsync.when(
                  data: (units) {
                    final filteredUnits = units
                        .where(
                          (u) =>
                              u.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                              u.levelCode.toLowerCase().contains(_searchQuery.toLowerCase()),
                        )
                        .toList();

                    if (filteredUnits.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      padding: EdgeInsets.all(16.w),
                      itemCount: filteredUnits.length,
                      separatorBuilder: (context, index) => Gap(8.h),
                      itemBuilder: (context, index) {
                        final unit = filteredUnits[index];
                        final isSelected = widget.selectedParentId == unit.orgUnitId;

                        final orgUnit = OrgUnit(
                          orgUnitId: unit.orgUnitId,
                          orgStructureId: unit.orgStructureId,
                          enterpriseId: unit.enterpriseId,
                          levelCode: unit.levelCode,
                          orgUnitCode: unit.orgUnitId,
                          orgUnitNameEn: unit.orgUnitNameEn,
                          orgUnitNameAr: unit.orgUnitNameAr,
                          isActive: unit.isActive,
                        );

                        return OrgUnitListItem(unit: orgUnit, isSelected: isSelected, onTap: () => context.pop(unit));
                      },
                    );
                  },
                  loading: () => const OrgUnitSelectionSkeleton(),
                  error: (err, stack) => OrgUnitSelectionErrorState(
                    error: err.toString(),
                    onRetry: () {
                      ref.invalidate(
                        parentOrgUnitsProvider(
                          ParentOrgUnitsParams(structureId: widget.structureId, levelCode: widget.levelCode),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const OrgUnitSelectionEmptyState(message: 'No matching units found');
  }
}
