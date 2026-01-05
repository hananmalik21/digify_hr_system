import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentActionButtons extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ScheduleAssignmentActionButtons({super.key, this.onView, this.onEdit, this.onDelete, this.isDeleting = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null)
          DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: onView, width: 15, height: 15),
        if (onView != null && (onEdit != null || onDelete != null)) SizedBox(width: 4.w),
        if (onEdit != null)
          DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: onEdit, width: 15, height: 15),
        if (onEdit != null && onDelete != null) SizedBox(width: 4.w),
        if (onDelete != null)
          DigifyAssetButton(
            assetPath: Assets.icons.redDeleteIcon.path,
            onTap: onDelete,
            width: 15,
            height: 15,
            isLoading: isDeleting,
          ),
      ],
    );
  }
}
