import '../../models/attendance_summary/attendance_summary_record.dart';
import '../../repositories/attendance_summary_repository.dart';

class GetAttendanceSummaryUseCase {
  final AttendanceSummaryRepository repository;

  GetAttendanceSummaryUseCase({required this.repository});

  Future<List<AttendanceSummaryRecord>> call({
    required String companyId,
  }) async {
    return await repository.getAttendanceSummaryRecords(companyId: companyId);
  }
}
