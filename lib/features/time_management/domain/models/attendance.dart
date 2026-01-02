import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';

/// Domain model for Attendance record
class Attendance {
  final int id;
  final int employeeId;
  final String employeeName;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double? workedHours;
  final AttendanceStatus status;
  final String? notes;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Attendance({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.checkInTime,
    this.checkOutTime,
    this.workedHours,
    required this.status,
    this.notes,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });
}

/// Domain model for Attendance overview (list item)
class AttendanceOverview {
  final int id;
  final int employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime date;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double? workedHours;
  final AttendanceStatus status;
  final String? department;
  final String? position;

  const AttendanceOverview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    this.workedHours,
    required this.status,
    this.department,
    this.position,
  });
}

/// Paginated attendance response
class PaginatedAttendances {
  final List<AttendanceOverview> attendances;
  final PaginationInfo pagination;

  const PaginatedAttendances({
    required this.attendances,
    required this.pagination,
  });
}

/// Attendance status enum
enum AttendanceStatus { present, absent, late, earlyLeave, onLeave, halfDay }
