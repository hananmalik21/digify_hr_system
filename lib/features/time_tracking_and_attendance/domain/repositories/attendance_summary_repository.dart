import '../models/attendance_summary/attendance_summary_record.dart';

abstract class AttendanceSummaryRepository {
  Future<List<AttendanceSummaryRecord>> getAttendanceSummaryRecords({
    required String companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    int? page,
    int? pageSize,
  });
}
