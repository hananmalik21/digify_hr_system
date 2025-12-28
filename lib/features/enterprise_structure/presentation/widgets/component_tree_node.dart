import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/action_button_group.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Individual tree node widget
class ComponentTreeNodeWidget extends ConsumerWidget {
  final ComponentTreeNode node;
  final Function(ComponentValue component)? onView;
  final Function(ComponentValue component)? onEdit;
  final Function(ComponentValue component)? onDelete;

  const ComponentTreeNodeWidget({
    super.key,
    required this.node,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  String _getComponentTypeIcon(ComponentType type) {
    switch (type) {
      case ComponentType.company:
        return 'assets/icons/company_tree_icon.svg';
      case ComponentType.division:
        return 'assets/icons/division_tree_icon.svg';
      case ComponentType.businessUnit:
        return 'assets/icons/business_unit_tree_icon.svg';
      case ComponentType.department:
        return 'assets/icons/department_tree_icon.svg';
      case ComponentType.section:
        return 'assets/icons/section_tree_icon.svg';
    }
  }

  Color _getComponentTypeIconBg(ComponentType type, bool isDark) {
    switch (type) {
      case ComponentType.company:
        return isDark
            ? AppColors.purpleBgDark
            : const Color(0xFFF3E8FF); // #f3e8ff
      case ComponentType.division:
        return isDark
            ? AppColors.infoBgDark
            : const Color(0xFFDBEAFE); // #dbeafe
      case ComponentType.businessUnit:
        return isDark
            ? AppColors.successBgDark
            : const Color(0xFFDCFCE7); // #dcfce7
      case ComponentType.department:
        return isDark
            ? AppColors.warningBgDark
            : const Color(0xFFFFEDD4); // #ffedd4
      case ComponentType.section:
        return isDark
            ? AppColors.grayBgDark
            : const Color(0xFFF3F4F6); // #f3f4f6
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final state = ref.watch(componentValuesProvider);
    final isExpanded = state.expandedNodes.contains(node.component.id);
    final hasChildren = node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node row
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: isMobile ? 8.w : (isTablet ? 10.w : 12.w),
            vertical: isMobile ? 10.h : 8.h,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Expand/collapse icon
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: hasChildren
                              ? GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(componentValuesProvider.notifier)
                                        .toggleNodeExpansion(node.component.id);
                                  },
                                  child: Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_right,
                                    size: 18.sp,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondary,
                                  ),
                                )
                              : SizedBox(width: 20.w),
                        ),
                        SizedBox(width: 6.w),
                        // Component type icon
                        Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: _getComponentTypeIconBg(node.component.type, isDark),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: SvgIconWidget(
                              assetPath: _getComponentTypeIcon(node.component.type),
                              size: 14.sp,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF101828),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Component name
                        Expanded(
                          child: Text(
                            node.component.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF101828),
                              height: 24 / 15.4,
                              letterSpacing: 0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        SizedBox(width: 26.w), // Align with icon
                        Expanded(
                          child: Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: [
                              // Arabic name in parentheses
                              Text(
                                '(${node.component.arabicName})',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : const Color(0xFF6A7282),
                                  height: 20 / 14,
                                  letterSpacing: 0,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              // Code badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardBackgroundGreyDark
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.component.code,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF4A5565),
                                    height: 16 / 12,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              // Status badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: node.component.status
                                      ? (isDark
                                          ? AppColors.successBgDark
                                          : const Color(0xFFDCFCE7))
                                      : (isDark
                                          ? AppColors.grayBgDark
                                          : AppColors.grayBg),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.component.status
                                      ? localizations.active
                                      : localizations.inactive,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: node.component.status
                                        ? (isDark
                                            ? AppColors.successTextDark
                                            : const Color(0xFF008236))
                                        : (isDark
                                            ? AppColors.grayTextDark
                                            : AppColors.grayText),
                                    height: 16 / 11.8,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Manager and location info
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 26.w),
                      child: Text(
                        '${localizations.manager}: ${node.component.managerId ?? '-'} • ${node.component.location ?? '-'}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF4A5565),
                          height: 20 / 13.5,
                          letterSpacing: 0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Action buttons
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 26.w),
                      child: ActionButtonGroup(
                        onView: onView != null
                            ? () => onView!(node.component)
                            : null,
                        onEdit: onEdit != null
                            ? () => onEdit!(node.component)
                            : null,
                        onDelete: onDelete != null
                            ? () => onDelete!(node.component)
                            : null,
                        viewTooltip: localizations.view,
                        editTooltip: localizations.edit,
                        deleteTooltip: localizations.delete,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    // Expand/collapse icon
                    SizedBox(
                      width: isTablet ? 22.w : 24.w,
                      height: isTablet ? 22.h : 24.h,
                      child: hasChildren
                          ? GestureDetector(
                              onTap: () {
                                ref
                                    .read(componentValuesProvider.notifier)
                                    .toggleNodeExpansion(node.component.id);
                              },
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                                size: isTablet ? 18.sp : 16.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                            )
                          : SizedBox(width: isTablet ? 22.w : 24.w),
                    ),
                    SizedBox(width: isTablet ? 6.w : 8.w),
                    // Component type icon
                    Container(
                      width: isTablet ? 30.w : 32.w,
                      height: isTablet ? 30.h : 32.h,
                      decoration: BoxDecoration(
                        color: _getComponentTypeIconBg(node.component.type, isDark),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: SvgIconWidget(
                          assetPath: _getComponentTypeIcon(node.component.type),
                          size: isTablet ? 15.sp : 16.sp,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF101828),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 6.w : 8.w),
                    // Component info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Name
                              Flexible(
                                child: Text(
                                  node.component.name,
                                  style: TextStyle(
                                    fontSize: isTablet ? 14.5.sp : 15.4.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : const Color(0xFF101828),
                                    height: 24 / 15.4,
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: isTablet ? 6.w : 8.w),
                              // Arabic name in parentheses
                              Flexible(
                                child: Text(
                                  '(${node.component.arabicName})',
                                  style: TextStyle(
                                    fontSize: isTablet ? 13.sp : 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF6A7282),
                                    height: 20 / 14,
                                    letterSpacing: 0,
                                  ),
                                  textDirection: TextDirection.rtl,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: isTablet ? 6.w : 8.w),
                              // Code badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: isTablet ? 6.w : 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardBackgroundGreyDark
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.component.code,
                                  style: TextStyle(
                                    fontSize: isTablet ? 11.sp : 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF4A5565),
                                    height: 16 / 12,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              SizedBox(width: isTablet ? 6.w : 8.w),
                              // Status badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: isTablet ? 6.w : 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: node.component.status
                                      ? (isDark
                                          ? AppColors.successBgDark
                                          : const Color(0xFFDCFCE7))
                                      : (isDark
                                          ? AppColors.grayBgDark
                                          : AppColors.grayBg),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.component.status
                                      ? localizations.active
                                      : localizations.inactive,
                                  style: TextStyle(
                                    fontSize: isTablet ? 11.sp : 11.8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: node.component.status
                                        ? (isDark
                                            ? AppColors.successTextDark
                                            : const Color(0xFF008236))
                                        : (isDark
                                            ? AppColors.grayTextDark
                                            : AppColors.grayText),
                                    height: 16 / 11.8,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Manager and location info
                          Text(
                            '${localizations.manager}: ${node.component.managerId ?? '-'} • ${node.component.location ?? '-'}',
                            style: TextStyle(
                              fontSize: isTablet ? 12.5.sp : 13.5.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF4A5565),
                              height: 20 / 13.5,
                              letterSpacing: 0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isTablet ? 6.w : 8.w),
                    // Action buttons
                    ActionButtonGroup(
                      onView: onView != null
                          ? () => onView!(node.component)
                          : null,
                      onEdit: onEdit != null
                          ? () => onEdit!(node.component)
                          : null,
                      onDelete: onDelete != null
                          ? () => onDelete!(node.component)
                          : null,
                      viewTooltip: localizations.view,
                      editTooltip: localizations.edit,
                      deleteTooltip: localizations.delete,
                    ),
                  ],
                ),
        ),
        // Children nodes
        if (hasChildren && isExpanded)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: isMobile ? 20.w : (isTablet ? 22.w : 24.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.children.map((child) {
                return ComponentTreeNodeWidget(
                  node: child,
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

