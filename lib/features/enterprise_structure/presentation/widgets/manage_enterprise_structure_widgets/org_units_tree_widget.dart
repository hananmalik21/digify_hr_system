import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_tree_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/org_unit_tree_node_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget to display org units tree view matching ComponentTreeView design
class OrgUnitsTreeWidget extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const OrgUnitsTreeWidget({
    super.key,
    required this.localizations,
    required this.isDark,
  });

  @override
  ConsumerState<OrgUnitsTreeWidget> createState() => _OrgUnitsTreeWidgetState();
}

class _OrgUnitsTreeWidgetState extends ConsumerState<OrgUnitsTreeWidget> {
  final Map<String, bool> _expandedNodes = {};

  void _toggleNode(String nodeId) {
    setState(() {
      _expandedNodes[nodeId] = !(_expandedNodes[nodeId] ?? false);
    });
  }

  void _expandAll(OrgUnitTree tree) {
    setState(() {
      void expandNode(OrgUnitTreeNode node) {
        if (node.children.isNotEmpty) {
          _expandedNodes[node.orgUnitId] = true;
          for (var child in node.children) {
            expandNode(child);
          }
        }
      }

      for (var rootNode in tree.tree) {
        expandNode(rootNode);
      }
    });
  }

  void _collapseAll() {
    setState(() {
      _expandedNodes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    final isDark = widget.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final treeAsync = ref.watch(orgUnitsTreeProvider);

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
      child: treeAsync.when(
        data: (tree) => Column(
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
                                onTap: () => _expandAll(tree),
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
                                onTap: _collapseAll,
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
                              onTap: () => _expandAll(tree),
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
                              onTap: _collapseAll,
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
              child: tree.tree.isEmpty
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
                      children: tree.tree.map((node) {
                        return OrgUnitTreeNodeWidget(
                          node: node,
                          expandedNodes: _expandedNodes,
                          onToggle: _toggleNode,
                          localizations: localizations,
                          isDark: isDark,
                          level: 0,
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
        loading: () => Padding(
          padding: EdgeInsets.all(24.w),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
                SizedBox(height: 16.h),
                Text(
                  localizations.pleaseWait,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stack) => Padding(
          padding: EdgeInsets.all(24.w),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color: AppColors.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Failed to load tree',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => ref.invalidate(orgUnitsTreeProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
