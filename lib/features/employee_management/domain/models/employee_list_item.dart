/// List item model for the Manage Employees table row.
/// Holds display data for #, EMPLOYEE, POSITION, DEPARTMENT, STATUS.
class EmployeeListItem {
  final String id;
  final String fullName;
  final String employeeId;
  final String position;
  final String department;
  final String status;

  const EmployeeListItem({
    required this.id,
    required this.fullName,
    required this.employeeId,
    required this.position,
    required this.department,
    required this.status,
  });

  factory EmployeeListItem.empty() =>
      const EmployeeListItem(id: '', fullName: '', employeeId: '', position: '', department: '', status: '');

  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
}
