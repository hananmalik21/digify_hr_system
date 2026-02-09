class AttendanceRecord {
  final String employeeName;
  final String employeeId;
  final String departmentName;
  final DateTime date;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final String avatarInitials;

  AttendanceRecord({
    required this.employeeName,
    required this.employeeId,
    required this.departmentName,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.avatarInitials,
  });
}
