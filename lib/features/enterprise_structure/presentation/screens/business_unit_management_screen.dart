import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/gradient_icon_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/data/stats_card.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/business_unit_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_business_unit_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/business_unit_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessUnitManagementScreen extends ConsumerWidget {
  const BusinessUnitManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final listState = ref.watch(businessUnitListNotifierProvider);
    final businessUnits = listState.businessUnits;
    final isRefreshing = listState.isLoading && businessUnits.isNotEmpty;
    final isDark = context.isDark;

    // Calculate stats from current list
    final totalEmployees = businessUnits.fold<int>(0, (previousValue, bu) => previousValue + bu.employees);
    final activeUnits = businessUnits.where((bu) => bu.isActive).length;

    // Calculate total budget
    double totalBudget = 0;
    for (var bu in businessUnits) {
      final budgetStr = bu.budget.replaceAll('M', '').replaceAll(' KWD', '').replaceAll(',', '');
      totalBudget += double.tryParse(budgetStr) ?? 0;
    }

    final stats = [
      StatsCardData(
        label: localizations.totalUnits,
        value: '${businessUnits.length}',
        iconPath: 'assets/icons/total_units_icon.svg',
        iconColor: const Color(0xFF3B82F6),
        iconBackground: const Color(0xFFDBEAFE),
      ),
      StatsCardData(
        label: localizations.activeUnits,
        value: '$activeUnits',
        iconPath: 'assets/icons/active_units_icon.svg',
        iconColor: const Color(0xFF22C55E),
        iconBackground: const Color(0xFFDCFCE7),
      ),
      StatsCardData(
        label: localizations.totalEmployees,
        value: '$totalEmployees',
        iconPath: 'assets/icons/employees_cyan_icon.svg',
        iconColor: const Color(0xFF06B6D4),
        iconBackground: const Color(0xFFCEFAFE),
      ),
      StatsCardData(
        label: localizations.totalBudget,
        value: '${totalBudget.toStringAsFixed(1)}M KWD',
        iconPath: 'assets/icons/budget_green_icon.svg',
        iconColor: const Color(0xFF10B981),
        iconBackground: const Color(0xFFD0FAE5),
      ),
    ];

    return Container(
      color: context.themeBackground,
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => ref.read(businessUnitListNotifierProvider.notifier).refresh(),
              child: Opacity(
                opacity: isRefreshing ? 0.5 : 1.0,
                child: SingleChildScrollView(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: EdgeInsetsDirectional.only(top: 16.h, start: 16.w, end: 16.w, bottom: 24.h),
                    tablet: EdgeInsetsDirectional.only(top: 24.h, start: 24.w, end: 24.w, bottom: 24.h),
                    web: EdgeInsetsDirectional.only(top: 24.h, start: 24.w, end: 24.w, bottom: 24.h),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, localizations),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildStatsSection(context, stats, isDark: isDark),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildSearchBar(context, ref, localizations),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildBusinessUnitList(context, ref, listState, businessUnits, localizations, isDark: isDark),
                    ],
                  ),
                ),
              ),
            ),
            if (isRefreshing)
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
                          const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
                          SizedBox(height: 16.h),
                          Text(
                            localizations.pleaseWait,
                            style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
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

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(color: const Color(0xFF2B7FFF), borderRadius: BorderRadius.circular(14.r)),
          child: Center(
            child: DigifyAsset(
              assetPath: Assets.icons.businessUnitIcon.path,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.businessUnitManagement,
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 22.1.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? context.themeTextPrimary,
                  height: 36 / 22.1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.manageBusinessUnitsSubtitle,
                style: TextStyle(
                  fontSize: 15.1.sp,
                  fontWeight: FontWeight.w400,
                  color: context.themeTextSecondary,
                  height: 24 / 15.1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GradientIconButton(
          label: localizations.addBusinessUnit,
          iconPath: 'assets/icons/add_business_unit_icon.svg',
          backgroundColor: const Color(0xFF155DFC),
          onTap: () => AddBusinessUnitDialog.show(context),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, List<StatsCardData> stats, {required bool isDark}) {
    final gap = 16.w;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.getResponsiveColumns(context, mobile: 1, tablet: 2, web: 4);
        final totalSpacing = gap * (columns - 1);
        final width = constraints.maxWidth.isFinite ? (constraints.maxWidth - totalSpacing) / columns : double.infinity;

        return Wrap(
          spacing: gap,
          runSpacing: 12.h,
          children: stats.map((stat) {
            return SizedBox(
              width: columns == 1 ? double.infinity : width,
              child: StatsCard(data: stat),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: TextField(
                onChanged: (value) {
                  ref.read(businessUnitSearchQueryProvider.notifier).state = value;
                  // Debounce API search - only search if user stops typing for 500ms
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (ref.read(businessUnitSearchQueryProvider) == value) {
                      ref.read(businessUnitListNotifierProvider.notifier).search(value);
                    }
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  border: InputBorder.none,
                  hintText: localizations.searchBusinessUnitsPlaceholder,
                  hintStyle: TextStyle(color: const Color(0xFF364153).withValues(alpha: 0.5), fontSize: 15.3.sp),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.searchIconBu.path,
                      width: 20,
                      height: 20,
                      color: context.themeTextSecondary,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                ),
                style: TextStyle(color: context.themeTextPrimary, fontSize: 15.3.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.divisionFilterIcon.path,
                  width: 20,
                  height: 20,
                  color: context.themeTextSecondary,
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DC)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    localizations.allDivisions,
                    style: TextStyle(
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                      height: 19 / 15.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessUnitList(
    BuildContext context,
    WidgetRef ref,
    BusinessUnitListState listState,
    List<BusinessUnitOverview> businessUnits,
    AppLocalizations localizations, {
    required bool isDark,
  }) {
    if (listState.isLoading && businessUnits.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
        ),
      );
    }

    if (listState.hasError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                listState.errorMessage ?? 'An error occurred',
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref.read(businessUnitListNotifierProvider.notifier).refresh(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (businessUnits.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.getResponsiveColumns(context, mobile: 1, tablet: 2, web: 2);
        const gap = 24.0;
        final totalSpacing = gap * (columns - 1);
        final cardWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - totalSpacing) / columns
            : double.infinity;

        return Wrap(
          spacing: gap,
          runSpacing: 24.h,
          children: businessUnits.map((bu) {
            return SizedBox(
              width: columns == 1 ? double.infinity : cardWidth,
              child: _BusinessUnitCard(
                businessUnit: bu,
                localizations: localizations,
                isDark: isDark,
                onDelete: (businessUnit) => _handleDelete(context, ref, businessUnit, localizations),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    BusinessUnitOverview businessUnit,
    AppLocalizations localizations,
  ) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: localizations.delete,
      message: 'Are you sure you want to delete this business unit? This action cannot be undone.',
      itemName: businessUnit.name,
    );

    if (confirmed == true) {
      try {
        final deleteUseCase = ref.read(deleteBusinessUnitUseCaseProvider);
        await deleteUseCase(int.parse(businessUnit.id), hard: true);
        if (context.mounted) {
          ToastService.success(context, 'Business unit deleted successfully');
          ref.read(businessUnitListNotifierProvider.notifier).refresh();
        }
      } catch (e) {
        if (context.mounted) {
          ToastService.error(context, 'Error deleting business unit: ${e.toString()}');
        }
      }
    }
  }
}

class _BusinessUnitCard extends StatelessWidget {
  final BusinessUnitOverview businessUnit;
  final AppLocalizations localizations;
  final bool isDark;
  final Function(BusinessUnitOverview) onDelete;

  const _BusinessUnitCard({
    required this.businessUnit,
    required this.localizations,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BusinessUnitDetailsDialog.show(context, businessUnit);
      },
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: context.themeCardBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: context.themeCardBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: -1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon + Name
                      Row(
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: DigifyAsset(
                                assetPath: Assets.icons.businessUnitCardIcon.path,
                                width: 20,
                                height: 20,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  businessUnit.name,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: context.themeTextPrimary,
                                    height: 27 / 17,
                                  ),
                                ),
                                Text(
                                  businessUnit.nameArabic,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: context.themeTextSecondary,
                                    height: 24 / 16,
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Badges
                      Row(
                        children: [
                          _Badge(
                            label: businessUnit.code,
                            backgroundColor: const Color(0xFFF3F4F6),
                            textColor: const Color(0xFF364153),
                          ),
                          SizedBox(width: 8.w),
                          _Badge(
                            label: businessUnit.isActive ? localizations.active : localizations.inactive,
                            backgroundColor: isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7),
                            textColor: isDark ? AppColors.successTextDark : const Color(0xFF016630),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Division Name
                      Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.divisionSmallIcon.path,
                            width: 12,
                            height: 12,
                            color: context.themeTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              businessUnit.divisionName,
                              style: TextStyle(
                                fontSize: 13.7.sp,
                                fontWeight: FontWeight.w400,
                                color: context.themeTextSecondary,
                                height: 20 / 13.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // Company Name
                      Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.buildingSmall2Icon.path,
                            width: 12,
                            height: 12,
                            color: const Color(0xFF6A7282),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              businessUnit.companyName,
                              style: TextStyle(
                                fontSize: 13.6.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6A7282),
                                height: 20 / 13.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    _ActionIcon(
                      assetPath: 'assets/icons/edit_icon_green.svg',
                      onTap: () {
                        AddBusinessUnitDialog.show(context, isEditMode: true, businessUnit: businessUnit);
                      },
                    ),
                    SizedBox(width: 8.w),
                    _ActionIcon(assetPath: 'assets/icons/delete_icon_red.svg', onTap: () => onDelete(businessUnit)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Details Section
            Column(
              children: [
                // Head Row
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.headPersonSmallIcon.path,
                        width: 16,
                        height: 16,
                        color: context.themeTextSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${localizations.head}:',
                        style: TextStyle(
                          fontSize: 13.9.sp,
                          fontWeight: FontWeight.w500,
                          color: context.themeTextSecondary,
                          height: 20 / 13.9,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        businessUnit.headName,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w400,
                          color: context.themeTextSecondary,
                          height: 20 / 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.employeesSmall2Icon.path,
                            width: 16,
                            height: 16,
                            color: context.themeTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${businessUnit.employees} ${localizations.emp}',
                            style: TextStyle(
                              fontSize: 13.7.sp,
                              fontWeight: FontWeight.w400,
                              color: context.themeTextSecondary,
                              height: 20 / 13.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.departmentsSmallIcon.path,
                            width: 16,
                            height: 16,
                            color: context.themeTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${businessUnit.departments} ${localizations.depts}',
                            style: TextStyle(
                              fontSize: 13.6.sp,
                              fontWeight: FontWeight.w400,
                              color: context.themeTextSecondary,
                              height: 20 / 13.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.budgetSmall2Icon.path,
                            width: 16,
                            height: 16,
                            color: context.themeTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            businessUnit.budget,
                            style: TextStyle(
                              fontSize: 13.8.sp,
                              fontWeight: FontWeight.w400,
                              color: context.themeTextSecondary,
                              height: 20 / 13.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Focus Area Row
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.focusAreaIcon.path,
                      width: 16,
                      height: 16,
                      color: context.themeTextSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      businessUnit.focusArea,
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: context.themeTextSecondary,
                        height: 20 / 13.6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _ActionIcon({required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: context.themeCardBackground),
        child: Center(
          child: DigifyAsset(assetPath: assetPath, width: 16, height: 16, color: context.themeTextSecondary),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _Badge({required this.label, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(4.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w400, color: textColor, height: 20 / 13.5),
      ),
    );
  }
}
