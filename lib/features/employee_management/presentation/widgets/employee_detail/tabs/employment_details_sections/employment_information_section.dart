import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EmploymentInformationSection extends StatelessWidget {
  const EmploymentInformationSection({super.key, required this.isDark});

  final bool isDark;

  static const List<EmployeeDetailBorderedField> _leftColumnFields = [
    EmployeeDetailBorderedField(label: 'Employee Number', value: '—'),
    EmployeeDetailBorderedField(label: 'Position/Job Title', value: 'HR Manager'),
    EmployeeDetailBorderedField(label: 'Grade Level', value: '—'),
    EmployeeDetailBorderedField(label: 'Join Date', value: '—'),
    EmployeeDetailBorderedField(label: 'Service Period', value: '15y 11m'),
  ];

  List<EmployeeDetailBorderedField> _rightColumnFields() => [
    const EmployeeDetailBorderedField(label: 'Contract Type', value: 'Permanent'),
    const EmployeeDetailBorderedField(label: 'Contract Start Date', value: '01/01/2010'),
    const EmployeeDetailBorderedField(label: 'Contract End Date', value: 'Ongoing'),
    const EmployeeDetailBorderedField(label: 'Probation Period', value: '90 days'),
    const EmployeeDetailBorderedField(label: 'Work Location', value: 'Hawally'),
    EmployeeDetailBorderedField(
      label: 'Employment Status',
      value: 'Probation',
      valueWidget: DigifyCapsule(
        label: 'Probation',
        icon: Icons.schedule,
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
        textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
      ),
    ),
    const EmployeeDetailBorderedField(label: 'Work Schedule', value: 'standard-40hr'),
  ];

  @override
  Widget build(BuildContext context) {
    return EmployeeDetailBorderedSectionCard(
      title: 'Employment Information',
      titleIconAssetPath: Assets.icons.deiDashboardIcon.path,
      leftColumnFields: _leftColumnFields,
      rightColumnFields: _rightColumnFields(),
      isDark: isDark,
    );
  }
}
