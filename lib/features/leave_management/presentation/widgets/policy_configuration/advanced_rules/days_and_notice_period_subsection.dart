import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DaysAndNoticePeriodSubsection extends StatelessWidget {
  final AdvancedRules advanced;
  final bool isDark;
  final bool isEditing;

  const DaysAndNoticePeriodSubsection({
    super.key,
    required this.advanced,
    required this.isDark,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              DigifyTextField.number(
                controller: TextEditingController(text: advanced.maxConsecutiveDays),
                labelText: 'Maximum Consecutive Days',
                hintText: 'Enter maximum consecutive days',
                filled: true,
                fillColor: AppColors.cardBackground,
                readOnly: !isEditing,
              ),
              Text(
                'Maximum days in a single request',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              DigifyTextField.number(
                controller: TextEditingController(text: advanced.minNoticePeriod),
                labelText: 'Minimum Notice Period (days)',
                hintText: 'Enter minimum notice period',
                filled: true,
                fillColor: AppColors.cardBackground,
                readOnly: !isEditing,
              ),
              Text(
                'Days before leave start date',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
