import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_view_toggle_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_filter_org_param_provider.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_filters_state.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeSearchAndActions extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const EmployeeSearchAndActions({super.key, required this.localizations, required this.isDark});

  @override
  ConsumerState<EmployeeSearchAndActions> createState() => _EmployeeSearchAndActionsState();
}

class _EmployeeSearchAndActionsState extends ConsumerState<EmployeeSearchAndActions> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    final isDark = widget.isDark;
    final showFilters = ref.watch(manageEmployeesShowFiltersProvider);
    final viewMode = ref.watch(manageEmployeesViewModeProvider);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: localizations.searchByNameOrEmployeeNumber,
            onChanged: (value) => ref.read(manageEmployeesListProvider.notifier).setSearchQueryInput(value),
            onSubmitted: (value) => ref.read(manageEmployeesListProvider.notifier).search(value),
          ),
          Gap(16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.hardEdge,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppButton.outline(
                  label: localizations.filters,
                  onPressed: () => ref.read(manageEmployeesShowFiltersProvider.notifier).state = !showFilters,
                  svgPath: Assets.icons.employeeManagement.filterMain.path,
                ),
                Gap(12.w),
                _buildViewModeToggle(context, viewMode, isDark),
                Gap(12.w),
                AppButton(
                  label: localizations.export,
                  onPressed: () {},
                  svgPath: Assets.icons.downloadIcon.path,
                  backgroundColor: AppColors.shiftExportButton,
                ),
                Gap(12.w),
                AppButton(
                  label: localizations.import,
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  backgroundColor: AppColors.shiftUploadButton,
                ),
                Gap(12.w),
                AppButton(
                  label: localizations.refresh,
                  onPressed: () => ref.read(manageEmployeesListProvider.notifier).refresh(),
                  svgPath: Assets.icons.refreshGray.path,
                ),
              ],
            ),
          ),
          if (showFilters) ...[
            Gap(16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.employeeManagement.filterSecondary.path,
                            width: 20,
                            height: 20,
                          ),
                          Gap(8.w),
                          Text(
                            localizations.advancedFilters,
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(manageEmployeesFiltersProvider.notifier).clearAll();
                          final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
                          if (enterpriseId != null) {
                            final param = ref.read(manageEmployeesFilterOrgParamProvider(enterpriseId));
                            if (param != null) {
                              ref
                                  .read(
                                    enterpriseSelectionNotifierProvider((
                                      levels: param.levels,
                                      structureId: param.structureId,
                                    )).notifier,
                                  )
                                  .reset();
                            }
                          }
                          ref.read(manageEmployeesListProvider.notifier).refresh();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizations.clearAll,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                            ),
                            Gap(6.w),
                            DigifyAsset(
                              assetPath: Assets.icons.refreshGray.path,
                              width: 16,
                              height: 16,
                              color: AppColors.brandRed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(16.h),
                  _FilterDropdownsSection(
                    localizations: localizations,
                    isDark: isDark,
                    onEnsureOrgStructureLoaded: (int enterpriseId) {
                      final notifier = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId).notifier);
                      notifier.fetchOrgStructureByEnterpriseId(enterpriseId).then((_) {
                        final state = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId));
                        if (state.allStructures.isNotEmpty && state.orgStructure == null) {
                          notifier.selectStructure(state.allStructures.first.structureId);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewModeToggle(BuildContext context, EmployeeViewMode viewMode, bool isDark) {
    final nextMode = viewMode == EmployeeViewMode.grid ? EmployeeViewMode.list : EmployeeViewMode.grid;
    final assetPath = viewMode == EmployeeViewMode.grid
        ? Assets.icons.employeeManagement.gridView.path
        : Assets.icons.employeeListIcon.path;
    return AppViewToggleButton(
      svgPath: assetPath,
      onPressed: () {
        ref.read(manageEmployeesViewModeProvider.notifier).state = nextMode;
      },
      backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
    );
  }
}

class _FilterDropdownsSection extends ConsumerStatefulWidget {
  const _FilterDropdownsSection({
    required this.localizations,
    required this.isDark,
    required this.onEnsureOrgStructureLoaded,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final void Function(int enterpriseId) onEnsureOrgStructureLoaded;

  @override
  ConsumerState<_FilterDropdownsSection> createState() => _FilterDropdownsSectionState();
}

class _FilterDropdownsSectionState extends ConsumerState<_FilterDropdownsSection> {
  bool _orgLoadTriggered = false;
  @override
  Widget build(BuildContext context) {
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final param = enterpriseId != null ? ref.watch(manageEmployeesFilterOrgParamProvider(enterpriseId)) : null;
    final filters = ref.watch(manageEmployeesFiltersProvider);

    if (enterpriseId != null && !_orgLoadTriggered) {
      _orgLoadTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onEnsureOrgStructureLoaded(enterpriseId);
      });
    }

    final jobFamilyState = ref.watch(jobFamilyNotifierProvider);
    final jobLevelState = ref.watch(jobLevelNotifierProvider);
    final gradeState = ref.watch(gradeNotifierProvider);
    final positionState = ref.watch(positionNotifierProvider);

    if (jobFamilyState.items.isEmpty && !jobFamilyState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(jobFamilyNotifierProvider.notifier).loadFirstPage();
      });
    }
    if (jobLevelState.items.isEmpty && !jobLevelState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(jobLevelNotifierProvider.notifier).loadFirstPage();
      });
    }
    if (gradeState.items.isEmpty && !gradeState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(gradeNotifierProvider.notifier).loadFirstPage();
      });
    }
    if (positionState.items.isEmpty && !positionState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(positionNotifierProvider.notifier).loadFirstPage();
      });
    }

    final positionItems = positionState.items;
    final jobFamilyItems = jobFamilyState.items;
    final jobLevelItems = jobLevelState.items;
    final gradeItems = gradeState.items;

    final listNotifier = ref.read(manageEmployeesListProvider.notifier);
    final filtersNotifier = ref.read(manageEmployeesFiltersProvider.notifier);

    void applyFiltersAndRefresh() {
      listNotifier.refresh();
    }

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 180.w,
          child: DigifySelectField<AssignmentStatus?>(
            hint: widget.localizations.allStatuses,
            value: filters.assignmentStatus,
            items: [null, AssignmentStatus.active, AssignmentStatus.inactive],
            itemLabelBuilder: (status) {
              if (status == null) return widget.localizations.allStatuses;
              switch (status) {
                case AssignmentStatus.active:
                  return widget.localizations.active;
                case AssignmentStatus.inactive:
                  return widget.localizations.inactive;
                default:
                  return status.raw;
              }
            },
            onChanged: (status) {
              filtersNotifier.setAssignmentStatus(status);
              applyFiltersAndRefresh();
            },
            fillColor: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ),
        if (enterpriseId != null && param == null) ..._buildOrgFiltersLoadingPlaceholders(),
        if (param != null) ..._buildOrgCascade(param, filtersNotifier, applyFiltersAndRefresh),
        SizedBox(
          width: 180.w,
          child: DigifySelectField<String?>(
            hint: widget.localizations.allPositions,
            value: filters.positionId,
            items: [null, ...positionItems.map((p) => p.id)],
            itemLabelBuilder: (id) {
              if (id == null) return widget.localizations.allPositions;
              final list = positionItems.where((p) => p.id == id);
              return list.isEmpty ? id : list.first.titleEnglish;
            },
            onChanged: (id) {
              filtersNotifier.setPositionId(id);
              applyFiltersAndRefresh();
            },
            fillColor: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ),
        SizedBox(
          width: 180.w,
          child: DigifySelectField<int?>(
            hint: widget.localizations.allJobFamilies,
            value: filters.jobFamilyId,
            items: [null, ...jobFamilyItems.map((j) => j.id)],
            itemLabelBuilder: (id) {
              if (id == null) return widget.localizations.allJobFamilies;
              final list = jobFamilyItems.where((j) => j.id == id);
              return list.isEmpty ? '$id' : list.first.nameEnglish;
            },
            onChanged: (id) {
              filtersNotifier.setJobFamilyId(id);
              applyFiltersAndRefresh();
            },
            fillColor: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ),
        SizedBox(
          width: 180.w,
          child: DigifySelectField<int?>(
            hint: widget.localizations.allJobLevels,
            value: filters.jobLevelId,
            items: [null, ...jobLevelItems.map((j) => j.id)],
            itemLabelBuilder: (id) {
              if (id == null) return widget.localizations.allJobLevels;
              final list = jobLevelItems.where((j) => j.id == id);
              return list.isEmpty ? '$id' : list.first.nameEn;
            },
            onChanged: (id) {
              filtersNotifier.setJobLevelId(id);
              applyFiltersAndRefresh();
            },
            fillColor: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ),
        SizedBox(
          width: 180.w,
          child: DigifySelectField<int?>(
            hint: widget.localizations.allGrades,
            value: filters.gradeId,
            items: [null, ...gradeItems.map((g) => g.id)],
            itemLabelBuilder: (id) {
              if (id == null) return widget.localizations.allGrades;
              final list = gradeItems.where((g) => g.id == id);
              return list.isEmpty ? '$id' : list.first.gradeLabel;
            },
            onChanged: (id) {
              filtersNotifier.setGradeId(id);
              applyFiltersAndRefresh();
            },
            fillColor: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildOrgFiltersLoadingPlaceholders() {
    return List.generate(4, (_) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: SizedBox(
          width: 180.w,
          height: 48.h,
          child: Skeletonizer(
            enabled: true,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.inputBgDark : AppColors.inputBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
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
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrgCascade(
    ({List<OrgStructureLevel> levels, String structureId}) param,
    ManageEmployeesFiltersNotifier filtersNotifier,
    VoidCallback applyFiltersAndRefresh,
  ) {
    final selectionProvider = enterpriseSelectionNotifierProvider(param);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;
      return SizedBox(
        width: 180.w,
        child: DigifyStyleOrgLevelField(
          level: level,
          selectionProvider: selectionProvider,
          isEnabled: isEnabled,
          showLabel: false,
          onSelectionChanged: (levelCode, unit) {
            if (unit != null) {
              filtersNotifier.setOrgFilter(unit.orgUnitId, levelCode);
              applyFiltersAndRefresh();
            }
          },
        ),
      );
    }).toList();
  }
}
