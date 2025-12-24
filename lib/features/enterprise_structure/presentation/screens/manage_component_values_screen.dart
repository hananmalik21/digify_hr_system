import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_tree_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_table_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_detail_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/bulk_upload_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/create_component_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Main screen for managing component values with tree view
class ManageComponentValuesScreen extends ConsumerWidget {
  const ManageComponentValuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(componentValuesProvider);
    
    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
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
              // Filter pills
              _buildFilterPills(context, localizations, isDark, state, ref),
              // Search and action buttons - Only show for table views, not tree view
              if (!state.isTreeView) ...[
                SizedBox(height: 24.h),
                _buildSearchAndActions(context, localizations, isDark, state, ref),
              ],
              SizedBox(height: 24.h),
              // Tree view or Table view based on state
              state.isTreeView
                  ? ComponentTreeView(
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
                    )
                  : ComponentTableView(
                      components: state.filteredComponents,
                      allComponents: state.components,
                      filterType: state.filterType,
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
                    ),
            ],
          ),
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
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Open structure configuration dialog
                        },
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgIconWidget(
                                assetPath: 'assets/icons/structure_configuration_icon.svg',
                                size: 16.sp,
                                color: const Color(0xFF9810FA),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  localizations.structureConfiguration,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF9810FA),
                                    height: 24 / 15.3,
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        // TODO: Open settings
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: SvgIconWidget(
                            assetPath: 'assets/icons/settings_icon.svg',
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                SizedBox(width: 12.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // EnterpriseStructureDialog.showCreate(context,provider: provider);
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: isTablet ? 12.w : 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgIconWidget(
                              assetPath: 'assets/icons/structure_configuration_icon.svg',
                              size: isTablet ? 18.sp : 20.sp,
                              color: const Color(0xFF9810FA),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              localizations.structureConfiguration,
                              style: TextStyle(
                                fontSize: isTablet ? 13.sp : 15.3.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9810FA),
                                height: 24 / 15.3,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        // TODO: Open settings
                      },
                      child: Container(
                        width: isTablet ? 36.w : 32.w,
                        height: isTablet ? 36.h : 32.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: SvgIconWidget(
                            assetPath: 'assets/icons/settings_icon.svg',
                            size: isTablet ? 18.sp : 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildFilterPills(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValuesState state,
    WidgetRef ref,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      padding: EdgeInsetsDirectional.all(4.w),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: isMobile ? const AlwaysScrollableScrollPhysics() : null,
        child: Row(
          children: [
            // Tree View button
            _buildFilterPill(
              context,
              localizations.treeView,
              state.isTreeView
                  ? 'assets/icons/tree_view_icon_active.svg'
                  : 'assets/icons/tree_view_icon.svg',
              isActive: state.isTreeView,
              isDark: isDark,
              onTap: () {
                ref.read(componentValuesProvider.notifier).toggleTreeView();
              },
            ),
            SizedBox(width: 4.w),
            // Component type filters
            _buildFilterPill(
              context,
              localizations.company,
              'assets/icons/company_stat_icon.svg',
              isActive: state.filterType == ComponentType.company && !state.isTreeView,
              isDark: isDark,
              onTap: () {
                ref.read(componentValuesProvider.notifier).filterByType(
                      state.filterType == ComponentType.company
                          ? null
                          : ComponentType.company,
                    );
              },
            ),
            SizedBox(width: 4.w),
            _buildFilterPill(
              context,
              localizations.division,
              'assets/icons/division_stat_icon.svg',
              isActive: state.filterType == ComponentType.division && !state.isTreeView,
              isDark: isDark,
              onTap: () {
                ref.read(componentValuesProvider.notifier).filterByType(
                      state.filterType == ComponentType.division
                          ? null
                          : ComponentType.division,
                    );
              },
            ),
            SizedBox(width: 4.w),
            _buildFilterPill(
              context,
              localizations.businessUnit,
              'assets/icons/business_unit_stat_icon.svg',
              isActive: state.filterType == ComponentType.businessUnit && !state.isTreeView,
              isDark: isDark,
              onTap: () {
                ref.read(componentValuesProvider.notifier).filterByType(
                      state.filterType == ComponentType.businessUnit
                          ? null
                          : ComponentType.businessUnit,
                    );
              },
            ),
            SizedBox(width: 4.w),
            _buildFilterPill(
              context,
              localizations.department,
              'assets/icons/department_stat_icon.svg',
              isActive: state.filterType == ComponentType.department && !state.isTreeView,
              isDark: isDark,
              onTap: () {
                ref.read(componentValuesProvider.notifier).filterByType(
                      state.filterType == ComponentType.department
                          ? null
                          : ComponentType.department,
                    );
              },
            ),
            SizedBox(width: 4.w),
            _buildFilterPill(
              context,
              localizations.section,
              'assets/icons/section_stat_icon.svg',
              isActive: state.filterType == ComponentType.section && !state.isTreeView,
              isDark: isDark,
              onTap: () {
                ref.read(componentValuesProvider.notifier).filterByType(
                      state.filterType == ComponentType.section
                          ? null
                          : ComponentType.section,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(
    BuildContext context,
    String label,
    String iconPath, {
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(4.r),
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
                      : const Color(0xFF364153)),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: isActive
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF364153)),
                height: 24 / 15.1,
                letterSpacing: 0,
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
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (isMobile) {
      // Stack vertically on mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchField(context, localizations, isDark, state, ref),
          SizedBox(height: 12.h),
          _buildActionButtons(context, localizations, isDark, state, isMobile: true),
        ],
      );
    } else {
      // Row layout on tablet/desktop
      return Row(
        children: [
          // Search field
          Expanded(
            child: _buildSearchField(context, localizations, isDark, state, ref),
          ),
          SizedBox(width: 16.w),
          // Action buttons
          _buildActionButtons(context, localizations, isDark, state, isMobile: false),
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
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final fieldHeight = isMobile ? 44.h : (isTablet ? 42.h : 40.h);
    final fontSize = isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp);
    final iconSize = isMobile ? 18.sp : (isTablet ? 17.sp : 16.sp);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);
    final iconPadding = isMobile ? 10.w : (isTablet ? 11.w : 12.w);
    
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
        onChanged: (value) {
          ref.read(componentValuesProvider.notifier).searchComponents(value);
        },
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: localizations.searchComponents,
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
    ComponentValuesState state, {
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
              CreateComponentDialog.show(
                context,
                defaultType: state.filterType,
              );
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
              BulkUploadDialog.show(context);
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
              // TODO: Export components
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
            CreateComponentDialog.show(
              context,
              defaultType: state.filterType,
            );
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
            BulkUploadDialog.show(context);
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
            // TODO: Export components
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
