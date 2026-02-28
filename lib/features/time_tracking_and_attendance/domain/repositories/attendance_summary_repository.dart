import '../models/attendance_summary/attendance_summary_record.dart';

abstract class AttendanceSummaryRepository {
  Future<List<AttendanceSummaryRecord>> getAttendanceSummaryRecords({
    required String companyId,
    String? department,
    String? date,
  });
}
