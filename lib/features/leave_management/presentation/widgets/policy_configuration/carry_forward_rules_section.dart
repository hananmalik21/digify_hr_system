import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarryForwardRulesSection extends StatelessWidget {
  final bool isDark;
  final CarryForwardRules carryForward;

  const CarryForwardRulesSection({super.key, required this.isDark, required this.carryForward});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Carry Forward Rules',
      iconPath: Assets.icons.clockIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                DigifyCheckbox(
                  value: carryForward.allowCarryForward,
                  onChanged: null,
                  label: 'Allow Carry Forward to Next Year',
                ),
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: Text(
                    'Enable employees to carry unused leave to the following year',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    DigifyTextField.number(
                      controller: TextEditingController(text: carryForward.carryForwardLimit),
                      labelText: 'Carry Forward Limit (days)',
                      hintText: 'Enter limit',
                      filled: true,
                      fillColor: AppColors.cardBackground,
                    ),
                    Text(
                      'Maximum days allowed to carry forward',
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
                      controller: TextEditingController(text: carryForward.gracePeriod),
                      labelText: 'Grace Period (days)',
                      hintText: 'Enter grace period',
                      filled: true,
                      fillColor: AppColors.cardBackground,
                    ),
                    Text(
                      'Days after year-end to use carried leave',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
