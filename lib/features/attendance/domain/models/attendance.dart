class Attendance {
  final int id;
  final int employeeId;
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String status;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      employeeId: json['employee_id'],
      date: DateTime.parse(json['date']),
      clockIn: json['clock_in'] != null ? DateTime.parse(json['clock_in']) : null,
      clockOut: json['clock_out'] != null ? DateTime.parse(json['clock_out']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': date.toIso8601String(),
      'clock_in': clockIn?.toIso8601String(),
      'clock_out': clockOut?.toIso8601String(),
      'status': status,
    };
  }
}
