import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? employeeNumber,
  });
}
