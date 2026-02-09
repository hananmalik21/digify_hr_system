import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';
import 'package:digify_hr_system/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EmploymentInformationSection extends StatelessWidget {
  const EmploymentInformationSection({super.key, required this.isDark, this.fullDetails});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;

  static String _servicePeriod(EmployeeFullDetails? d) {
    final hireDate = d?.assignment.enterpriseHireDate;
    if (hireDate == null || hireDate.isEmpty) return '—';
    try {
      final start = DateTime.parse(hireDate);
      final now = DateTime.now();
      var years = now.year - start.year;
      var months = now.month - start.month;
      if (months < 0) {
        years--;
        months += 12;
      }
      return '${years}y ${months}m';
    } catch (_) {
      return '—';
    }
  }

  List<EmployeeDetailBorderedField> _leftColumnFields() {
    final e = fullDetails?.employee;
    final a = fullDetails?.assignment;
    if (e == null && a == null) {
      return List.generate(5, (_) => const EmployeeDetailBorderedField(label: '—', value: '—'));
    }
    final employeeNumber = e?.employeeNumber ?? a?.employeeNumber;
    final gradeDisplay =
        a?.grade?.gradeNumber ?? (a?.gradeId != null ? '${a!.gradeId}' : (e?.gradeId != null ? '${e!.gradeId}' : null));
    return [
      EmployeeDetailBorderedField(label: 'Employee Number', value: displayValue(employeeNumber)),
      EmployeeDetailBorderedField(
        label: 'Position',
        value: displayValue(a?.positionNameEn ?? a?.positionCode ?? a?.positionId),
      ),
      EmployeeDetailBorderedField(label: 'Grade Level', value: gradeDisplay ?? '—'),
      EmployeeDetailBorderedField(label: 'Enterprise Hire Date', value: formatIsoDateToDisplay(a?.enterpriseHireDate)),
      EmployeeDetailBorderedField(label: 'Service Period', value: _servicePeriod(fullDetails)),
    ];
  }

  List<EmployeeDetailBorderedField> _rightColumnFields() {
    final a = fullDetails?.assignment;
    final e = fullDetails?.employee;
    final ws = fullDetails?.workSchedule;
    final status = a?.assignmentStatus ?? a?.employmentStatus ?? e?.employeeStatus ?? '—';
    final contractEnd = a?.effectiveEndDate != null && a!.effectiveEndDate!.isNotEmpty
        ? formatIsoDateToDisplay(a.effectiveEndDate)
        : 'Ongoing';
    final probationDays = a?.probationDays ?? e?.probationDays;
    final workLocationId = a?.workLocationId ?? e?.workLocationId;
    return [
      EmployeeDetailBorderedField(label: 'Contract Type', value: displayValue(a?.contractTypeCode)),
      EmployeeDetailBorderedField(
        label: 'Contract Start',
        value: formatIsoDateToDisplay(a?.effectiveStartDate ?? a?.enterpriseHireDate),
      ),
      EmployeeDetailBorderedField(label: 'Contract End', value: contractEnd),
      EmployeeDetailBorderedField(
        label: 'Probation Period',
        value: probationDays != null ? '$probationDays days' : '—',
      ),
      EmployeeDetailBorderedField(label: 'Work Location ID', value: workLocationId != null ? '$workLocationId' : '—'),
      EmployeeDetailBorderedField(
        label: 'Employment Status',
        value: status,
        valueWidget: DigifyCapsule(
          label: status,
          icon: Icons.schedule,
          backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
          textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
          borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        ),
      ),
      EmployeeDetailBorderedField(
        label: 'Work Schedule',
        value: ws?.workScheduleId != null ? '${ws!.workScheduleId}' : '—',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeDetailBorderedSectionCard(
      title: 'Employment Information',
      titleIconAssetPath: Assets.icons.deiDashboardIcon.path,
      leftColumnFields: _leftColumnFields(),
      rightColumnFields: _rightColumnFields(),
      isDark: isDark,
    );
  }
}
