import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance_log_page.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  });

  Future<AttendanceLogPage> getAttendanceLogs({
    required int enterpriseId,
    int page = 1,
    int pageSize = 25,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  });
}
