import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/gradient_icon_button.dart';
import 'package:digify_hr_system/core/widgets/data/stats_card.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/section.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/section_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_section_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/section_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionManagementScreen extends ConsumerWidget {
  const SectionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final sections = ref.watch(filteredSectionsProvider);
    final allSections = ref.watch(sectionListProvider);
    final totalEmployees = allSections.fold<int>(0, (prev, section) => prev + section.employees);
    final activeSections = allSections.where((section) => section.isActive).length;
    final totalBudget = allSections.fold<double>(0, (prev, section) {
      final sanitized = section.budget.replaceAll('M', '').replaceAll('K', '').replaceAll(' ', '');
      final parsed = double.tryParse(sanitized) ?? 0;
      // Convert K to M for calculation (divide by 1000)
      if (section.budget.contains('K')) {
        return prev + (parsed / 1000);
      }
      return prev + parsed;
    });
    final isDark = context.isDark;

    final stats = [
      StatsCardData(
        label: localizations.totalSections,
        value: '${allSections.length}',
        iconPath: 'assets/icons/section_stat_icon.svg',
        iconColor: const Color(0xFF00BBA7),
        iconBackground: const Color(0xFFCFFBF1),
      ),
      StatsCardData(
        label: localizations.activeSections,
        value: '$activeSections',
        iconPath: 'assets/icons/active_departments_icon.svg',
        iconColor: const Color(0xFF22C55E),
        iconBackground: const Color(0xFFDCFCE7),
      ),
      StatsCardData(
        label: localizations.totalEmployeesSection,
        value: '$totalEmployees',
        iconPath: 'assets/icons/total_employees_dept_icon.svg',
        iconColor: const Color(0xFF06B6D4),
        iconBackground: const Color(0xFFCEFAFE),
      ),
      StatsCardData(
        label: localizations.totalBudgetSection,
        value: '${totalBudget.toStringAsFixed(1)}M KWD',
        iconPath: 'assets/icons/total_budget_dept_icon.svg',
        iconColor: const Color(0xFF10B981),
        iconBackground: const Color(0xFFD0FAE5),
      ),
    ];

    return Container(
      color: context.themeBackground,
      child: SafeArea(
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
              _buildStatsSection(context, stats),
              SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
              _buildSearchBar(context, ref, localizations),
              SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
              _buildSectionList(context, sections, localizations, isDark: isDark),
            ],
          ),
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
          decoration: BoxDecoration(color: const Color(0xFF00BBA7), borderRadius: BorderRadius.circular(14.r)),
          child: Center(
            child: DigifyAsset(assetPath: Assets.icons.sectionIcon.path, width: 24, height: 24, color: Colors.white),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.sectionManagement,
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 22.1.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? context.themeTextPrimary,
                  height: 36 / 22.1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.manageSectionsSubtitle,
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
          label: localizations.addSection,
          iconPath: 'assets/icons/add_new_icon_figma.svg',
          backgroundColor: const Color(0xFF009689),
          onTap: () => AddSectionDialog.show(context),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, List<StatsCardData> stats) {
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
                onChanged: (value) => ref.read(sectionSearchQueryProvider.notifier).state = value,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  border: InputBorder.none,
                  hintText: localizations.searchSectionsPlaceholder,
                  hintStyle: TextStyle(color: const Color(0xFF364153).withValues(alpha: 0.5), fontSize: 15.3.sp),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.searchDepartmentIcon.path,
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
        ],
      ),
    );
  }

  Widget _buildSectionList(
    BuildContext context,
    List<SectionOverview> sections,
    AppLocalizations localizations, {
    required bool isDark,
  }) {
    if (sections.isEmpty) {
      return Center(
        child: Text(
          localizations.noResultsFound,
          style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.getResponsiveColumns(context, mobile: 1, tablet: 2, web: 3);
        const gap = 24.0;
        final totalSpacing = gap * (columns - 1);
        final cardWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - totalSpacing) / columns
            : double.infinity;

        return Wrap(
          spacing: gap,
          runSpacing: 24.h,
          children: sections.map((section) {
            return SizedBox(
              width: columns == 1 ? double.infinity : cardWidth,
              child: _SectionCard(section: section, localizations: localizations, isDark: isDark),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final SectionOverview section;
  final AppLocalizations localizations;
  final bool isDark;

  const _SectionCard({required this.section, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SectionDetailsDialog.show(context, section),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFFBF1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: DigifyAsset(
                                assetPath: Assets.icons.sectionIcon.path,
                                width: 20,
                                height: 20,
                                color: const Color(0xFF00BBA7),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section.name,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: context.themeTextPrimary,
                                    height: 27 / 17,
                                  ),
                                ),
                                Text(
                                  section.nameArabic,
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
                      Row(
                        children: [
                          _Badge(
                            label: section.code,
                            backgroundColor: const Color(0xFFF3F4F6),
                            textColor: const Color(0xFF364153),
                          ),
                          SizedBox(width: 8.w),
                          _Badge(
                            label: section.isActive ? localizations.active : localizations.inactive,
                            backgroundColor: isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7),
                            textColor: isDark ? AppColors.successTextDark : const Color(0xFF016630),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      _detailRow('assets/icons/department_small_icon.svg', section.departmentName),
                      SizedBox(height: 4.h),
                      _detailRow('assets/icons/business_unit_small_icon.svg', section.businessUnitName),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _ActionIcon(
                      assetPath: 'assets/icons/edit_icon_green.svg',
                      iconColor: const Color(0xFF22C55E),
                      onTap: () {
                        AddSectionDialog.show(context, isEditMode: true);
                      },
                    ),
                    SizedBox(width: 8.w),
                    _ActionIcon(
                      assetPath: 'assets/icons/delete_icon_red.svg',
                      iconColor: const Color(0xFFEF4444),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.headIcon.path,
                    width: 16,
                    height: 16,
                    color: context.themeTextSecondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${localizations.head}: ${section.headName}',
                    style: TextStyle(
                      fontSize: 13.9.sp,
                      fontWeight: FontWeight.w500,
                      color: context.themeTextSecondary,
                      height: 20 / 13.9,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: [
                _iconStat(
                  'assets/icons/department_metric_icon.svg',
                  '${section.employees} ${localizations.emp}',
                  context,
                ),
                _iconStat('assets/icons/department_metric3_icon.svg', '\$ ${section.budget}', context),
              ],
            ),
            SizedBox(height: 12.h),
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
                  section.focusArea,
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
      ),
    );
  }

  Widget _detailRow(String iconPath, String text) {
    return Row(
      children: [
        DigifyAsset(assetPath: iconPath, width: 12, height: 12, color: const Color(0xFF6A7282)),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6A7282),
              height: 20 / 13.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconStat(String iconPath, String value, BuildContext context) {
    return SizedBox(
      width: 140.w,
      child: Row(
        children: [
          DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: const Color(0xFF6A7282)),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6A7282),
                height: 20 / 13.7,
              ),
            ),
          ),
        ],
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

class _ActionIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionIcon({required this.assetPath, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: context.themeCardBackground),
        child: Center(
          child: DigifyAsset(
            assetPath: assetPath,
            width: 16,
            height: 16,
            color: iconColor ?? context.themeTextSecondary,
          ),
        ),
      ),
    );
  }
}
