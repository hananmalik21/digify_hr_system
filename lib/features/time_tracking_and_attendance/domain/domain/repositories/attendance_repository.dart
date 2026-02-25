import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/attendance/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? employeeNumber,
  });
}
