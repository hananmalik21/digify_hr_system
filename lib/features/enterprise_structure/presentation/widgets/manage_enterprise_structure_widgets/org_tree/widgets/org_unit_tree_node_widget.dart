import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrgUnitTreeNodeWidget extends StatelessWidget {
  final OrgUnitTreeNode node;
  final Set<String> expandedNodes;
  final ValueChanged<String> onToggle;
  final bool isDark;
  final int level;

  const OrgUnitTreeNodeWidget({
    super.key,
    required this.node,
    required this.expandedNodes,
    required this.onToggle,
    required this.isDark,
    required this.level,
  });

  String _getLevelCodeIcon(String levelCode) {
    switch (levelCode.toUpperCase()) {
      case 'COMPANY':
        return Assets.icons.companyTreeIcon.path;
      case 'DIVISION':
        return Assets.icons.divisionTreeIcon.path;
      case 'BUSINESS_UNIT':
        return Assets.icons.businessUnitTreeIcon.path;
      case 'DEPARTMENT':
        return Assets.icons.departmentTreeIcon.path;
      case 'SECTION':
        return Assets.icons.sectionTreeIcon.path;
      default:
        return Assets.icons.companyTreeIcon.path;
    }
  }

  Color _getLevelCodeIconBg(String levelCode, bool isDark) {
    switch (levelCode.toUpperCase()) {
      case 'COMPANY':
        return isDark ? AppColors.purpleBgDark : const Color(0xFFF3E8FF);
      case 'DIVISION':
        return isDark ? AppColors.infoBgDark : const Color(0xFFDBEAFE);
      case 'BUSINESS_UNIT':
        return isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7);
      case 'DEPARTMENT':
        return isDark ? AppColors.warningBgDark : const Color(0xFFFFEDD4);
      case 'SECTION':
        return isDark ? AppColors.grayBgDark : const Color(0xFFF3F4F6);
      default:
        return isDark ? AppColors.grayBgDark : const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isTablet = ResponsiveHelper.isTablet(context);
    final isExpanded = expandedNodes.contains(node.orgUnitId);
    final hasChildren = node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 10.w : 12.w, vertical: 8.h),
          child: Row(
            children: [
              SizedBox(
                width: isTablet ? 22.w : 24.w,
                height: isTablet ? 22.h : 24.h,
                child: hasChildren
                    ? GestureDetector(
                        onTap: () => onToggle(node.orgUnitId),
                        child: Icon(
                          isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                          size: isTablet ? 18.sp : 16.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Gap(isTablet ? 6.w : 8.w),
              _buildIconContainer(isDark, isTablet ? 30.w : 32.w),
              Gap(isTablet ? 6.w : 8.w),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        node.displayName,
                        style: TextStyle(
                          fontSize: isTablet ? 14.5.sp : 15.4.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                          height: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (node.orgUnitNameAr.isNotEmpty) ...[
                      Gap(isTablet ? 6.w : 8.w),
                      Flexible(
                        child: Text(
                          '(${node.orgUnitNameAr})',
                          style: TextStyle(
                            fontSize: isTablet ? 13.sp : 14.sp,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                          ),
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    Gap(isTablet ? 6.w : 8.w),
                    _buildCodeBadge(isDark, isTablet: isTablet),
                    Gap(isTablet ? 6.w : 8.w),
                    _buildStatusBadge(localizations, isDark, isTablet: isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (hasChildren && isExpanded)
          Padding(
            padding: EdgeInsetsDirectional.only(start: isTablet ? 22.w : 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.children.map((child) {
                return OrgUnitTreeNodeWidget(
                  node: child,
                  expandedNodes: expandedNodes,
                  onToggle: onToggle,
                  isDark: isDark,
                  level: level + 1,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildIconContainer(bool isDark, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getLevelCodeIconBg(node.levelCode, isDark),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Center(
        child: DigifyAsset(
          assetPath: _getLevelCodeIcon(node.levelCode),
          width: size / 2,
          height: size / 2,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
        ),
      ),
    );
  }

  Widget _buildCodeBadge(bool isDark, {bool isTablet = false}) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 6.w : 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        node.orgUnitCode,
        style: TextStyle(
          fontSize: isTablet ? 11.sp : 12.sp,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AppLocalizations localizations, bool isDark, {bool isTablet = false}) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 6.w : 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: node.isActive
            ? (isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7))
            : (isDark ? AppColors.grayBgDark : AppColors.grayBg),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        node.isActive ? localizations.active : localizations.inactive,
        style: TextStyle(
          fontSize: isTablet ? 11.sp : 11.8.sp,
          color: node.isActive
              ? (isDark ? AppColors.successTextDark : const Color(0xFF008236))
              : (isDark ? AppColors.grayTextDark : AppColors.grayText),
        ),
      ),
    );
  }
}
