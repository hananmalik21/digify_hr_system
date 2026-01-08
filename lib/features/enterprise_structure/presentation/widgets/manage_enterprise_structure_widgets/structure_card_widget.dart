import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/action_buttons_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/hierarchy_levels_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/structure_metrics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Structure card widget
class StructureCardWidget extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final String title;
  final String description;
  final bool isActive;
  final List<String> levels;
  final int levelCount;
  final int components;
  final int employees;
  final String created;
  final String modified;
  final bool showInfoMessage;
  final List<StructureLevelItem>? structureLevels;
  final int? enterpriseId;
  final String? structureId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>
  saveEnterpriseStructureProvider;

  const StructureCardWidget({
    super.key,
    required this.context,
    required this.localizations,
    required this.isDark,
    required this.title,
    required this.description,
    required this.isActive,
    required this.levels,
    required this.levelCount,
    required this.components,
    required this.employees,
    required this.created,
    required this.modified,
    required this.showInfoMessage,
    this.structureLevels,
    this.enterpriseId,
    this.structureId,
    required this.structureListProvider,
    required this.saveEnterpriseStructureProvider,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? const Color(0xFF00C950)
        : (isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB));
    final borderWidth = isActive ? 2.0 : 2.0;
    final shadowColor = isActive ? const Color(0xFFDCFCE7) : Colors.black.withValues(alpha: 0.1);

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(isActive ? 16.w : 18.w),
        tablet: EdgeInsetsDirectional.all(isActive ? 20.w : 22.w),
        web: EdgeInsetsDirectional.all(isActive ? 24.w : 26.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: shadowColor, blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                              height: 28 / 17.4,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF00A63E)
                                : (isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(9999.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isActive) ...[
                                DigifyAsset(
                                  assetPath: Assets.icons.activeCheckIcon.path,
                                  width: 10,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.w),
                              ],
                              Text(
                                isActive ? localizations.active : localizations.notUsed,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isActive
                                      ? Colors.white
                                      : (isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565)),
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
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                        height: 24 / 15.3,
                        letterSpacing: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 8.h),
                      child: HierarchyLevelsWidget(
                        localizations: localizations,
                        isDark: isDark,
                        levels: levels,
                        levelCount: levelCount,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 8.h),
                      child: StructureMetricsWidget(
                        localizations: localizations,
                        isDark: isDark,
                        components: components,
                        employees: employees,
                        created: created,
                        modified: modified,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ActionButtonsWidget(
                      context: context,
                      localizations: localizations,
                      isDark: isDark,
                      isActive: isActive,
                      title: title,
                      description: description,
                      structureLevels: structureLevels,
                      enterpriseId: enterpriseId,
                      structureId: structureId,
                      structureIsActive: isActive,
                      structureListProvider: structureListProvider,
                      saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16.sp : 17.4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                                    height: 28 / 17.4,
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: isTablet ? 10.w : 12.w),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: isTablet ? 10.w : 12.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF00A63E)
                                      : (isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6)),
                                  borderRadius: BorderRadius.circular(9999.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isActive) ...[
                                      DigifyAsset(
                                        assetPath: Assets.icons.activeCheckIcon.path,
                                        width: isTablet ? 11 : 12,
                                        height: isTablet ? 11 : 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4.w),
                                    ],
                                    Text(
                                      isActive ? localizations.active : localizations.notUsed,
                                      style: TextStyle(
                                        fontSize: isTablet ? 11.sp : 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: isActive
                                            ? Colors.white
                                            : (isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565)),
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
                              fontSize: isTablet ? 14.sp : 15.3.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                              height: 24 / 15.3,
                              letterSpacing: 0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 8.h),
                            child: HierarchyLevelsWidget(
                              localizations: localizations,
                              isDark: isDark,
                              levels: levels,
                              levelCount: levelCount,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 8.h),
                            child: StructureMetricsWidget(
                              localizations: localizations,
                              isDark: isDark,
                              components: components,
                              employees: employees,
                              created: created,
                              modified: modified,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isTablet ? 16.w : 24.w),
                    ActionButtonsWidget(
                      context: context,
                      localizations: localizations,
                      isDark: isDark,
                      isActive: isActive,
                      title: title,
                      description: description,
                      structureLevels: structureLevels,
                      enterpriseId: enterpriseId,
                      structureId: structureId,
                      structureIsActive: isActive,
                      structureListProvider: structureListProvider,
                      saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
                    ),
                  ],
                ),
          if (showInfoMessage) ...[
            Container(
              margin: EdgeInsetsDirectional.only(top: 17.h),
              padding: EdgeInsetsDirectional.only(top: 17.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF), width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 2.h),
                    child: DigifyAsset(
                      assetPath: Assets.icons.infoIconGreen.path,
                      width: 16,
                      height: 16,
                      color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      localizations.currentlyActiveStructureMessage,
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
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
}
