import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';

abstract class WorkPatternRemoteDataSource {
  Future<PaginatedWorkPatterns> getWorkPatterns({required int tenantId, int page = 1, int pageSize = 10});
  Future<WorkPattern> createWorkPattern({
    required int tenantId,
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  });
  Future<void> deleteWorkPattern({required int workPatternId, required int tenantId, required bool hard});
}

class WorkPatternRemoteDataSourceImpl implements WorkPatternRemoteDataSource {
  final ApiClient apiClient;

  const WorkPatternRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedWorkPatterns> getWorkPatterns({required int tenantId, int page = 1, int pageSize = 10}) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.tmWorkPatterns, queryParameters: queryParameters);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      final dataJson = response['data'] as List<dynamic>? ?? [];
      final workPatterns = dataJson
          .map((item) {
            try {
              return WorkPattern.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<WorkPattern>()
          .toList();

      final metaJson = response['meta'] as Map<String, dynamic>? ?? {};
      final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};

      int parseInt(dynamic value, {int defaultValue = 0}) {
        if (value == null) return defaultValue;
        if (value is int) return value;
        if (value is String) {
          final parsed = int.tryParse(value);
          return parsed ?? defaultValue;
        }
        if (value is num) return value.toInt();
        return defaultValue;
      }

      bool parseBool(dynamic value, {bool defaultValue = false}) {
        if (value == null) return defaultValue;
        if (value is bool) return value;
        if (value is String) {
          return value.toLowerCase() == 'true' || value == '1';
        }
        if (value is num) return value != 0;
        return defaultValue;
      }

      final paginationPage = parseInt(paginationJson['page'], defaultValue: 1);
      final paginationPageSize = parseInt(paginationJson['page_size'], defaultValue: 10);
      final paginationTotal = parseInt(paginationJson['total'], defaultValue: 0);
      final paginationTotalPages = parseInt(paginationJson['total_pages'], defaultValue: 0);

      final validPage = paginationPage < 1 ? 1 : paginationPage;
      final validPageSize = paginationPageSize < 1 ? pageSize : paginationPageSize;
      final validTotal = paginationTotal < 0 ? 0 : paginationTotal;
      final validTotalPages = paginationTotalPages < 0 ? 0 : paginationTotalPages;

      final pagination = PaginationInfo(
        currentPage: validPage,
        totalPages: validTotalPages,
        totalItems: validTotal,
        pageSize: validPageSize,
        hasNext: parseBool(paginationJson['has_next'], defaultValue: false) && validPage < validTotalPages,
        hasPrevious: parseBool(paginationJson['has_previous'], defaultValue: false) && validPage > 1,
      );

      return PaginatedWorkPatterns(workPatterns: workPatterns, pagination: pagination);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to fetch work patterns: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<WorkPattern> createWorkPattern({
    required int tenantId,
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final body = {
        'tenant_id': tenantId,
        'pattern_code': patternCode,
        'pattern_name_en': patternNameEn,
        'pattern_name_ar': patternNameAr,
        'pattern_type': patternType,
        'total_hours_per_week': totalHoursPerWeek,
        'status': status == PositionStatus.active ? 'ACTIVE' : 'INACTIVE',
        'days': days.map((day) => day.toJson()).toList(),
      };

      final response = await apiClient.post(ApiEndpoints.tmWorkPatterns, body: body);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      final dataJson = response['data'] as Map<String, dynamic>?;
      if (dataJson == null) {
        throw ValidationException('Invalid response format: missing data field');
      }

      return WorkPattern.fromJson(dataJson);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to create work pattern: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteWorkPattern({required int workPatternId, required int tenantId, required bool hard}) async {
    try {
      if (workPatternId <= 0) {
        throw ValidationException('work_pattern_id must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final queryParameters = <String, String>{'tenant_id': tenantId.toString(), 'hard': hard.toString()};

      final endpoint = '${ApiEndpoints.tmWorkPatterns}/$workPatternId';
      await apiClient.delete(endpoint, queryParameters: queryParameters);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete work pattern: ${e.toString()}', originalError: e);
    }
  }
}
