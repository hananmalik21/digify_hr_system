import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/assignment_start_end_module.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/job_employment_details_module.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/organizational_structure_module.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeAssignmentStep extends StatelessWidget {
  const AddEmployeeAssignmentStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.assignment.path,
          title: localizations.assignmentInformation,
          subtitle: localizations.assignmentInformationSubtitle,
        ),
        const OrganizationalStructureModule(),
        const AssignmentStartEndModule(),
        const JobEmploymentDetailsModule(),
      ],
    );
  }
}
