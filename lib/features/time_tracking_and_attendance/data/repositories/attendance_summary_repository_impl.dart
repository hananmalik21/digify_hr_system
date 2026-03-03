import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/exceptions.dart';
import '../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../domain/repositories/attendance_summary_repository.dart';
import '../dto/attendance_summary_dto.dart';

class AttendanceSummaryRepositoryImpl implements AttendanceSummaryRepository {
  final ApiClient? _apiClient;

  AttendanceSummaryRepositoryImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<List<AttendanceSummaryRecord>> getAttendanceSummaryRecords({
    required String companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiClient?.get(
        ApiEndpoints.tmAttendanceSummary,
        queryParameters: {
          'enterprise_id': companyId,
          if (orgUnitId != null) 'org_unit_id': orgUnitId,
          if (levelCode != null) 'level_code': levelCode,
          if (date != null) 'date': date,
          if (page != null) 'page': page.toString(),
          if (pageSize != null) 'page_size': pageSize.toString(),
        },
      );

      final responseData = response?['data'] ?? response;
      if (responseData == null) {
        return [];
      }

      if (responseData is List) {
        return responseData
            .where((e) => e is Map && e.isNotEmpty)
            .map(
              (e) => AttendanceSummaryDto.fromJson(
                Map<String, dynamic>.from(e),
              ).toDomain(),
            )
            .toList();
      } else if (responseData is Map &&
          responseData.isNotEmpty &&
          responseData.containsKey('actual_id')) {
        return [
          AttendanceSummaryDto.fromJson(
            Map<String, dynamic>.from(responseData),
          ).toDomain(),
        ];
      }

      return [];
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load attendance summary: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
