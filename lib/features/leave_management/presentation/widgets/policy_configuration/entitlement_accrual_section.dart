import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EntitlementAccrualSection extends StatelessWidget {
  final bool isDark;
  final EntitlementAccrual entitlement;

  const EntitlementAccrualSection({super.key, required this.isDark, required this.entitlement});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Entitlement & Accrual',
      iconPath: Assets.icons.leaveManagement.leaveCalendar.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: entitlement.annualEntitlement),
                  labelText: 'Annual Entitlement (days)',
                  hintText: 'e.g., 30',
                  enabled: false,
                ),
              ),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Accrual Method',
                  items: ['Monthly', 'Quarterly', 'Yearly'],
                  itemLabelBuilder: (item) => item,
                  value: entitlement.accrualMethod,
                  onChanged: null,
                ),
              ),
            ],
          ),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyTextField.number(
                  controller: TextEditingController(text: entitlement.accrualRate),
                  labelText: 'Accrual Rate (days per period)',
                  hintText: 'e.g., 2.5',
                  enabled: false,
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  controller: TextEditingController(text: entitlement.effectiveDate),
                  labelText: 'Effective Date',
                  hintText: 'e.g., 01/01/2024',
                  readOnly: true,
                  enabled: false,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Switch(value: entitlement.enableProRataCalculation, onChanged: null, activeThumbColor: AppColors.primary),
              Gap(8.w),
              Expanded(
                child: Text(
                  'Enable Pro-Rata Calculation',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
