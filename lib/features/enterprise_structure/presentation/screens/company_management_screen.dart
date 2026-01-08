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
import 'package:digify_hr_system/features/enterprise_structure/domain/models/company.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/company_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_company_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/company_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyManagementScreen extends ConsumerWidget {
  const CompanyManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final companiesState = ref.watch(companiesProvider);
    final allCompanies = companiesState.companies;
    final totalEmployees = allCompanies.fold<int>(0, (previousValue, company) => previousValue + company.employees);
    final activeCompanies = allCompanies.where((company) => company.isActive).length;
    final isDark = context.isDark;
    final isRefreshing = companiesState.isLoading && allCompanies.isNotEmpty;

    final stats = [
      StatsCardData(
        label: localizations.totalCompanies,
        value: '${allCompanies.length}',
        iconPath: Assets.icons.companyStatIcon.path,
        iconColor: AppColors.statIconPurple,
        iconBackground: const Color(0xFFEDE9FE),
      ),
      StatsCardData(
        label: localizations.activeCompanies,
        value: '$activeCompanies',
        iconPath: Assets.icons.activeStructureIcon.path,
        iconColor: AppColors.statIconGreen,
        iconBackground: const Color(0xFFD1FAE5),
      ),
      StatsCardData(
        label: localizations.totalEmployees,
        value: '$totalEmployees',
        iconPath: Assets.icons.employeesAssignedIcon.path,
        iconColor: AppColors.statIconPurple,
        iconBackground: const Color(0xFFE7E0FF),
      ),
      StatsCardData(
        label: localizations.complianceStatus,
        value: localizations.compliant,
        iconPath: Assets.icons.complianceIcon.path,
        iconColor: AppColors.statIconGreen,
        iconBackground: const Color(0xFFE0F7EC),
      ),
    ];

    return Container(
      color: context.themeBackground,
      child: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: isRefreshing ? 0.5 : 1.0,
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(companiesProvider.notifier).refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: EdgeInsetsDirectional.only(top: 16.h, start: 16.w, end: 16.w, bottom: 24.h),
                    tablet: EdgeInsetsDirectional.only(top: 24.h, start: 24.w, end: 24.w, bottom: 24.h),
                    web: EdgeInsetsDirectional.only(top: 32.h, start: 32.w, end: 32.w, bottom: 32.h),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, localizations),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 20.h),
                      _buildStatsSection(context, stats, isDark: isDark),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildSearchBar(context, ref, localizations),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      if (companiesState.isLoading && companiesState.companies.isEmpty)
                        _buildLoadingState(context, localizations)
                      else if (companiesState.hasError)
                        _buildErrorState(
                          context,
                          ref,
                          companiesState.errorMessage ?? 'An error occurred while loading companies',
                          localizations,
                        )
                      else
                        _buildCompanyList(context, companiesState.companies, localizations, isDark: isDark),
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
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
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
          decoration: BoxDecoration(color: const Color(0xFF615FFF), borderRadius: BorderRadius.circular(12.r)),
          child: Center(
            child: DigifyAsset(assetPath: Assets.icons.companyIcon.path, width: 24, height: 24, color: Colors.white),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.companyManagement,
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? context.themeTextPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.manageCompanyInformation,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: context.themeTextSecondary,
                  height: 20 / 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GradientIconButton(
          label: localizations.addCompany,
          iconPath: 'assets/icons/add_new_icon_figma.svg',
          backgroundColor: const Color(0xFF5E4BFF),
          onTap: () => AddCompanyDialog.show(context),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          iconSize: 18.sp,
          fontSize: 14.sp,
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
      child: ClipRRect(
        // 🔑 FIX
        borderRadius: BorderRadius.circular(10.r),
        child: TextField(
          onChanged: (value) {
            ref.read(companiesProvider.notifier).searchCompanies(value);
          },
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDark ? AppColors.cardBackground : Colors.white,
            border: InputBorder.none,
            hintText: localizations.searchCompaniesPlaceholder,
            hintStyle: TextStyle(color: context.themeTextPlaceholder, fontSize: 14.sp),
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
          style: TextStyle(color: context.themeTextPrimary, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildCompanyList(
    BuildContext context,
    List<CompanyOverview> companies,
    AppLocalizations localizations, {
    required bool isDark,
  }) {
    if (companies.isEmpty) {
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
          children: companies.map((company) {
            return SizedBox(
              width: columns == 1 ? double.infinity : cardWidth,
              child: _CompanyCard(company: company, localizations: localizations, isDark: isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              'Loading companies...',
              style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String errorMessage, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: context.themeTextSecondary),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                ref.read(companiesProvider.notifier).refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyCard extends ConsumerWidget {
  final CompanyOverview company;
  final AppLocalizations localizations;
  final bool isDark;

  const _CompanyCard({required this.company, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => CompanyDetailsDialog.show(context, company),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: context.themeCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.themeCardBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(12.r)),
                  child: Center(
                    child: DigifyAsset(
                      assetPath: Assets.icons.companyStatIcon.path,
                      width: 20,
                      height: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: context.themeTextPrimary),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        company.nameArabic,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: context.themeTextSecondary,
                          height: 20 / 15,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                _ActionIcon(
                  assetPath: 'assets/icons/edit_icon_green.svg',
                  description: localizations.edit,
                  iconColor: context.themeTextSecondary,
                  onTap: () {
                    // Format established date from YYYY-MM-DD to DD/MM/YYYY if available
                    String? formattedDate;
                    if (company.establishedDate != null && company.establishedDate!.isNotEmpty) {
                      try {
                        final dateParts = company.establishedDate!.split('-');
                        if (dateParts.length == 3) {
                          formattedDate = '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
                        } else {
                          formattedDate = company.establishedDate;
                        }
                      } catch (e) {
                        formattedDate = company.establishedDate;
                      }
                    }

                    // Format currency for dropdown (e.g., "KWD" -> "KWD - Kuwaiti Dinar")
                    String? currencyDisplay;
                    if (company.currencyCode != null && company.currencyCode!.isNotEmpty) {
                      final currencyMap = {
                        'KWD': 'KWD - Kuwaiti Dinar',
                        'USD': 'USD - US Dollar',
                        'EUR': 'EUR - Euro',
                        'GBP': 'GBP - British Pound',
                      };
                      currencyDisplay =
                          currencyMap[company.currencyCode] ?? '${company.currencyCode} - ${company.currencyCode}';
                    }

                    AddCompanyDialog.show(
                      context,
                      isEditMode: true,
                      initialData: {
                        'companyId': int.tryParse(company.id) ?? 0,
                        'companyCode': company.entityCode,
                        'status': company.isActive ? 'Active' : 'Inactive',
                        'nameEn': company.name,
                        'nameAr': company.nameArabic,
                        'legalNameEn': company.legalNameEn ?? '',
                        'legalNameAr': company.legalNameAr ?? '',
                        'registrationNumber': company.registrationNumber,
                        'taxId': company.taxId ?? '',
                        'establishedDate': formattedDate ?? '',
                        'industry': company.industry,
                        'country': company.country ?? '',
                        'city': company.city ?? '',
                        'address': company.address ?? '',
                        'poBox': company.poBox ?? '',
                        'zipCode': company.zipCode ?? '',
                        'phone': company.phone,
                        'email': company.email,
                        'website': company.website ?? '',
                        'totalEmployees': company.employees.toString(),
                        'currency': currencyDisplay ?? 'KWD - Kuwaiti Dinar',
                        'fiscalYearStart': company.fiscalYearStart ?? '',
                        'orgStructureId': company.orgStructureId,
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
                      message: 'Are you sure you want to delete this company? This action cannot be undone.',
                      itemName: company.name,
                    );

                    if (confirmed == true) {
                      try {
                        final deleteUseCase = ref.read(deleteCompanyUseCaseProvider);
                        await deleteUseCase(int.parse(company.id), hard: true);

                        if (context.mounted) {
                          ToastService.success(context, 'Company deleted successfully');
                          // Refresh the companies list
                          ref.read(companiesProvider.notifier).refresh();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ToastService.error(context, 'Failed to delete company: ${e.toString()}');
                        }
                      }
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _Badge(label: company.entityCode, backgroundColor: const Color(0xFFF3F4F6)),
                _Badge(
                  label: company.isActive ? localizations.active : localizations.inactive,
                  backgroundColor: company.isActive
                      ? (isDark ? AppColors.successBgDark : AppColors.activeStatusBg)
                      : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.inactiveStatusBg),
                  textColor: company.isActive
                      ? (isDark ? AppColors.successTextDark : AppColors.activeStatusText)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.inactiveStatusText),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    context,
                    assetPath: 'assets/icons/enterprise_structure_main_icon.svg',
                    value: company.registrationNumber,
                  ),
                ),
                12.verticalSpace,
                Expanded(
                  child: _buildInfoRow(
                    context,
                    assetPath: 'assets/icons/users_icon.svg',
                    value: '${company.employees} ${localizations.employees}',
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    context,
                    assetPath: 'assets/icons/location_header_icon.svg',
                    value: company.location,
                  ),
                ),
                SizedBox(height: 8.w),
                Expanded(
                  child: _buildInfoRow(context, assetPath: 'assets/icons/financial_icon.svg', value: company.industry),
                ),
              ],
            ),

            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(context, assetPath: 'assets/icons/phone_icon.svg', value: company.phone),
                ),
                SizedBox(height: 8.w),
                Expanded(
                  child: _buildInfoRow(
                    context,
                    assetPath: 'assets/icons/email_envelope_purple.svg',
                    value: company.email,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {String? assetPath, IconData? icon, required String value}) {
    return Row(
      children: [
        if (assetPath != null)
          DigifyAsset(assetPath: assetPath, width: 18, height: 18, color: context.themeTextSecondary)
        else
          Icon(icon, size: 16.sp, color: context.themeTextSecondary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: context.themeTextPrimary,
              height: 20 / 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String assetPath;
  final String description;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionIcon({required this.assetPath, required this.description, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: context.themeCardBackground),
        child: Center(
          child: DigifyAsset(assetPath: assetPath, width: 18, height: 18, color: iconColor),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color? textColor;

  const _Badge({required this.label, required this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(6.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: textColor ?? context.themeTextSecondary),
      ),
    );
  }
}
