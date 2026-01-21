import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComplianceCheckSection extends StatelessWidget {
  final bool isDark;
  final ComplianceCheck compliance;

  const ComplianceCheckSection({super.key, required this.isDark, required this.compliance});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Kuwait Labor Law Compliance Check',
      iconPath: Assets.icons.complianceIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          _ComplianceItem(
            isDark: isDark,
            label: 'Minimum Entitlement Met',
            isCompliant: compliance.minimumEntitlementMet,
          ),
          _ComplianceItem(isDark: isDark, label: 'Accrual Method Valid', isCompliant: compliance.accrualMethodValid),
          _ComplianceItem(
            isDark: isDark,
            label: 'Eligibility Criteria Valid',
            isCompliant: compliance.eligibilityCriteriaValid,
          ),
        ],
      ),
    );
  }
}

class _ComplianceItem extends StatelessWidget {
  final bool isDark;
  final String label;
  final bool isCompliant;

  const _ComplianceItem({required this.isDark, required this.label, required this.isCompliant});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
        Gap(12.w),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          'Compliant',
          style: context.textTheme.bodySmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
