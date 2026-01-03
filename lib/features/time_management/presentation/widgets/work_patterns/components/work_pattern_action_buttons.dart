import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternActionButtons extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  // final VoidCallback? onCopy; // Commented out - not needed for now

  const WorkPatternActionButtons({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    // this.onCopy, // Commented out - not needed for now
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null)
          DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: onView, width: 16, height: 16),
        if (onView != null && (onEdit != null || onDelete != null)) SizedBox(width: 8.w),
        if (onEdit != null)
          DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: onEdit, width: 16, height: 16),
        if (onEdit != null && onDelete != null) SizedBox(width: 8.w),
        // Copy option - commented out for now
        // if (onCopy != null)
        //   DigifyAssetButton(
        //     assetPath: Assets.icons.copyIcon.path,
        //     onTap: onCopy,
        //     width: 16,
        //     height: 16,
        //   ),
        // if (onCopy != null && onDelete != null) SizedBox(width: 8.w),
        if (onDelete != null)
          DigifyAssetButton(assetPath: Assets.icons.redDeleteIcon.path, onTap: onDelete, width: 16, height: 16),
      ],
    );
  }
}
