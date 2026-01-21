import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EncashmentRulesSection extends StatelessWidget {
  final bool isDark;
  final EncashmentRules encashment;

  const EncashmentRulesSection({super.key, required this.isDark, required this.encashment});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Encashment Rules',
      iconPath: Assets.icons.leaveManagement.dollar.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            children: [
              Switch(value: encashment.allowLeaveEncashment, onChanged: null, activeThumbColor: AppColors.primary),
              Gap(8.w),
              Expanded(
                child: Text(
                  'Allow Leave Encashment',
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
                  controller: TextEditingController(text: encashment.encashmentLimit),
                  labelText: 'Encashment Limit (days)',
                  hintText: 'e.g., 15',
                  enabled: false,
                ),
              ),
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: encashment.encashmentRate),
                  labelText: 'Encashment Rate (%)',
                  hintText: 'e.g., 100',
                  enabled: false,
                ),
              ),
            ],
          ),
          Text(
            'Employees can encash unused leave days up to the specified limit at the configured rate',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
