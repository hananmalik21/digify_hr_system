import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/company.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/company_management_provider.dart';
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
    final companies = ref.watch(filteredCompanyProvider);
    final allCompanies = ref.watch(companyListProvider);
    final totalEmployees = allCompanies.fold<int>(
      0,
      (previousValue, company) => previousValue + company.employees,
    );
    final activeCompanies = allCompanies
        .where((company) => company.isActive)
        .length;
    final isDark = context.isDark;

    final stats = [
      _StatCardData(
        label: localizations.totalCompanies,
        value: '${allCompanies.length}',
        iconPath: 'assets/icons/company_stat_icon.svg',
        iconColor: AppColors.statIconPurple,
        iconBackground: const Color(0xFFEDE9FE),
      ),
      _StatCardData(
        label: localizations.activeCompanies,
        value: '$activeCompanies',
        iconPath: 'assets/icons/active_structure_icon.svg',
        iconColor: AppColors.statIconGreen,
        iconBackground: const Color(0xFFD1FAE5),
      ),
      _StatCardData(
        label: localizations.totalEmployees,
        value: '$totalEmployees',
        iconPath: 'assets/icons/employees_assigned_icon.svg',
        iconColor: AppColors.statIconPurple,
        iconBackground: const Color(0xFFE7E0FF),
      ),
      _StatCardData(
        label: localizations.complianceStatus,
        value: localizations.compliant,
        iconPath: 'assets/icons/compliance_icon.svg',
        iconColor: AppColors.statIconGreen,
        iconBackground: const Color(0xFFE0F7EC),
      ),
    ];

    return Container(
      color: context.themeBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: EdgeInsetsDirectional.only(
              top: 16.h,
              start: 16.w,
              end: 16.w,
              bottom: 24.h,
            ),
            tablet: EdgeInsetsDirectional.only(
              top: 24.h,
              start: 24.w,
              end: 24.w,
              bottom: 24.h,
            ),
            web: EdgeInsetsDirectional.only(
              top: 32.h,
              start: 32.w,
              end: 32.w,
              bottom: 32.h,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, localizations),
              SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 16.h : 20.h,
              ),
              _buildStatsSection(context, stats, isDark: isDark),
              SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h,
              ),
              _buildSearchBar(context, ref, localizations),
              SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h,
              ),
              _buildCompanyList(
                context,
                companies,
                localizations,
                isDark: isDark,
              ),
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
          decoration: BoxDecoration(
            color: const Color(0xFF615FFF),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: SvgIconWidget(
              assetPath: 'assets/icons/company_icon.svg',
              size: 24.sp,
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
                localizations.companyManagement,
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 22.sp,
                  fontWeight: FontWeight.w700,
                  color:
                      Theme.of(context).textTheme.titleLarge?.color ??
                      context.themeTextPrimary,
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
        GestureDetector(
          onTap: () {
            AddCompanyDialog.show(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF5E4BFF),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5E4BFF).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgIconWidget(
                  assetPath: 'assets/icons/add_new_icon_figma.svg',
                  size: 18.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Text(
                  localizations.addCompany,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    List<_StatCardData> stats, {
    required bool isDark,
  }) {
    final gap = 16.w;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.getResponsiveColumns(
          context,
          mobile: 1,
          tablet: 2,
          web: 4,
        );
        final totalSpacing = gap * (columns - 1);
        final width = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - totalSpacing) / columns
            : double.infinity;

        return Wrap(
          spacing: gap,
          runSpacing: 12.h,
          children: stats.map((stat) {
            return SizedBox(
              width: columns == 1 ? double.infinity : width,
              child: _StatCard(data: stat, isDark: isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSearchBar(
      BuildContext context,
      WidgetRef ref,
      AppLocalizations localizations,
      ) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackground : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark
              ? AppColors.inputBorderDark
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: ClipRRect( // 🔑 FIX
        borderRadius: BorderRadius.circular(10.r),
        child: TextField(
          onChanged: (value) =>
          ref.read(companySearchQueryProvider.notifier).state = value,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor:
            isDark ? AppColors.cardBackground : Colors.white,
            border: InputBorder.none,
            hintText: localizations.searchCompaniesPlaceholder,
            hintStyle: TextStyle(
              color: context.themeTextPlaceholder,
              fontSize: 14.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
              child: SvgIconWidget(
                assetPath: 'assets/icons/search_icon.svg',
                size: 20.sp,
                color: context.themeTextSecondary,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 0,
              minWidth: 0,
            ),
          ),
          style: TextStyle(
            color: context.themeTextPrimary,
            fontSize: 14.sp,
          ),
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
        final columns = ResponsiveHelper.getResponsiveColumns(
          context,
          mobile: 1,
          tablet: 2,
          web: 2,
        );
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
              child: _CompanyCard(
                company: company,
                localizations: localizations,
                isDark: isDark,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final String iconPath;
  final Color iconColor;
  final Color iconBackground;

  const _StatCardData({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.iconColor,
    required this.iconBackground,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;
  final bool isDark;

  const _StatCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.themeCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: context.themeTextSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: context.themeTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: data.iconBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: SvgIconWidget(
                assetPath: data.iconPath,
                size: 24.sp,
                color: data.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyOverview company;
  final AppLocalizations localizations;
  final bool isDark;

  const _CompanyCard({
    required this.company,
    required this.localizations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CompanyDetailsDialog.show(context, company),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: context.themeCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.themeCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
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
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgIconWidget(
                    assetPath: 'assets/icons/company_stat_icon.svg',
                    size: 20.sp,
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
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: context.themeTextPrimary,
                      ),
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
                  AddCompanyDialog.show(
                    context,
                    isEditMode: true,
                    initialData: {
                      'companyCode': company.entityCode,
                      'status': company.isActive ? 'Active' : 'Inactive',
                      'nameEn': company.name,
                      'nameAr': company.nameArabic,
                      'registrationNumber': company.registrationNumber,
                      'industry': company.industry,
                      'phone': company.phone,
                      'email': company.email,
                      'totalEmployees': company.employees.toString(),
                    },
                  );
                },
              ),
              SizedBox(width: 8.w),
              _ActionIcon(
                assetPath: 'assets/icons/delete_icon_red.svg',
                description: localizations.delete,
                iconColor: AppColors.deleteIconRed,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _Badge(
                label: company.entityCode,
                backgroundColor: const Color(0xFFF3F4F6),
              ),
              _Badge(
                label: localizations.active,
                backgroundColor: isDark
                    ? AppColors.successBgDark
                    : const Color(0xFFDCFCE7),
                textColor: isDark
                    ? AppColors.successTextDark
                    : AppColors.success,
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
                child: _buildInfoRow(
                  context,
                  assetPath: 'assets/icons/financial_icon.svg',
                  value: company.industry,
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
                  assetPath: 'assets/icons/phone_icon.svg',
                  value: company.phone,
                ),
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

  Widget _buildInfoRow(
    BuildContext context, {
    String? assetPath,
    IconData? icon,
    required String value,
  }) {
    return Row(
      children: [
        if (assetPath != null)
          SvgIconWidget(
            assetPath: assetPath,
            size: 18.sp,
            color: context.themeTextSecondary,
          )
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

  const _ActionIcon({
    required this.assetPath,
    required this.description,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: context.themeCardBackground,
        ),
        child: Center(
          child: SvgIconWidget(
            assetPath: assetPath,
            size: 18.sp,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color? textColor;

  const _Badge({
    required this.label,
    required this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? context.themeTextSecondary,
        ),
      ),
    );
  }
}
