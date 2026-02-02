import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/compensation_allowances_module.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/compensation_basic_salary_module.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/compensation_total_summary_module.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeCompensationStep extends StatelessWidget {
  const AddEmployeeCompensationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.compensation.path,
          title: localizations.compensationAndBenefits,
          subtitle: localizations.compensationAndBenefitsSubtitle,
        ),
        const CompensationBasicSalaryModule(),
        const CompensationAllowancesModule(),
        const CompensationTotalSummaryModule(),
      ],
    );
  }
}
