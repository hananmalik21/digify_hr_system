import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageEnterpriseStructureScreen extends ConsumerWidget {
  const ManageEnterpriseStructureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
            top: 88.h,
            start: 24.w,
            end: 24.w,
            bottom: 24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, localizations, isDark),
              SizedBox(height: 24.h),
              _buildActiveStructureCard(context, localizations, isDark),
              SizedBox(height: 24.h),
              _buildStatsCards(context, localizations, isDark),
              SizedBox(height: 24.h),
              _buildStructureConfigurationsHeader(
                  context, localizations, isDark),
              SizedBox(height: 16.h),
              _buildStructureCard(
                context,
                localizations,
                isDark,
                title: localizations.standardKuwaitCorporateStructure,
                description: localizations.traditionalHierarchicalStructure,
                isActive: true,
                levels: ['Company', 'Division', 'Business Unit', 'Department', 'Section'],
                levelCount: 5,
                components: 58,
                employees: 450,
                created: '2024-01-15',
                modified: '2024-12-01',
                showInfoMessage: true,
              ),
              SizedBox(height: 16.h),
              _buildStructureCard(
                context,
                localizations,
                isDark,
                title: localizations.simplifiedStructure,
                description: localizations.streamlinedStructure,
                isActive: false,
                levels: ['Company', 'Division', 'Department'],
                levelCount: 3,
                components: 0,
                employees: 0,
                created: '2024-06-20',
                modified: '2024-06-20',
                showInfoMessage: false,
              ),
              SizedBox(height: 16.h),
              _buildStructureCard(
                context,
                localizations,
                isDark,
                title: localizations.flatOrganizationStructure,
                description: localizations.minimalHierarchy,
                isActive: false,
                levels: ['Company', 'Department'],
                levelCount: 2,
                components: 0,
                employees: 0,
                created: '2024-09-10',
                modified: '2024-09-10',
                showInfoMessage: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            Color(0xFF9810FA),
            Color(0xFF155DFC),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.manageEnterpriseStructure,
                  style: TextStyle(
                    fontSize: 22.7.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 32 / 22.7,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.configureManageHierarchy,
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFF3E8FF),
                    height: 24 / 15.3,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.configureManageHierarchyAr,
                  style: TextStyle(
                    fontSize: 14.sp,
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
          SizedBox(width: 16.w),
          SvgIconWidget(
            assetPath: 'assets/icons/manage_enterprise_icon.svg',
            size: 32.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStructureCard(
      BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
        border: Border.all(
          color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 2.h),
            child: SvgIconWidget(
              assetPath: 'assets/icons/info_icon_green.svg',
              size: 24.sp,
              color: isDark
                  ? AppColors.successTextDark
                  : const Color(0xFF0D542B),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      localizations.currentlyActiveStructure,
                      style: TextStyle(
                        fontSize: 15.6.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF0D542B),
                        height: 24 / 15.6,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      child: Text(
                        localizations.active,
                        style: TextStyle(
                          fontSize: 11.8.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 16 / 11.8,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text.rich(
                  TextSpan(
                    text: localizations.standardKuwaitCorporateStructure,
                    style: TextStyle(
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.successTextDark
                          : const Color(0xFF016630),
                      height: 24 / 15.4,
                      letterSpacing: 0,
                    ),
                    children: [
                      TextSpan(
                        text: ' - ${localizations.traditionalHierarchicalStructure}',
                        style: TextStyle(
                          fontSize: 15.4.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.successTextDark
                              : const Color(0xFF016630),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      '5 ${localizations.activeLevels}',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF008236),
                        height: 20 / 13.5,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF008236),
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '58 ${localizations.components}',
                      style: TextStyle(
                        fontSize: 13.7.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF008236),
                        height: 20 / 13.7,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF008236),
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '450 ${localizations.employees}',
                      style: TextStyle(
                        fontSize: 13.7.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF008236),
                        height: 20 / 13.7,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
      BuildContext context, AppLocalizations localizations, bool isDark) {
    final cards = [
      _StatCard(
        label: localizations.totalStructures,
        value: '3',
        icon: 'assets/icons/total_structures_icon.svg',
        color: const Color(0xFF9810FA),
      ),
      _StatCard(
        label: localizations.activeStructure,
        value: '1',
        icon: 'assets/icons/active_structure_icon.svg',
        color: const Color(0xFF00A63E),
      ),
      _StatCard(
        label: localizations.componentsInUse,
        value: '58',
        icon: 'assets/icons/components_icon.svg',
        color: const Color(0xFF155DFC),
      ),
      _StatCard(
        label: localizations.employeesAssigned,
        value: '450',
        icon: 'assets/icons/employees_assigned_icon.svg',
        color: const Color(0xFFF54900),
      ),
    ];

    return Row(
      children: cards.map((card) {
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: card != cards.last ? 16.w : 0,
            ),
            child: _buildStatCard(context, card, isDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
      BuildContext context, _StatCard card, bool isDark) {
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
                card.value,
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

  Widget _buildStructureConfigurationsHeader(
      BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.structureConfigurations,
                  style: TextStyle(
                    fontSize: 15.6.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF101828),
                    height: 24 / 15.6,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.manageDifferentConfigurations,
                  style: TextStyle(
                    fontSize: 13.6.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : const Color(0xFF4A5565),
                    height: 20 / 13.6,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () {
              // TODO: Create new structure
            },
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF9810FA),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: GestureDetector(
                onTap: () {
                  EnterpriseStructureDialog.showCreate(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgIconWidget(
                      assetPath: 'assets/icons/create_new_structure_icon.svg',
                      size: 20.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      localizations.createNewStructure,
                      style: TextStyle(
                        fontSize: 15.3.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 24 / 15.3,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStructureCard(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark, {
    required String title,
    required String description,
    required bool isActive,
    required List<String> levels,
    required int levelCount,
    required int components,
    required int employees,
    required String created,
    required String modified,
    required bool showInfoMessage,
  }) {
    final borderColor = isActive
        ? const Color(0xFF00C950)
        : (isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB));
    final borderWidth = isActive ? 2.0 : 2.0;
    final shadowColor = isActive
        ? const Color(0xFFDCFCE7)
        : Colors.black.withValues(alpha: 0.1);

    return Container(
      padding: EdgeInsetsDirectional.all(isActive ? 24.w : 26.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: shadowColor,
            blurRadius: 2,
            offset: const Offset(0, -1),
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
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17.4.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF101828),
                            height: 28 / 17.4,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF00A63E)
                                : (isDark
                                    ? AppColors.cardBackgroundGreyDark
                                    : const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(9999.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isActive) ...[
                                SvgIconWidget(
                                  assetPath: 'assets/icons/active_check_icon.svg',
                                  size: 12.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.w),
                              ],
                              Text(
                                isActive ? localizations.active : localizations.notUsed,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isActive
                                      ? Colors.white
                                      : (isDark
                                          ? AppColors.textSecondaryDark
                                          : const Color(0xFF4A5565)),
                                  height: 16 / 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 15.3.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : const Color(0xFF4A5565),
                        height: 24 / 15.3,
                        letterSpacing: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 8.h),
                      child: _buildHierarchyLevels(context, localizations, isDark, levels, levelCount),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 8.h),
                      child: _buildStructureMetrics(
                          context, localizations, isDark, components, employees, created, modified),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              _buildActionButtons(
                context,
                localizations,
                isDark,
                isActive,
                title: title,
                description: description,
              ),
            ],
          ),
          if (showInfoMessage) ...[
            Container(
              margin: EdgeInsetsDirectional.only(top: 17.h),
              padding: EdgeInsetsDirectional.only(top: 17.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.successBorderDark
                        : const Color(0xFFB9F8CF),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 2.h),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/info_icon_green.svg',
                      size: 16.sp,
                      color: isDark
                          ? AppColors.successTextDark
                          : const Color(0xFF008236),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      localizations.currentlyActiveStructureMessage,
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.successTextDark
                            : const Color(0xFF008236),
                        height: 20 / 13.6,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHierarchyLevels(
      BuildContext context, AppLocalizations localizations, bool isDark, List<String> levels, int levelCount) {
    final levelLabels = {
      'Company': localizations.company,
      'Division': localizations.division,
      'Business Unit': localizations.businessUnit,
      'Department': localizations.department,
      'Section': localizations.section,
    };

    final levelIcons = {
      'Company': 'assets/icons/company_icon_purple.svg',
      'Division': 'assets/icons/division_icon_purple.svg',
      'Business Unit': 'assets/icons/business_unit_icon_purple.svg',
      'Department': 'assets/icons/department_icon_purple.svg',
      'Section': 'assets/icons/section_icon_purple.svg',
    };

    return Wrap(
      spacing: 8.w,
      runSpacing: 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          localizations.hierarchy,
          style: TextStyle(
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textTertiaryDark
                : const Color(0xFF6A7282),
            height: 20 / 13.7,
            letterSpacing: 0,
          ),
        ),
        ...levels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 9.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.purpleBgDark
                      : const Color(0xFFFAF5FF),
                  border: Border.all(
                    color: isDark
                        ? AppColors.purpleBorderDark
                        : const Color(0xFFE9D4FF),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgIconWidget(
                      assetPath: levelIcons[level] ?? '',
                      size: 14.sp,
                      color: isDark
                          ? AppColors.purpleTextDark
                          : const Color(0xFF59168B),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      levelLabels[level] ?? level,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.purpleTextDark
                            : const Color(0xFF59168B),
                        height: 16 / 12,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < levels.length - 1) ...[
                SizedBox(width: 8.w),
                Text(
                  '→',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textPlaceholderDark
                        : const Color(0xFF99A1AF),
                    height: 24 / 16,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ],
          );
        }),
        SizedBox(width: 8.w),
        Text(
          '($levelCount ${localizations.levels})',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textTertiaryDark
                : const Color(0xFF6A7282),
            height: 16 / 12,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStructureMetrics(
      BuildContext context,
      AppLocalizations localizations,
      bool isDark,
      int components,
      int employees,
      String created,
      String modified) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${localizations.components}: ${components.toString()}',
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.employees}: ${employees.toString()}',
            style: TextStyle(
              fontSize: 13.7.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.7,
              letterSpacing: 0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.created}: $created',
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.modified}: $modified',
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, AppLocalizations localizations, bool isDark, bool isActive, {
      required String title,
      required String description,
    }) {
    return Column(
      children: [
        if (!isActive)
          _buildActionButton(
            context,
            localizations,
            isDark,
            label: localizations.activate,
            icon: 'assets/icons/activate_icon.svg',
            backgroundColor: const Color(0xFF00A63E),
            textColor: Colors.white,
            onTap: () {
              // TODO: Activate structure
            },
          ),
        if (!isActive) SizedBox(height: 8.h),
        _buildActionButton(
          context,
          localizations,
          isDark,
          label: localizations.view,
          icon: 'assets/icons/view_icon_blue.svg',
          backgroundColor: isDark
              ? AppColors.infoBgDark
              : const Color(0xFFEFF6FF),
          textColor: AppColors.primary,
          onTap: () {
            EnterpriseStructureDialog.showView(
              context,
              structureName: title,
              description: description,
            );
          },
        ),
        SizedBox(height: 8.h),
        _buildActionButton(
          context,
          localizations,
          isDark,
          label: localizations.edit,
          icon: 'assets/icons/edit_icon_purple.svg',
          backgroundColor: isDark
              ? AppColors.purpleBgDark
              : const Color(0xFFFAF5FF),
          textColor: const Color(0xFF9810FA),
          onTap: () {
            final initialLevels = [
              HierarchyLevel(
                id: 'company',
                name: localizations.company,
                icon: 'assets/icons/company_icon_small.svg',
                level: 1,
                isMandatory: true,
                isActive: true,
                previewIcon: 'assets/icons/company_icon_preview.svg',
              ),
              HierarchyLevel(
                id: 'division',
                name: localizations.division,
                icon: 'assets/icons/division_icon_small.svg',
                level: 2,
                isMandatory: false,
                isActive: true,
                previewIcon: 'assets/icons/division_icon_preview.svg',
              ),
              HierarchyLevel(
                id: 'business_unit',
                name: localizations.businessUnit,
                icon: 'assets/icons/business_unit_icon_small.svg',
                level: 3,
                isMandatory: false,
                isActive: true,
                previewIcon: 'assets/icons/business_unit_icon_preview.svg',
              ),
              HierarchyLevel(
                id: 'department',
                name: localizations.department,
                icon: 'assets/icons/department_icon_small.svg',
                level: 4,
                isMandatory: false,
                isActive: true,
                previewIcon: 'assets/icons/department_icon_preview.svg',
              ),
              HierarchyLevel(
                id: 'section',
                name: localizations.section,
                icon: 'assets/icons/section_icon_small.svg',
                level: 5,
                isMandatory: false,
                isActive: true,
                previewIcon: 'assets/icons/section_icon_preview.svg',
              ),
            ];
            EnterpriseStructureDialog.showEdit(
              context,
              structureName: title,
              description: description,
              initialLevels: initialLevels,
            );
          },
        ),
        SizedBox(height: 8.h),
        _buildActionButton(
          context,
          localizations,
          isDark,
          label: localizations.duplicate,
          icon: 'assets/icons/duplicate_icon.svg',
          backgroundColor: isDark
              ? AppColors.cardBackgroundGreyDark
              : const Color(0xFFF9FAFB),
          textColor: isDark
              ? AppColors.textSecondaryDark
              : const Color(0xFF4A5565),
          onTap: () {
            // TODO: Duplicate structure
          },
        ),
        if (!isActive) ...[
          SizedBox(height: 8.h),
          _buildActionButton(
            context,
            localizations,
            isDark,
            label: localizations.delete,
            icon: 'assets/icons/delete_icon_red.svg',
            backgroundColor: isDark
                ? AppColors.errorBgDark
                : const Color(0xFFFEF2F2),
            textColor: AppColors.brandRed,
            onTap: () {
              // TODO: Delete structure
            },
          ),
        ],
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
    // Calculate padding based on button type to match Figma exactly
    final isActivate = label == localizations.activate;
    final isView = label == localizations.view;
    final isEdit = label == localizations.edit;
    final isDuplicate = label == localizations.duplicate;
    final isDelete = label == localizations.delete;
    
    double startPadding = 16.w;
    double endPadding = 16.w;
    
    if (isActivate) {
      endPadding = 25.82.w; // Match Figma: pl-[16px] pr-[25.82px]
    } else if (isView) {
      endPadding = 49.51.w; // Match Figma: pl-[16px] pr-[49.51px]
    } else if (isEdit) {
      endPadding = 56.65.w; // Match Figma: pl-[16px] pr-[56.65px]
    } else if (isDuplicate) {
      // Match Figma: px-[16px] (same on both sides)
      startPadding = 16.w;
      endPadding = 16.w;
    } else if (isDelete) {
      endPadding = 37.62.w; // Match Figma: pl-[16px] pr-[37.62px]
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: startPadding,
          end: endPadding,
          top: 8.h,
          bottom: 8.h,
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
              size: 16.sp,
              color: textColor,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: isActivate || isView ? 15.1.sp : (isDelete ? 15.3.sp : 15.4.sp),
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 24 / 15.1,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard {
  final String label;
  final String value;
  final String icon;
  final Color color;

  _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

