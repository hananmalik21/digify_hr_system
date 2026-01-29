import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/contract_type_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/employee_category_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/employment_type_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/gender_religion_marital_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/probation_period_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/years_of_service_subsection.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EligibilityCriteriaSection extends StatelessWidget {
  final bool isDark;
  final EligibilityCriteria eligibility;
  final bool isEditing;

  const EligibilityCriteriaSection({
    super.key,
    required this.isDark,
    required this.eligibility,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Eligibility Criteria',
      iconPath: Assets.icons.leaveManagement.shield.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.h,
        children: [
          YearsOfServiceSubsection(eligibility: eligibility, isDark: isDark, isEditing: isEditing),
          EmployeeCategorySubsection(eligibility: eligibility, isDark: isDark, isEditing: isEditing),
          EmploymentTypeSubsection(eligibility: eligibility, isDark: isDark, isEditing: isEditing),
          ContractTypeSubsection(eligibility: eligibility, isDark: isDark, isEditing: isEditing),
          GenderReligionMaritalSubsection(eligibility: eligibility, isDark: isDark, isEditing: isEditing),
          ProbationPeriodSubsection(eligibility: eligibility, isDark: isDark, isEditing: isEditing),
        ],
      ),
    );
  }
}
