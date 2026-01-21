import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CarryForwardRulesSection extends StatelessWidget {
  final bool isDark;
  final CarryForwardRules carryForward;

  const CarryForwardRulesSection({super.key, required this.isDark, required this.carryForward});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Carry Forward Rules',
      iconPath: Assets.icons.leaveManagement.downfall.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            children: [
              Switch(value: carryForward.allowCarryForward, onChanged: null, activeThumbColor: AppColors.primary),
              Gap(8.w),
              Expanded(
                child: Text(
                  'Allow Carry Forward to Next Year',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: carryForward.carryForwardLimit),
                  labelText: 'Carry Forward Limit (days)',
                  hintText: 'e.g., 10',
                  enabled: false,
                ),
              ),
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: carryForward.gracePeriod),
                  labelText: 'Grace Period (days)',
                  hintText: 'e.g., 90',
                  enabled: false,
                ),
              ),
            ],
          ),
          Text(
            'Unused leave days within the grace period can be carried forward',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
