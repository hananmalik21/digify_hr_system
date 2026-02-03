import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EnterpriseStructureSection extends StatelessWidget {
  const EnterpriseStructureSection({super.key, required this.isDark});

  final bool isDark;

  static const List<EmployeeDetailBorderedField> _leftColumnFields = [
    EmployeeDetailBorderedField(label: 'Company', value: 'Digify HR'),
    EmployeeDetailBorderedField(label: 'Division', value: '—'),
    EmployeeDetailBorderedField(label: 'Business Unit', value: 'HR Software'),
  ];

  static const List<EmployeeDetailBorderedField> _rightColumnFields = [
    EmployeeDetailBorderedField(label: 'Department', value: 'PURCHASING'),
    EmployeeDetailBorderedField(label: 'Section', value: '—'),
  ];

  @override
  Widget build(BuildContext context) {
    return EmployeeDetailBorderedSectionCard(
      title: 'Enterprise Structure',
      titleIconAssetPath: Assets.icons.enterpriseStructureIcon.path,
      leftColumnFields: _leftColumnFields,
      rightColumnFields: _rightColumnFields,
      isDark: isDark,
    );
  }
}
