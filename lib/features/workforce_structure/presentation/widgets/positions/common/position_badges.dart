import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionStatusBadge extends StatelessWidget {
  final String label;
  final bool isActive;

  const PositionStatusBadge({super.key, required this.label, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 3.h, 8.w, 3.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.shiftActiveStatusBg : AppColors.inactiveStatusBg,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: isActive ? AppColors.shiftActiveStatusText : AppColors.inactiveStatusText,
        ),
      ),
    );
  }
}

class PositionVacancyBadge extends StatelessWidget {
  final int vacancy;
  final String vacantLabel;
  final String fullLabel;

  const PositionVacancyBadge({super.key, required this.vacancy, required this.vacantLabel, required this.fullLabel});

  @override
  Widget build(BuildContext context) {
    final hasVacancy = vacancy > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 3.h, 8.w, 3.h),
      decoration: BoxDecoration(
        color: hasVacancy ? AppColors.vacancyBg : AppColors.shiftActiveStatusBg,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        textAlign: TextAlign.center,
        hasVacancy ? '$vacancy $vacantLabel' : fullLabel,
        style: context.textTheme.labelSmall?.copyWith(
          color: hasVacancy ? AppColors.vacancyText : AppColors.shiftActiveStatusText,
        ),
      ),
    );
  }
}
