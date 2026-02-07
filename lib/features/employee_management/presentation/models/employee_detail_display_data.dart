import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';

/// Presentation-level display data for the employee detail screen.
/// Computes display strings from [employee] and [fullDetails]; no logic in widgets.
class EmployeeDetailDisplayData {
  EmployeeDetailDisplayData({required this.employee, this.fullDetails});

  final EmployeeListItem employee;
  final EmployeeFullDetails? fullDetails;

  String get displayName {
    final name = fullDetails?.employee.fullNameEn;
    if (name != null && name.isNotEmpty) return name.toUpperCase();
    return employee.fullName.toUpperCase();
  }

  String get departmentLabel {
    final list = fullDetails?.assignment.orgStructureList ?? [];
    final deptList = list.where((e) => e.levelCode == 'DEPARTMENT').toList();
    final dept = deptList.isEmpty ? null : deptList.first;
    if (dept != null && (dept.orgUnitNameEn ?? '').trim().isNotEmpty) {
      return (dept.orgUnitNameEn ?? '').toUpperCase();
    }
    if (list.isNotEmpty) {
      final last = list.last;
      return (last.orgUnitNameEn ?? '').trim().isEmpty
          ? employee.department
          : (last.orgUnitNameEn ?? employee.department).toUpperCase();
    }
    return employee.department;
  }

  String get employeeNumber => fullDetails?.employee.employeeNumber ?? employee.employeeId;

  String get servicePeriod {
    final hireDate = fullDetails?.assignment.enterpriseHireDate;
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

  String get gradeLevel => fullDetails?.employee.gradeId != null ? 'Grade ${fullDetails!.employee.gradeId}' : '—';

  String get totalSalary {
    if (fullDetails == null) return '—';
    final base = fullDetails!.compensation?.basicSalaryKwd ?? 0.0;
    final a = fullDetails!.allowances;
    final total =
        base +
        (a?.housingKwd ?? 0) +
        (a?.transportKwd ?? 0) +
        (a?.foodKwd ?? 0) +
        (a?.mobileKwd ?? 0) +
        (a?.otherKwd ?? 0);
    return total == 0 ? '—' : '${total.toStringAsFixed(3)} KWD';
  }

  String get nationality => fullDetails?.demographics?.nationalityCode ?? '—';
}
