import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/dto/attendance_log_dto.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance_log_page.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiClient _apiClient;

  AttendanceRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);
  @override
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  }) async {
    return [];
  }

  @override
  Future<AttendanceLogPage> getAttendanceLogs({
    required int enterpriseId,
    int page = 1,
    int pageSize = 25,
    String? orgUnitId,
    String? levelCode,
  }) async {
    try {
      final query = <String, String>{
        'enterpriseId': enterpriseId.toString(),
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (orgUnitId != null && orgUnitId.isNotEmpty) {
        query['orgUnitId'] = orgUnitId;
      }
      if (levelCode != null && levelCode.isNotEmpty) {
        query['levelCode'] = levelCode;
      }

      final response = await _apiClient.get(ApiEndpoints.tmAttendanceLogs, queryParameters: query);

      final dto = AttendanceLogsResponseDto.fromJson(response);
      final records = dto.items.map((e) => e.toDomain()).toList();

      return AttendanceLogPage(
        records: records,
        page: dto.pagination.page,
        pageSize: dto.pagination.pageSize,
        total: dto.pagination.total,
        totalPages: dto.pagination.totalPages,
        hasNext: dto.pagination.hasNext,
        hasPrevious: dto.pagination.hasPrevious,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to load attendance logs: ${e.toString()}', originalError: e);
    }
  }
}
