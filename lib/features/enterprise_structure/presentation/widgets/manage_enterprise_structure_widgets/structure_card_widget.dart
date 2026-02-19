import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/action_buttons_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/hierarchy_levels_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/structure_metrics_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final borderColor = isActive ? AppColors.success : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final cardPadding = ResponsiveHelper.getResponsivePadding(
      context,
      mobile: EdgeInsetsDirectional.all(isActive ? 16.w : 18.w),
      tablet: EdgeInsetsDirectional.all(isActive ? 20.w : 22.w),
      web: EdgeInsetsDirectional.all(isActive ? 24.w : 26.w),
    );

    return Container(
      padding: cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile ? _buildMobileContent(context, isTablet) : _buildDesktopContent(context, isTablet),
          if (showInfoMessage) _buildInfoBanner(context),
        ],
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleAndBadge(context, isTablet),
        Gap(8.h),
        _buildDescription(context, isTablet),
        Padding(
          padding: EdgeInsetsDirectional.only(top: 8.h),
          child: _buildHierarchy(),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(top: 8.h),
          child: _buildMetrics(),
        ),
        Gap(16.h),
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
    );
  }

  Widget _buildDesktopContent(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndBadge(context, isTablet),
              Gap(8.h),
              _buildDescription(context, isTablet),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 8.h),
                child: _buildHierarchy(),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 8.h),
                child: _buildMetrics(),
              ),
            ],
          ),
        ),
        Gap(isTablet ? 16.w : 24.w),
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
    );
  }

  Widget _buildTitleAndBadge(BuildContext context, bool isTablet) {
    final titleStyle = (isTablet ? context.titleSmall : context.titleMedium).copyWith(
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final badgeTextStyle = context.labelSmall.copyWith(
      fontWeight: FontWeight.w400,
      color: isActive ? AppColors.cardBackground : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
    );
    final badgeBg = isActive
        ? AppColors.greenButton
        : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey);

    return Row(
      children: [
        Expanded(
          child: Text(title, style: titleStyle, overflow: TextOverflow.ellipsis),
        ),
        Gap(isTablet ? 10.w : 12.w),
        Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 10.w : 12.w, vertical: 4.h),
          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(9999.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isActive) ...[
                DigifyAsset(
                  assetPath: Assets.icons.activeCheckIcon.path,
                  width: isTablet ? 11 : 12,
                  height: isTablet ? 11 : 12,
                  color: AppColors.cardBackground,
                ),
                Gap(4.w),
              ],
              Text(isActive ? localizations.active : localizations.notUsed, style: badgeTextStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, bool isTablet) {
    return Text(
      description,
      style: context.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
    );
  }

  Widget _buildHierarchy() {
    return HierarchyLevelsWidget(localizations: localizations, isDark: isDark, levels: levels, levelCount: levelCount);
  }

  Widget _buildMetrics() {
    return StructureMetricsWidget(
      localizations: localizations,
      isDark: isDark,
      components: components,
      employees: employees,
      created: created,
      modified: modified,
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 17.h),
      padding: EdgeInsetsDirectional.only(top: 17.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? AppColors.successBorderDark : AppColors.greenBorder, width: 1)),
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
              color: isDark ? AppColors.successTextDark : AppColors.successText,
            ),
          ),
          Gap(8.w),
          Expanded(
            child: Text(
              localizations.currentlyActiveStructureMessage,
              style: context.bodySmall.copyWith(color: isDark ? AppColors.successTextDark : AppColors.successText),
            ),
          ),
        ],
      ),
    );
  }
}
