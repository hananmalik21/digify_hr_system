import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WorkforceStructureSection extends StatelessWidget {
  const WorkforceStructureSection({super.key, required this.isDark});

  final bool isDark;

  static const List<EmployeeDetailBorderedField> _leftColumnFields = [
    EmployeeDetailBorderedField(label: 'Worker Type', value: '—'),
    EmployeeDetailBorderedField(label: 'Assignment Category', value: '—'),
  ];

  static const List<EmployeeDetailBorderedField> _rightColumnFields = [
    EmployeeDetailBorderedField(label: 'Work Hours per Week', value: '—'),
    EmployeeDetailBorderedField(label: 'Direct Manager', value: 'John Smith (CEO)'),
  ];

  @override
  Widget build(BuildContext context) {
    return EmployeeDetailBorderedSectionCard(
      title: 'Workforce Structure',
      titleIconAssetPath: Assets.icons.workforceStructureIcon.path,
      leftColumnFields: _leftColumnFields,
      rightColumnFields: _rightColumnFields,
      isDark: isDark,
    );
  }
}
