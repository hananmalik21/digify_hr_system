import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/active_structure_card_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/header_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/stats_cards_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/structure_configurations_header_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/structures_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageEnterpriseStructureScreen extends ConsumerStatefulWidget {
  const ManageEnterpriseStructureScreen({super.key});

  @override
  ConsumerState<ManageEnterpriseStructureScreen> createState() =>
      _ManageEnterpriseStructureScreenState();
}

class _ManageEnterpriseStructureScreenState
    extends ConsumerState<ManageEnterpriseStructureScreen> {
  /// Provider for structure list
  final structureListProvider =
  StateNotifierProvider.autoDispose<StructureListNotifier, StructureListState>(
          (ref) {
        final getStructureListUseCase = ref.watch(getStructureListUseCaseProvider);
        return StructureListNotifier(getStructureListUseCase: getStructureListUseCase);
      });
  final saveEnterpriseStructureProvider =
      StateNotifierProvider.autoDispose<
        SaveEnterpriseStructureNotifier,
        SaveEnterpriseStructureState
      >((ref) {
        final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
        return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
      });

  @override
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final listState = ref.watch(structureListProvider);
    final isRefreshing = listState.isLoading && listState.structures.isNotEmpty;

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
                  HeaderWidget(localizations: localizations),
                  SizedBox(height: isMobile ? 16.h : 24.h),

                  ActiveStructureCardWidget(
                    localizations: localizations,
                    isDark: isDark,
                  ),
                  SizedBox(height: isMobile ? 16.h : 24.h),

                  StatsCardsWidget(
                    localizations: localizations,
                    isDark: isDark,
                    structureListProvider: structureListProvider,
                  ),
                  SizedBox(height: isMobile ? 16.h : 24.h),

                  StructureConfigurationsHeaderWidget(
                    localizations: localizations,
                    isDark: isDark,
                    structureListProvider: structureListProvider,
                  ),
                  SizedBox(height: isMobile ? 12.h : 16.h),

                  StructuresListWidget(
                    localizations: localizations,
                    isDark: isDark,
                    structureListProvider: structureListProvider,
                    saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
                  ),
                ],
              ),
            ),

            // ✅ Loading overlay
            if (isRefreshing)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: isDark ? Colors.black : Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localizations.components}: ${components.toString()}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${localizations.employees}: ${employees.toString()}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.7,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${localizations.created}: $created',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${localizations.modified}: $modified',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
        ],
      );
    }
    
    return Row(
      children: [
        Expanded(
          child: Text(
            '${localizations.components}: ${components.toString()}',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.employees}: ${employees.toString()}',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.7.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.7,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.created}: $created',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.modified}: $modified',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
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
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
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
              description: description, provider: structureListProvider,
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
              provider: structureListProvider

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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Calculate padding based on button type to match Figma exactly
    final isActivate = label == localizations.activate;
    final isView = label == localizations.view;
    final isEdit = label == localizations.edit;
    final isDuplicate = label == localizations.duplicate;
    final isDelete = label == localizations.delete;
    
    double startPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);
    double endPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);
    
    if (!isMobile) {
      if (isActivate) {
        endPadding = isTablet ? 22.w : 25.82.w;
      } else if (isView) {
        endPadding = isTablet ? 42.w : 49.51.w;
      } else if (isEdit) {
        endPadding = isTablet ? 48.w : 56.65.w;
      } else if (isDuplicate) {
        startPadding = isTablet ? 14.w : 16.w;
        endPadding = isTablet ? 14.w : 16.w;
      } else if (isDelete) {
        endPadding = isTablet ? 32.w : 37.62.w;
      }
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: startPadding,
          end: endPadding,
          top: isMobile ? 10.h : 8.h,
          bottom: isMobile ? 10.h : 8.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            SvgIconWidget(
              assetPath: icon,
              size: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
              color: textColor,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isMobile 
                      ? 13.sp 
                      : (isActivate || isView 
                          ? (isTablet ? 14.sp : 15.1.sp) 
                          : (isDelete 
                              ? (isTablet ? 14.5.sp : 15.3.sp) 
                              : (isTablet ? 14.5.sp : 15.4.sp))),
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 24 / 15.1,
                  letterSpacing: 0,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.start,

              ),
            )],
        ),
      ),
    );
  }
}
