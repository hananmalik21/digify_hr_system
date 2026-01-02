import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_action_button.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardActions extends StatelessWidget {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onCopy;

  const ShiftCardActions({
    super.key,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShiftCardActionButton(
            label: 'View',
            icon: Icons.visibility_outlined,
            bgColor: AppColors.shiftViewButtonBg,
            textColor: AppColors.shiftViewButtonText,
            onPressed: onView,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ShiftCardActionButton(
            label: 'Edit',
            icon: Icons.edit_outlined,
            bgColor: AppColors.shiftEditButtonBg,
            textColor: AppColors.shiftEditButtonText,
            onPressed: onEdit,
          ),
        ),
        SizedBox(width: 8.w),
        ShiftCardIconButton(
          icon: Icons.copy_rounded,
          bgColor: AppColors.shiftCopyButtonBg,
          iconColor: AppColors.shiftCopyButtonText,
          onPressed: onCopy,
        ),
      ],
    );
  }
}
