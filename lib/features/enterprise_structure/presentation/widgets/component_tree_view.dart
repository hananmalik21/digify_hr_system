import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_tree_node.dart'
    show ComponentTreeNodeWidget;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tree view widget for displaying hierarchical component structure
class ComponentTreeView extends ConsumerWidget {
  final Function(ComponentValue component)? onView;
  final Function(ComponentValue component)? onEdit;
  final Function(ComponentValue component)? onDelete;

  const ComponentTreeView({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final treeNodes = ref.read(componentValuesProvider.notifier).buildTreeStructure();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and expand/collapse buttons
          Container(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: EdgeInsetsDirectional.all(16.w),
              tablet: EdgeInsetsDirectional.all(20.w),
              web: EdgeInsetsDirectional.all(24.w),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  width: 1,
                ),
              ),
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.organizationalTreeStructure,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF101828),
                          height: 24 / 15.4,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ref.read(componentValuesProvider.notifier).expandAll();
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardBackgroundGreyDark
                                      : AppColors.cardBackgroundGrey,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Center(
                                  child: Text(
                                    localizations.expandAll,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : const Color(0xFF364153),
                                      height: 24 / 15.1,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ref.read(componentValuesProvider.notifier).collapseAll();
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardBackgroundGreyDark
                                      : AppColors.cardBackgroundGrey,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Center(
                                  child: Text(
                                    localizations.collapseAll,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : const Color(0xFF364153),
                                      height: 24 / 15.1,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.organizationalTreeStructure,
                        style: TextStyle(
                          fontSize: isTablet ? 14.5.sp : 15.4.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF101828),
                          height: 24 / 15.4,
                          letterSpacing: 0,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.read(componentValuesProvider.notifier).expandAll();
                            },
                            child: Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: isTablet ? 12.w : 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardBackgroundGreyDark
                                    : AppColors.cardBackgroundGrey,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                localizations.expandAll,
                                style: TextStyle(
                                  fontSize: isTablet ? 14.sp : 15.1.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF364153),
                                  height: 24 / 15.1,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              ref.read(componentValuesProvider.notifier).collapseAll();
                            },
                            child: Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: isTablet ? 12.w : 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardBackgroundGreyDark
                                    : AppColors.cardBackgroundGrey,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                localizations.collapseAll,
                                style: TextStyle(
                                  fontSize: isTablet ? 14.sp : 15.1.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF364153),
                                  height: 24 / 15.1,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          // Tree content
          Container(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: EdgeInsetsDirectional.all(12.w),
              tablet: EdgeInsetsDirectional.all(14.w),
              web: EdgeInsetsDirectional.all(17.w),
            ),
            constraints: BoxConstraints(
              minHeight: isMobile ? 300.h : (isTablet ? 350.h : 400.h),
            ),
            child: treeNodes.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        localizations.noComponentsFound,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: treeNodes.map((node) {
                      return ComponentTreeNodeWidget(
                        node: node,
                        onView: onView,
                        onEdit: onEdit,
                        onDelete: onDelete,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

