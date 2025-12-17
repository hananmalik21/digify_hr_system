import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// View/Edit/Delete icon button group with hover effects and tooltips
class ActionButtonGroup extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? viewTooltip;
  final String? editTooltip;
  final String? deleteTooltip;
  final bool showView;
  final bool showEdit;
  final bool showDelete;

  const ActionButtonGroup({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.viewTooltip,
    this.editTooltip,
    this.deleteTooltip,
    this.showView = true,
    this.showEdit = true,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showView && onView != null)
          _buildActionButton(
            context,
            isDark,
            iconPath: 'assets/icons/view_icon_blue.svg',
            color: AppColors.viewIconBlue,
            onTap: onView!,
            tooltip: viewTooltip ?? 'View',
          ),
        if (showView && onView != null && (showEdit || showDelete))
          SizedBox(width: 8.w),
        if (showEdit && onEdit != null)
          _buildActionButton(
            context,
            isDark,
            iconPath: 'assets/icons/edit_icon_green.svg',
            color: AppColors.editIconGreen,
            onTap: onEdit!,
            tooltip: editTooltip ?? 'Edit',
          ),
        if (showEdit && onEdit != null && showDelete)
          SizedBox(width: 8.w),
        if (showDelete && onDelete != null)
          _buildActionButton(
            context,
            isDark,
            iconPath: 'assets/icons/delete_icon_red.svg',
            color: AppColors.deleteIconRed,
            onTap: onDelete!,
            tooltip: deleteTooltip ?? 'Delete',
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isDark, {
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: SvgIconWidget(
              assetPath: iconPath,
              size: 18.sp,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

