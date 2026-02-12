import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';

class AttendanceRecord {
  final String employeeName;
  final String employeeId;
  final String departmentName;
  final DateTime date;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final String avatarInitials;
  final Attendance? attendance; // Full attendance data for expanded view

  AttendanceRecord({
    required this.employeeName,
    required this.employeeId,
    required this.departmentName,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.avatarInitials,
    this.attendance,
  });

  /// Factory method to create AttendanceRecord from Attendance domain model
  factory AttendanceRecord.fromAttendance(Attendance attendance) {
    return AttendanceRecord(
      employeeName: attendance.employeeName,
      employeeId: attendance.employeeNumber,
      departmentName: attendance.departmentName,
      date: attendance.date,
      checkIn: attendance.formattedCheckIn,
      checkOut: attendance.formattedCheckOut,
      status: attendance.statusString,
      avatarInitials: attendance.avatarInitials,
      attendance: attendance, // Store full attendance data
    );
  }
}
