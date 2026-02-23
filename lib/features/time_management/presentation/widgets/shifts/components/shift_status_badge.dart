import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';

class ShiftStatusBadge extends StatelessWidget {
  final bool isActive;

  const ShiftStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return DigifyCapsule(
      label: isActive ? 'ACTIVE' : 'INACTIVE',
      backgroundColor: isActive ? AppColors.shiftActiveStatusBg : AppColors.shiftInactiveStatusBg,
      textColor: isActive ? AppColors.shiftActiveStatusText : AppColors.shiftInactiveStatusText,
    );
  }
}
