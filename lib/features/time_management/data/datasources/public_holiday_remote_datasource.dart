import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/models/public_holiday_model.dart';

/// Remote data source for public holiday operations
abstract class PublicHolidayRemoteDataSource {
  Future<PaginatedHolidaysModel> getHolidays({
    int page = 1,
    int pageSize = 10,
    String? search,
    String? year,
    String? type,
  });

  Future<Map<String, dynamic>> createHoliday(Map<String, dynamic> requestBody);

  Future<Map<String, dynamic>> updateHoliday(int holidayId, Map<String, dynamic> requestBody);

  Future<Map<String, dynamic>> deleteHoliday(int holidayId, {bool hard = true});
}

class PublicHolidayRemoteDataSourceImpl implements PublicHolidayRemoteDataSource {
  final ApiClient apiClient;

  const PublicHolidayRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedHolidaysModel> getHolidays({
    int page = 1,
    int pageSize = 10,
    String? search,
    String? year,
    String? type,
  }) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final queryParameters = <String, String>{'page': page.toString(), 'page_size': pageSize.toString()};

      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      if (year != null && year.trim().isNotEmpty) {
        queryParameters['year'] = year.trim();
      }

      if (type != null && type.trim().isNotEmpty && type != 'All Types') {
        queryParameters['type'] = type.trim();
      }

      final response = await apiClient.get(ApiEndpoints.tmPublicHolidays, queryParameters: queryParameters);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      return PaginatedHolidaysModel.fromJson(response);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to fetch holidays: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createHoliday(Map<String, dynamic> requestBody) async {
    try {
      final response = await apiClient.post(ApiEndpoints.tmPublicHolidays, body: requestBody);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create holiday: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateHoliday(int holidayId, Map<String, dynamic> requestBody) async {
    try {
      final endpoint = ApiEndpoints.tmPublicHolidayById(holidayId);
      final response = await apiClient.put(endpoint, body: requestBody);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update holiday: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteHoliday(int holidayId, {bool hard = true}) async {
    try {
      final queryParameters = <String, String>{'hard': hard.toString()};
      final endpoint = ApiEndpoints.tmPublicHolidayById(holidayId);
      final response = await apiClient.delete(endpoint, queryParameters: queryParameters);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete holiday: ${e.toString()}', originalError: e);
    }
  }
}
