import '../models/overtime/overtime_requests_page.dart';

abstract class OvertimeRepository {
  Future<OvertimeRequestsPage> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  });
}
