class EmployeeListItem {
  final String id;
  final String fullName;
  final String employeeId;
  final String position;
  final String department;
  final String status;
  final String? email;
  final String? phone;

  const EmployeeListItem({
    required this.id,
    required this.fullName,
    required this.employeeId,
    required this.position,
    required this.department,
    required this.status,
    this.email,
    this.phone,
  });

  factory EmployeeListItem.empty() =>
      const EmployeeListItem(id: '', fullName: '', employeeId: '', position: '', department: '', status: '');

  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
}
