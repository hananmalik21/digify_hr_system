import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';
import 'package:digify_hr_system/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WorkforceStructureSection extends StatelessWidget {
  const WorkforceStructureSection({super.key, required this.isDark, this.fullDetails});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;

  @override
  Widget build(BuildContext context) {
    final a = fullDetails?.assignment;
    final ws = fullDetails?.workSchedule;
    final left = [
      EmployeeDetailBorderedField(label: 'Worker Type', value: displayValue(a?.contractTypeCode)),
      EmployeeDetailBorderedField(label: 'Assignment Category', value: displayValue(a?.employmentStatus)),
    ];
    final right = [
      EmployeeDetailBorderedField(
        label: 'Work Schedule ID',
        value: ws?.workScheduleId != null ? '${ws!.workScheduleId}' : '—',
      ),
    ];
    return EmployeeDetailBorderedSectionCard(
      title: 'Workforce Structure',
      titleIconAssetPath: Assets.icons.workforceStructureIcon.path,
      leftColumnFields: left,
      rightColumnFields: right,
      isDark: isDark,
    );
  }
}
