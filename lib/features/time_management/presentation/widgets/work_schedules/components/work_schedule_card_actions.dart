import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_action_button.dart';
// import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_icon_button.dart';
import 'package:flutter/material.dart';

class WorkScheduleCardActions extends StatelessWidget {
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;

  const WorkScheduleCardActions({
    super.key,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getActionButtonSpacing(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final showLabels = ResponsiveHelper.shouldShowActionLabels(context, constraints.maxWidth);

        return Row(
          children: [
            Expanded(
              child: ShiftCardActionButton(
                label: 'View Details',
                showLabel: showLabels,
                icon: Icons.visibility_outlined,
                bgColor: AppColors.shiftViewButtonBg,
                textColor: AppColors.shiftViewButtonText,
                onPressed: onViewDetails,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: ShiftCardActionButton(
                label: 'Edit',
                showLabel: showLabels,
                icon: Icons.edit_outlined,
                bgColor: AppColors.shiftEditButtonBg,
                textColor: AppColors.shiftEditButtonText,
                onPressed: onEdit,
              ),
            ),
            // SizedBox(width: spacing),
            // ShiftCardIconButton(
            //   icon: Icons.copy_rounded,
            //   bgColor: AppColors.shiftCopyButtonBg,
            //   iconColor: AppColors.shiftCopyButtonText,
            //   onPressed: onDuplicate,
            // ),
          ],
        );
      },
    );
  }
}
