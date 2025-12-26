import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/org_units_table_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_org_unit_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/org_unit_details_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_tree_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_table_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_detail_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/bulk_upload_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/create_component_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Main screen for managing component values with tree view
class ManageComponentValuesScreen extends ConsumerStatefulWidget {
  const ManageComponentValuesScreen({super.key});

  @override
  ConsumerState<ManageComponentValuesScreen> createState() =>
      _ManageComponentValuesScreenState();
}

class _ManageComponentValuesScreenState
    extends ConsumerState<ManageComponentValuesScreen> {
  String? selectedLevelCode; // State to manage selected level tab
  final TextEditingController _orgUnitsSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('ManageComponentValuesScreen: initState');
  }

  @override
  void dispose() {
    _orgUnitsSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(componentValuesProvider);
    
    // Check if org units are being refreshed
    final orgUnitsStateForRefresh = selectedLevelCode != null
        ? ref.watch(orgUnitsProvider(selectedLevelCode!))
        : null;
    final isRefreshingOrgUnits = orgUnitsStateForRefresh != null
        ? orgUnitsStateForRefresh.isLoading && orgUnitsStateForRefresh.units.isNotEmpty
        : false;
    
    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: EdgeInsetsDirectional.only(
                  top: 16.h,
                  start: 16.w,
                  end: 16.w,
                  bottom: 16.h,
                ),
                tablet: EdgeInsetsDirectional.only(
                  top: 24.h,
                  start: 24.w,
                  end: 24.w,
                  bottom: 24.h,
                ),
                web: EdgeInsetsDirectional.only(
                  top: 88.h,
                  start: 24.w,
                  end: 24.w,
                  bottom: 24.h,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with gradient
                  _buildHeader(context, localizations, isDark),
                  SizedBox(height: 24.h),
                  // Stat cards
                  _buildStatCards(context, localizations, isDark, state),
                  SizedBox(height: 24.h),
                  // Level tabs from API
                  _buildLevelTabs(context, localizations, isDark, state, ref),
                  // Search and action buttons - Show for component table view and org units table, not tree view
                  // Always show buttons when not in tree view OR when a level tab is selected
                  if (!state.isTreeView || selectedLevelCode != null) ...[
                    SizedBox(height: 24.h),
                    _buildSearchAndActions(context, localizations, isDark, state, ref, selectedLevelCode),
                  ],
                  SizedBox(height: 24.h),
                  // Show loader when loading instead of dummy data
                  if (state.isLoading && state.components.isEmpty && selectedLevelCode == null)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: 16.h),
                            Text(
                              localizations.pleaseWait,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Tree view, Org Units table, or Component table view based on state
                    _buildContentView(context, localizations, isDark, state, ref),
                ],
              ),
            ),
            if (isRefreshingOrgUnits)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                            BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: 16.h),
                          Text(
                            localizations.pleaseWait,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(16.w),
        tablet: EdgeInsetsDirectional.all(20.w),
        web: EdgeInsetsDirectional.all(24.w),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9810FA), Color(0xFF155DFC)],
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.enterpriseStructure,
                  style: TextStyle(
                    fontSize: isTablet ? 20.sp : 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 32 / 22.7,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  localizations.manageOrganizationalHierarchy,
                  style: TextStyle(
                    fontSize: isTablet ? 14.sp : 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFF3E8FF),
                    height: 24 / 15.3,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.manageOrganizationalHierarchyAr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFF3E8FF),
                    height: 20 / 14,
                    letterSpacing: 0,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.enterpriseStructure,
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 22.7.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 32 / 22.7,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        localizations.manageOrganizationalHierarchy,
                        style: TextStyle(
                          fontSize: isTablet ? 14.sp : 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF3E8FF),
                          height: 24 / 15.3,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        localizations.manageOrganizationalHierarchyAr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF3E8FF),
                          height: 20 / 14,
                          letterSpacing: 0,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCards(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
  ) {
    final statCounts = state.statCounts;

    final statCards = [
      _StatCardData(
        label: localizations.companies,
        count: statCounts[ComponentType.company] ?? 0,
        icon: 'assets/icons/company_stat_icon.svg',
        color: AppColors.statIconPurple,
      ),
      _StatCardData(
        label: localizations.divisions,
        count: statCounts[ComponentType.division] ?? 0,
        icon: 'assets/icons/division_stat_icon.svg',
        color: AppColors.statIconBlue,
      ),
      _StatCardData(
        label: localizations.businessUnits,
        count: statCounts[ComponentType.businessUnit] ?? 0,
        icon: 'assets/icons/business_unit_stat_icon.svg',
        color: AppColors.statIconGreen,
      ),
      _StatCardData(
        label: localizations.departments,
        count: statCounts[ComponentType.department] ?? 0,
        icon: 'assets/icons/department_stat_icon.svg',
        color: AppColors.statIconOrange,
      ),
      _StatCardData(
        label: localizations.sections,
        count: statCounts[ComponentType.section] ?? 0,
        icon: 'assets/icons/section_stat_icon.svg',
        color: AppColors.textSecondary,
      ),
    ];

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    if (isMobile) {
      // Stack cards vertically on mobile
      return Column(
        children: statCards.map((card) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: card != statCards.last ? 12.h : 0,
            ),
            child: _buildStatCard(context, card, isDark),
          );
        }).toList(),
      );
    } else if (isTablet) {
      // 2 columns on tablet
      return Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        children: statCards.map((card) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 48.w - 16.w) / 2,
            child: _buildStatCard(context, card, isDark),
          );
        }).toList(),
      );
    } else {
      // Row layout on desktop
      return Row(
        children: statCards.map((card) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                end: card != statCards.last ? 16.w : 0,
              ),
              child: _buildStatCard(context, card, isDark),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    _StatCardData card,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.label,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : const Color(0xFF4A5565),
                  height: 20 / 13.7,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                card.count.toString(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: card.color,
                  height: 32 / 24,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SvgIconWidget(
            assetPath: card.icon,
            size: 24.sp,
            color: card.color,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTabs(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
    WidgetRef ref,
  ) {
    final activeLevelsState = ref.watch(activeLevelsProvider);
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (activeLevelsState.isLoading) {
    return Container(
        padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (activeLevelsState.hasError) {
      return Container(
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            activeLevelsState.errorMessage ?? 'Failed to load levels',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    final levels = activeLevelsState.levels;

    return Container(
      padding: EdgeInsetsDirectional.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: isMobile ? const AlwaysScrollableScrollPhysics() : null,
        child: Row(
          children: [
            // Tree View tab (always first)
            _buildLevelTab(
              context,
              localizations.treeView,
              state.isTreeView
                  ? 'assets/icons/tree_view_icon_active.svg'
                  : 'assets/icons/tree_view_icon.svg',
              isActive: state.isTreeView,
              isDark: isDark,
              onTap: () {
                debugPrint('Tree View tab tapped');
                setState(() {
                  selectedLevelCode = null;
                });
                if (!state.isTreeView) {
                ref.read(componentValuesProvider.notifier).toggleTreeView();
                }
              },
            ),
            SizedBox(width: 4.w),
            // Dynamic level tabs from API
            ...levels.map((level) {
              final icons = getIconsForLevelCode(level.levelCode);
              
              // Tab is active if it matches selectedLevelCode and tree view is not active
              final isTabActive = selectedLevelCode == level.levelCode;
              debugPrint('Building tab for ${level.levelCode}: isActive=$isTabActive, selectedLevelCode=$selectedLevelCode');
              
              return Padding(
                key: Key('tab_${level.levelCode}'),
                padding: EdgeInsetsDirectional.only(end: 4.w),
                child: _buildLevelTab(
              context,
                  level.levelName, // Use level_name from API
                  icons['icon'] ?? 'assets/icons/company_icon.svg',
                  isActive: isTabActive,
              isDark: isDark,
              onTap: () {

                    
                    // Disable tree view if it's active - do this first
                    if (state.isTreeView) {
                      ref.read(componentValuesProvider.notifier).toggleTreeView();
                    }
                    // Clear filter type when showing org units table
                    ref.read(componentValuesProvider.notifier).filterByType(null);
                    
                    // Always select the tapped tab (don't toggle, just select)
                    final newSelected = level.levelCode;
                    debugPrint('Setting selectedLevelCode to: $newSelected');
                    
                    setState(() {
                      selectedLevelCode = newSelected;
                      // Clear search when switching tabs
                      _orgUnitsSearchController.clear();
                    });
                    
                    debugPrint('After setState - selectedLevelCode: $selectedLevelCode');
                    
                    // Load org units for the selected level
                    debugPrint('Loading org units for structure ${level.structureId} and level: $newSelected');
                    // Defer loading until after the widget rebuilds
                    // This ensures ref.watch in _buildContentView happens first, keeping the provider alive
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && selectedLevelCode == newSelected) {
                        debugPrint('PostFrameCallback: Loading org units for $newSelected');
                        ref.read(orgUnitsProvider(newSelected).notifier).loadOrgUnits(
                          newSelected,
                          structureId: level.structureId,
                        );
                      } else {
                        debugPrint('PostFrameCallback: Skipping load - mounted=$mounted, selectedLevelCode=$selectedLevelCode, newSelected=$newSelected');
                      }
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
    WidgetRef ref,
  ) {
    debugPrint('_buildContentView called: isTreeView=${state.isTreeView}, selectedLevelCode=$selectedLevelCode');
    
    // Show tree view if tree view is active AND no level tab is selected
    if (state.isTreeView && selectedLevelCode == null) {
      debugPrint('_buildContentView: Showing tree view');
      return ComponentTreeView(
        onView: (component) {
          ComponentDetailDialog.show(
              context,
            component: component,
            allComponents: state.components,
          );
        },
        onEdit: (component) {
          CreateComponentDialog.show(
              context,
            initialValue: component,
          );
        },
        onDelete: (component) {
          // TODO: Open delete confirmation
        },
      );
    }

    // Show org units table if a level tab is selected
    if (selectedLevelCode != null && selectedLevelCode!.isNotEmpty) {
      debugPrint('_buildContentView: Showing org units table for level: $selectedLevelCode');
      // Watch the provider to keep it alive and get state updates
      // This watch ensures the provider stays alive during async operations
      final orgUnitsState = ref.watch(orgUnitsProvider(selectedLevelCode!));
      
      debugPrint('_buildContentView: selectedLevelCode=$selectedLevelCode');
      debugPrint('_buildContentView: isLoading=${orgUnitsState.isLoading}');
      debugPrint('_buildContentView: hasError=${orgUnitsState.hasError}');
      debugPrint('_buildContentView: units count=${orgUnitsState.units.length}');
      
      // If we have a level code but no data and not loading, trigger load
      // This handles the case where the tab was just selected
      if (!orgUnitsState.isLoading && 
          orgUnitsState.units.isEmpty && 
          !orgUnitsState.hasError &&
          orgUnitsState.levelCode == null) {
        debugPrint('_buildContentView: Triggering initial load for $selectedLevelCode');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && selectedLevelCode != null) {
            // Get structureId from active levels
            final activeLevelsState = ref.read(activeLevelsProvider);
            final level = activeLevelsState.levels.firstWhere(
              (l) => l.levelCode == selectedLevelCode,
              orElse: () => activeLevelsState.levels.first,
            );
            ref.read(orgUnitsProvider(selectedLevelCode!).notifier).loadOrgUnits(
              selectedLevelCode!,
              structureId: level.structureId,
              page: 1,
              pageSize: 10,
            );
          }
        });
      }
      
      if (orgUnitsState.hasError) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  orgUnitsState.errorMessage ?? 'Failed to load org units',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => ref.read(orgUnitsProvider(selectedLevelCode!).notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }
      
      debugPrint('_buildContentView: Rendering OrgUnitsTableWidget with ${orgUnitsState.units.length} units');
      if (orgUnitsState.units.isNotEmpty) {
        debugPrint('_buildContentView: First unit: ${orgUnitsState.units.first.orgUnitNameEn}');
      }
      return Column(
        children: [
          OrgUnitsTableWidget(
            units: orgUnitsState.units,
            isLoading: orgUnitsState.isLoading,
            isDark: isDark,
            localizations: localizations,
            onView: (unit) {
              OrgUnitDetailsDialog.show(context, unit);
            },
            onEdit: (unit) {
              // Get structureId from active levels
              final activeLevelsState = ref.read(activeLevelsProvider);
              final level = activeLevelsState.levels.firstWhere(
                (l) => l.levelCode == selectedLevelCode,
                orElse: () => activeLevelsState.levels.first,
              );
              AddOrgUnitDialog.show(
                context,
                structureId: level.structureId,
                levelCode: selectedLevelCode!,
                initialValue: unit,
              );
            },
            onDelete: (unit) async {
              // Get structureId from active levels
              final activeLevelsState = ref.read(activeLevelsProvider);
              final level = activeLevelsState.levels.firstWhere(
                (l) => l.levelCode == selectedLevelCode,
                orElse: () => activeLevelsState.levels.first,
              );
              
              bool isLoading = false;
              
              // Show delete confirmation dialog with loading state
              await showDialog<bool>(
                context: context,
                barrierColor: Colors.black.withValues(alpha: 0.45),
                barrierDismissible: false,
                builder: (dialogContext) => StatefulBuilder(
                  builder: (context, setState) {
                    return DeleteConfirmationDialog(
                      title: localizations.delete,
                      message: 'Are you sure you want to delete this ${selectedLevelCode?.toLowerCase()}? This action cannot be undone.',
                      itemName: unit.orgUnitNameEn,
                      isLoading: isLoading,
                      onConfirm: () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final deleteUseCase = ref.read(deleteOrgUnitUseCaseProvider);
                          await deleteUseCase.call(level.structureId, unit.orgUnitId, hard: true);

                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${unit.orgUnitNameEn} deleted successfully'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            // Refresh the org units list
                            ref.read(orgUnitsProvider(selectedLevelCode!).notifier).refresh();
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      onCancel: () {
                        if (!isLoading) {
                          Navigator.of(context).pop(false);
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
          // Pagination controls - Always show when there are items
          if (orgUnitsState.totalItems > 0) ...[
            SizedBox(height: 24.h),
            _buildPaginationControls(context, localizations, isDark, orgUnitsState, selectedLevelCode!, ref),
          ],
        ],
      );
    }

    // Default: show component table view
    return Builder(
      builder: (context) {
        // Read org structures provider
        final orgStructuresState = ref.watch(orgStructuresDropdownProvider);
        return ComponentTableView(
          components: state.filteredComponents,
          allComponents: state.components,
          filterType: state.filterType,
          orgStructures: orgStructuresState.structures,
          onView: (component) {
            ComponentDetailDialog.show(
              context,
              component: component,
              allComponents: state.components,
            );
          },
          onEdit: (component) {
            CreateComponentDialog.show(
              context,
              initialValue: component,
            );
          },
          onDelete: (component) {
            // TODO: Open delete confirmation
          },
          onDuplicate: state.filterType == ComponentType.department
              ? (component) {
                  // TODO: Open duplicate dialog
                }
              : null,
        );
      },
    );
  }


  Widget _buildLevelTab(
    BuildContext context,
    String label,
    String iconPath, {
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    debugPrint('_buildLevelTab: label=$label, isActive=$isActive');
    
    return GestureDetector(
      onTap: () {
        debugPrint('GestureDetector onTap called for: $label, isActive=$isActive');
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isActive
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIconWidget(
              assetPath: iconPath,
              size: 16.sp,
              color: isActive
                  ? Colors.white
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndActions(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
    WidgetRef ref,
    String? selectedLevelCode,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (isMobile) {
      // Stack vertically on mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchField(context, localizations, isDark, state, ref, selectedLevelCode),
          SizedBox(height: 12.h),
          _buildActionButtons(context, localizations, isDark, state, selectedLevelCode, isMobile: true),
        ],
      );
    } else {
      // Row layout on tablet/desktop
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search field - show for both component table and org units table
          Expanded(
            child: _buildSearchField(context, localizations, isDark, state, ref, selectedLevelCode),
          ),
          SizedBox(width: 16.w),
          // Action buttons - always show
          _buildActionButtons(context, localizations, isDark, state, selectedLevelCode, isMobile: false),
        ],
      );
    }
  }

  Widget _buildSearchField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
    WidgetRef ref,
    String? selectedLevelCode,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final fieldHeight = isMobile ? 44.h : (isTablet ? 42.h : 40.h);
    final fontSize = isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp);
    final iconSize = isMobile ? 18.sp : (isTablet ? 17.sp : 16.sp);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);
    final iconPadding = isMobile ? 10.w : (isTablet ? 11.w : 12.w);
    
    // Use different controller and hint text based on view type
    final isOrgUnitsView = selectedLevelCode != null;
    final controller = isOrgUnitsView ? _orgUnitsSearchController : null;
    final hintText = isOrgUnitsView 
        ? 'Search org units...'
        : localizations.searchComponents;
    
    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
            onChanged: (value) {
              if (isOrgUnitsView) {
                // Debounce API search call
                // isOrgUnitsView is true only when selectedLevelCode != null
                // Capture the value to use in the closure
                // ignore: unnecessary_non_null_assertion
                final levelCodeForSearch = selectedLevelCode!;
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted && _orgUnitsSearchController.text == value) {
                    ref.read(orgUnitsProvider(levelCodeForSearch).notifier).search(value);
                  }
                });
              } else {
                ref.read(componentValuesProvider.notifier).searchComponents(value);
              }
            },
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textPlaceholderDark
                : AppColors.textPlaceholder,
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.all(iconPadding),
            child: SvgIconWidget(
              assetPath: 'assets/icons/search_icon.svg',
              size: iconSize,
              color: isDark
                  ? AppColors.textPlaceholderDark
                  : AppColors.textPlaceholder,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsetsDirectional.symmetric(
            horizontal: horizontalPadding,
            vertical: isMobile ? 14.h : (isTablet ? 13.h : 12.h),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
    String? selectedLevelCode, {
    required bool isMobile,
  }) {
    if (isMobile) {
      // Stack buttons vertically on mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildActionButton(
            context,
            localizations,
            isDark,
            label: 'Add New',
            icon: 'assets/icons/add_new_icon_figma.svg',
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            onTap: () {
              debugPrint('Add New button tapped. selectedLevelCode: $selectedLevelCode');
              if (selectedLevelCode != null) {
                try {
                  // Get structureId from active levels
                  final activeLevelsState = ref.read(activeLevelsProvider);
                  debugPrint('Active levels state: hasError=${activeLevelsState.hasError}, levels count=${activeLevelsState.levels.length}');
                  
                  if (activeLevelsState.levels.isEmpty) {
                    debugPrint('No active levels available');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No active levels available'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  final level = activeLevelsState.levels.firstWhere(
                    (l) => l.levelCode == selectedLevelCode,
                    orElse: () => activeLevelsState.levels.first,
                  );
                  
                  final currentLevelCode = selectedLevelCode;
                  debugPrint('Opening AddOrgUnitDialog with structureId=${level.structureId}, levelCode=$currentLevelCode');
                  AddOrgUnitDialog.show(
                    context,
                    structureId: level.structureId,
                    levelCode: currentLevelCode,
                  );
                } catch (e, stackTrace) {
                  debugPrint('Error opening AddOrgUnitDialog: $e');
                  debugPrint('Stack trace: $stackTrace');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error opening dialog: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
              CreateComponentDialog.show(
                context,
                defaultType: state.filterType,
              );
              }
            },
          ),
          SizedBox(height: 8.h),
          _buildActionButton(
            context,
            localizations,
            isDark,
            label: localizations.bulkUpload,
            icon: 'assets/icons/bulk_upload_icon_figma.svg',
            backgroundColor: const Color(0xFF00A63E),
            textColor: Colors.white,
            onTap: () {
              if (selectedLevelCode != null) {
                // TODO: Open bulk upload dialog for org units
                debugPrint('Bulk upload org units for level: $selectedLevelCode');
              } else {
              BulkUploadDialog.show(context);
              }
            },
          ),
          SizedBox(height: 8.h),
          _buildActionButton(
            context,
            localizations,
            isDark,
            label: localizations.export,
            icon: 'assets/icons/download_icon.svg',
            backgroundColor: isDark
                ? AppColors.cardBackgroundGreyDark
                : const Color(0xFF4A5565),
            textColor: Colors.white,
            onTap: () {
              if (selectedLevelCode != null) {
                // TODO: Export org units
                debugPrint('Export org units for level: $selectedLevelCode');
              } else {
              // TODO: Export components
                debugPrint('Export components');
              }
            },
          ),
        ],
      );
    }
    
    return Row(
      children: [
        // Add New button
        _buildActionButton(
          context,
          localizations,
          isDark,
          label: 'Add New',
          icon: 'assets/icons/add_new_icon_figma.svg',
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          onTap: () {
            debugPrint('Add New button tapped (desktop). selectedLevelCode: $selectedLevelCode');
            if (selectedLevelCode != null) {
              try {
                // Get structureId from active levels
                final activeLevelsState = ref.read(activeLevelsProvider);
                debugPrint('Active levels state: hasError=${activeLevelsState.hasError}, levels count=${activeLevelsState.levels.length}');
                
                if (activeLevelsState.levels.isEmpty) {
                  debugPrint('No active levels available');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No active levels available'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final level = activeLevelsState.levels.firstWhere(
                  (l) => l.levelCode == selectedLevelCode,
                  orElse: () => activeLevelsState.levels.first,
                );
                
                final currentLevelCode = selectedLevelCode;
                debugPrint('Opening AddOrgUnitDialog with structureId=${level.structureId}, levelCode=$currentLevelCode');
                AddOrgUnitDialog.show(
                  context,
                  structureId: level.structureId,
                  levelCode: currentLevelCode,
                );
              } catch (e, stackTrace) {
                debugPrint('Error opening AddOrgUnitDialog: $e');
                debugPrint('Stack trace: $stackTrace');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error opening dialog: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else {
            CreateComponentDialog.show(
              context,
              defaultType: state.filterType,
            );
            }
          },
        ),
        SizedBox(width: 12.w),
        // Bulk Upload button
        _buildActionButton(
          context,
          localizations,
          isDark,
          label: localizations.bulkUpload,
          icon: 'assets/icons/bulk_upload_icon_figma.svg',
          backgroundColor: const Color(0xFF00A63E),
          textColor: Colors.white,
          onTap: () {
            if (selectedLevelCode != null) {
              // TODO: Open bulk upload dialog for org units
              debugPrint('Bulk upload org units for level: $selectedLevelCode');
            } else {
            BulkUploadDialog.show(context);
            }
          },
        ),
        SizedBox(width: 12.w),
        // Export button
        _buildActionButton(
          context,
          localizations,
          isDark,
          label: localizations.export,
          icon: 'assets/icons/download_icon.svg',
          backgroundColor: isDark
              ? AppColors.cardBackgroundGreyDark
              : const Color(0xFF4A5565),
          textColor: Colors.white,
          onTap: () {
            if (selectedLevelCode != null) {
              // TODO: Export org units
              debugPrint('Export org units for level: $selectedLevelCode');
            } else {
            // TODO: Export components
              debugPrint('Export components');
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark, {
    required String label,
    required String icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIconWidget(
                assetPath: icon,
                size: 20.sp,
                color: textColor,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    OrgUnitsState orgUnitsState,
    String levelCode,
    WidgetRef ref,
  ) {
    // Use ref.read to get the notifier - this ensures we get the same instance
    final notifier = ref.read(orgUnitsProvider(levelCode).notifier);
    
    debugPrint('_buildPaginationControls: currentPage=${orgUnitsState.currentPage}, totalPages=${orgUnitsState.totalPages}, hasNextPage=${orgUnitsState.hasNextPage}, hasPreviousPage=${orgUnitsState.hasPreviousPage}');
    final currentPage = orgUnitsState.currentPage;
    final totalPages = orgUnitsState.totalPages;
    
    // Generate page numbers to display
    List<int> getPageNumbers() {
      if (totalPages <= 7) {
        // Show all pages if 7 or fewer
        return List.generate(totalPages, (index) => index + 1);
      } else {
        // Show pages with ellipsis
        List<int> pages = [];
        if (currentPage <= 3) {
          // Show first 5 pages
          pages = [1, 2, 3, 4, 5];
        } else if (currentPage >= totalPages - 2) {
          // Show last 5 pages
          pages = [totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
        } else {
          // Show current page with 2 pages on each side
          pages = [currentPage - 2, currentPage - 1, currentPage, currentPage + 1, currentPage + 2];
        }
        return pages;
      }
    }
    
    final pageNumbers = getPageNumbers();
    final showFirstEllipsis = totalPages > 7 && currentPage > 4;
    final showLastEllipsis = totalPages > 7 && currentPage < totalPages - 3;
    
    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Page info
          Text(
            'Showing ${((currentPage - 1) * orgUnitsState.pageSize) + 1} - ${currentPage * orgUnitsState.pageSize > orgUnitsState.totalItems ? orgUnitsState.totalItems : currentPage * orgUnitsState.pageSize} of ${orgUnitsState.totalItems} items',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          // Pagination buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First page button
              if (totalPages > 7 && currentPage > 4)
                _buildPageButton(
                  context,
                  isDark,
                  page: 1,
                  currentPage: currentPage,
                  onTap: () {
                    debugPrint('First page button tapped');
                    notifier.goToPage(1);
                  },
                ),
              if (totalPages > 7 && currentPage > 4) SizedBox(width: 4.w),
              if (showFirstEllipsis)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    '...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              if (showFirstEllipsis) SizedBox(width: 4.w),
              
              // Previous button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: orgUnitsState.hasPreviousPage && !orgUnitsState.isLoading
                      ? () async {
                          debugPrint('Previous page button tapped - currentPage=${orgUnitsState.currentPage}, totalPages=${orgUnitsState.totalPages}, hasPreviousPage=${orgUnitsState.hasPreviousPage}');
                          try {
                            await notifier.previousPage();
                            debugPrint('Previous page navigation completed');
                          } catch (e) {
                            debugPrint('Error navigating to previous page: $e');
                          }
                        }
                      : null,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: orgUnitsState.isLoading && orgUnitsState.currentPage > 1
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.chevron_left,
                            size: 18.sp,
                            color: orgUnitsState.hasPreviousPage && !orgUnitsState.isLoading
                                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                                : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                          ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              
              // Page number buttons
              ...pageNumbers.map((page) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: _buildPageButton(
                    context,
                    isDark,
                    page: page,
                    currentPage: currentPage,
                    onTap: () {
                      debugPrint('Page number button $page tapped');
                      notifier.goToPage(page);
                    },
                  ),
                );
              }),
              
              SizedBox(width: 4.w),
              // Next button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: orgUnitsState.hasNextPage && !orgUnitsState.isLoading
                      ? () async {
                          debugPrint('=== NEXT PAGE BUTTON TAPPED ===');
                          debugPrint('Current state - currentPage=${orgUnitsState.currentPage}, totalPages=${orgUnitsState.totalPages}, hasNextPage=${orgUnitsState.hasNextPage}');
                          debugPrint('Current state - levelCode=${orgUnitsState.levelCode}, structureId=${orgUnitsState.structureId}, isLoading=${orgUnitsState.isLoading}');
                          try {
                            await notifier.nextPage();
                            debugPrint('Next page navigation completed successfully');
                          } catch (e, stackTrace) {
                            debugPrint('Error navigating to next page: $e');
                            debugPrint('Stack trace: $stackTrace');
                          }
                        }
                      : () {
                          debugPrint('=== NEXT PAGE BUTTON DISABLED ===');
                          debugPrint('hasNextPage=${orgUnitsState.hasNextPage}, isLoading=${orgUnitsState.isLoading}');
                          debugPrint('currentPage=${orgUnitsState.currentPage}, totalPages=${orgUnitsState.totalPages}');
                        },
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: orgUnitsState.isLoading && orgUnitsState.currentPage < orgUnitsState.totalPages
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.chevron_right,
                            size: 18.sp,
                            color: orgUnitsState.hasNextPage && !orgUnitsState.isLoading
                                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                                : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                          ),
                  ),
                ),
              ),
              
              if (showLastEllipsis) SizedBox(width: 4.w),
              if (showLastEllipsis)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    '...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              if (showLastEllipsis) SizedBox(width: 4.w),
              // Last page button
              if (totalPages > 7 && currentPage < totalPages - 3) SizedBox(width: 4.w),
              if (totalPages > 7 && currentPage < totalPages - 3)
                _buildPageButton(
                  context,
                  isDark,
                  page: totalPages,
                  currentPage: currentPage,
                  onTap: () {
                    debugPrint('Last page button tapped');
                    notifier.goToPage(totalPages);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    BuildContext context,
    bool isDark, {
    required int page,
    required int currentPage,
    required VoidCallback onTap,
  }) {
    final isActive = page == currentPage;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint('Page button $page tapped (currentPage=$currentPage)');
          onTap();
        },
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
            borderRadius: BorderRadius.circular(6.r),
            border: isActive
                ? null
                : Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                    width: 1,
                  ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? Colors.white
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCardData {
  final String label;
  final int count;
  final String icon;
  final Color color;

  _StatCardData({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}
