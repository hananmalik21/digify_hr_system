import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/core/widgets/buttons/gradient_icon_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/data/stats_card.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/division.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/company_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/division_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_division_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/division_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DivisionManagementScreen extends ConsumerWidget {
  const DivisionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final divisionsState = ref.watch(divisionsProvider);
    final allDivisions = divisionsState.divisions;
    final isRefreshing = divisionsState.isLoading && allDivisions.isNotEmpty;
    final totalEmployees = allDivisions.fold<int>(0, (previousValue, division) => previousValue + division.employees);
    final activeDivisions = allDivisions.where((division) => division.isActive).length;
    final isDark = context.isDark;

    // Calculate total budget
    double totalBudget = 0;
    for (var division in allDivisions) {
      final budgetStr = division.budget.replaceAll('M', '');
      totalBudget += double.tryParse(budgetStr) ?? 0;
    }

    final stats = [
      StatsCardData(
        label: localizations.totalDivisions,
        value: '${allDivisions.length}',
        iconPath: 'assets/icons/division_stat_icon.svg',
        iconColor: const Color(0xFF9810FA),
        iconBackground: const Color(0xFFF3E8FF),
      ),
      StatsCardData(
        label: localizations.activeDivisions,
        value: '$activeDivisions',
        iconPath: 'assets/icons/active_division_icon.svg',
        iconColor: const Color(0xFF22C55E),
        iconBackground: const Color(0xFFDCFCE7),
      ),
      StatsCardData(
        label: localizations.totalEmployees,
        value: '$totalEmployees',
        iconPath: 'assets/icons/employees_blue_icon.svg',
        iconColor: const Color(0xFF3B82F6),
        iconBackground: const Color(0xFFDBEAFE),
      ),
      StatsCardData(
        label: localizations.totalBudget,
        value: '${totalBudget.toStringAsFixed(1)}M KWD',
        iconPath: 'assets/icons/budget_icon.svg',
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
              onRefresh: () => ref.read(divisionsProvider.notifier).refresh(),
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
                      if (divisionsState.isLoading && divisionsState.divisions.isEmpty)
                        _buildLoadingState(context, localizations)
                      else if (divisionsState.hasError)
                        _buildErrorState(
                          context,
                          ref,
                          divisionsState.errorMessage ?? 'An error occurred while loading divisions',
                          localizations,
                        )
                      else
                        _buildDivisionList(context, allDivisions, localizations, isDark: isDark),
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

  Widget _buildLoadingState(BuildContext context, AppLocalizations localizations) {
    return Center(
      child: Column(
        children: [
          const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
          SizedBox(height: 16.h),
          Text(
            localizations.pleaseWait,
            style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message, AppLocalizations localizations) {
    return Center(
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: () => ref.read(divisionsProvider.notifier).refresh(), child: const Text('Retry')),
        ],
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
          decoration: BoxDecoration(color: const Color(0xFFAD46FF), borderRadius: BorderRadius.circular(14.r)),
          child: Center(
            child: DigifyAsset(assetPath: Assets.icons.divisionIcon.path, width: 24, height: 24, color: Colors.white),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.divisionManagement,
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 22.1.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? context.themeTextPrimary,
                  height: 36 / 22.1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.manageDivisionsSubtitle,
                style: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: context.themeTextSecondary,
                  height: 24 / 15.3,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GradientIconButton(
          label: localizations.addDivision,
          iconPath: 'assets/icons/add_division_icon.svg',
          backgroundColor: const Color(0xFF9810FA),
          onTap: () => AddDivisionDialog.show(context),
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
        color: isDark ? AppColors.cardBackground : Colors.white,
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
                onChanged: (value) => ref.read(divisionsProvider.notifier).searchDivisions(value),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackground : Colors.white,
                  border: InputBorder.none,
                  hintText: localizations.searchDivisionsPlaceholder,
                  hintStyle: TextStyle(color: const Color(0xFF364153).withValues(alpha: 0.5), fontSize: 15.3.sp),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.searchIcon.path,
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
                  assetPath: Assets.icons.companyFilterIcon.path,
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
                    localizations.allCompanies,
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

  Widget _buildDivisionList(
    BuildContext context,
    List<DivisionOverview> divisions,
    AppLocalizations localizations, {
    required bool isDark,
  }) {
    if (divisions.isEmpty) {
      return Center(
        child: Text(
          localizations.noResultsFound,
          style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
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
          children: divisions.map((division) {
            return SizedBox(
              width: columns == 1 ? double.infinity : cardWidth,
              child: _DivisionCard(division: division, localizations: localizations, isDark: isDark),
            );
          }).toList(),
        );
      },
    );
  }
}

class _DivisionCard extends ConsumerWidget {
  final DivisionOverview division;
  final AppLocalizations localizations;
  final bool isDark;

  const _DivisionCard({required this.division, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => DivisionDetailsDialog.show(context, division),
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
            // ===== Header Row (Left content + Right actions) =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon + Names
                      Row(
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: DigifyAsset(
                                assetPath: Assets.icons.divisionCardIcon.path,
                                width: 20,
                                height: 20,
                                color: const Color(0xFF9810FA),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  division.name,
                                  style: TextStyle(
                                    fontSize: 17.2.sp,
                                    fontWeight: FontWeight.w500,
                                    color: context.themeTextPrimary,
                                    height: 27 / 17.2,
                                  ),
                                ),
                                Text(
                                  division.nameArabic,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: context.themeTextSecondary,
                                    height: 24 / 16,
                                  ),
                                  textDirection: TextDirection.rtl,
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
                            label: division.code,
                            backgroundColor: const Color(0xFFF3F4F6),
                            textColor: const Color(0xFF364153),
                          ),
                          SizedBox(width: 8.w),
                          _Badge(
                            label: division.isActive ? localizations.active : localizations.inactive,
                            backgroundColor: division.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            textColor: division.isActive ? const Color(0xFF016630) : const Color(0xFF991B1B),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // Company Name
                      Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.buildingSmallIcon.path,
                            width: 12,
                            height: 12,
                            color: context.themeTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              division.companyName,
                              style: TextStyle(
                                fontSize: 13.6.sp,
                                fontWeight: FontWeight.w400,
                                color: context.themeTextSecondary,
                                height: 20 / 13.6,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right section: Action Buttons (ONLY ONCE)
                Row(
                  children: [
                    _ActionIcon(
                      assetPath: 'assets/icons/edit_icon_green.svg',
                      description: localizations.edit,
                      iconColor: context.themeTextSecondary,
                      onTap: () {
                        // Format established date from YYYY-MM-DD to DD/MM/YYYY if available
                        String? formattedDate;
                        if (division.establishedDate != null && division.establishedDate!.isNotEmpty) {
                          try {
                            final parts = division.establishedDate!.split('-');
                            if (parts.length == 3) {
                              formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';
                            } else {
                              formattedDate = division.establishedDate;
                            }
                          } catch (_) {
                            formattedDate = division.establishedDate;
                          }
                        }

                        // Use companyId from division if available, otherwise try resolve by name
                        int? companyId = division.companyId;
                        if (companyId == null && division.companyName.isNotEmpty) {
                          final companiesState = ref.read(companiesProvider);
                          if (companiesState.companies.isNotEmpty) {
                            try {
                              final company = companiesState.companies.firstWhere(
                                (c) => c.name == division.companyName,
                              );
                              companyId = int.tryParse(company.id);
                            } catch (_) {}
                          }
                        }

                        final divisionId = int.tryParse(division.id);
                        if (divisionId == null || divisionId <= 0) {
                          ToastService.error(context, 'Invalid division ID. Cannot edit this division.');
                          return;
                        }

                        AddDivisionDialog.show(
                          context,
                          isEditMode: true,
                          initialData: {
                            'divisionId': divisionId,
                            'divisionCode': division.code,
                            'nameEn': division.name,
                            'nameAr': division.nameArabic,
                            'company': division.companyName,
                            'companyId': companyId,
                            'headOfDivision': division.headName,
                            'headEmail': division.headEmail ?? '',
                            'headPhone': division.headPhone ?? '',
                            'location': division.location,
                            'city': division.city ?? '',
                            'address': division.address ?? '',
                            'establishedDate': formattedDate ?? '',
                            'totalEmployees': division.employees.toString(),
                            'totalDepartments': division.departments.toString(),
                            'annualBudget': division.budget.replaceAll(RegExp(r'[^\d.]'), ''),
                            'businessFocus': division.industry,
                            'description': division.description ?? '',
                            'status': division.isActive ? 'Active' : 'Inactive',
                          },
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    _ActionIcon(
                      assetPath: 'assets/icons/delete_icon_red.svg',
                      description: localizations.delete,
                      iconColor: AppColors.deleteIconRed,
                      onTap: () async {
                        final confirmed = await DeleteConfirmationDialog.show(
                          context,
                          title: localizations.delete,
                          message: 'Are you sure you want to delete this division? This action cannot be undone.',
                          itemName: division.name,
                        );

                        if (confirmed == true) {
                          try {
                            final deleteUseCase = ref.read(deleteDivisionUseCaseProvider);
                            await deleteUseCase(int.parse(division.id), hard: true);

                            if (!context.mounted) return;

                            ToastService.success(context, 'Division deleted successfully');
                            ref.read(divisionsProvider.notifier).refresh();
                          } catch (e) {
                            if (!context.mounted) return;
                            ToastService.error(context, 'Failed to delete division: $e');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // ===== Stats Row =====
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'assets/icons/employees_small_icon.svg',
                    '${division.employees} ${localizations.emp}',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'assets/icons/departments_icon.svg',
                    '${division.departments} ${localizations.depts}',
                  ),
                ),
                Expanded(child: _buildInfoItem(context, 'assets/icons/budget_small_icon.svg', division.budget)),
              ],
            ),

            SizedBox(height: 12.h),

            // ===== Location Row =====
            Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.locationSmallIcon.path,
                  width: 16,
                  height: 16,
                  color: context.themeTextSecondary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    division.location,
                    style: TextStyle(
                      fontSize: 13.6.sp,
                      fontWeight: FontWeight.w400,
                      color: context.themeTextSecondary,
                      height: 20 / 13.6,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // ===== Industry Row =====
            Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.industryIcon.path,
                  width: 16,
                  height: 16,
                  color: context.themeTextSecondary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    division.industry,
                    style: TextStyle(
                      fontSize: 13.6.sp,
                      fontWeight: FontWeight.w400,
                      color: context.themeTextSecondary,
                      height: 20 / 13.6,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String iconPath, String value) {
    return Row(
      children: [
        DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: context.themeTextSecondary),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.7.sp,
              fontWeight: FontWeight.w400,
              color: context.themeTextSecondary,
              height: 20 / 13.7,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final String? description;
  final Color? iconColor;

  const _ActionIcon({required this.assetPath, required this.onTap, this.description, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        child: DigifyAsset(assetPath: assetPath, width: 16, height: 16, color: iconColor ?? context.themeTextSecondary),
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
