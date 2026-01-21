import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvancedRulesSection extends StatelessWidget {
  final bool isDark;
  final AdvancedRules advanced;

  const AdvancedRulesSection({super.key, required this.isDark, required this.advanced});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Advanced Rules',
      iconPath: Assets.icons.settingsIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: advanced.maxConsecutiveDays),
                  labelText: 'Maximum Consecutive Days',
                  hintText: 'e.g., 10',
                  enabled: false,
                ),
              ),
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: advanced.minNoticePeriod),
                  labelText: 'Minimum Notice Period (days)',
                  hintText: 'e.g., 14',
                  enabled: false,
                ),
              ),
            ],
          ),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyCheckbox(
                  value: advanced.countWeekendsAsLeave,
                  onChanged: null,
                  label: 'Count weekends as leave days',
                ),
              ),
              Expanded(
                child: DigifyCheckbox(
                  value: advanced.countPublicHolidaysAsLeave,
                  onChanged: null,
                  label: 'Count public holidays as leave days',
                ),
              ),
            ],
          ),
          DigifyCheckbox(
            value: advanced.requiredSupportingDocumentation,
            onChanged: (value) {},
            label: 'Required Supporting Documentation',
          ),
        ],
      ),
    );
  }
}
