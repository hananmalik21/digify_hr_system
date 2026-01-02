import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/dto/shift_dto.dart';

/// Remote data source for shift operations
abstract class ShiftRemoteDataSource {
  Future<PaginatedShiftsDto> getShifts({
    required int tenantId,
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  });
}

class ShiftRemoteDataSourceImpl implements ShiftRemoteDataSource {
  final ApiClient apiClient;

  const ShiftRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedShiftsDto> getShifts({
    required int tenantId,
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  }) async {
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

      if (search != null) {
        final trimmedSearch = search.trim();
        if (trimmedSearch.isNotEmpty) {
          queryParameters['search'] = trimmedSearch;
        }
      }

      if (isActive != null) {
        queryParameters['status'] = isActive ? 'ACTIVE' : 'INACTIVE';
      }

      final response = await apiClient.get(
        ApiEndpoints.tmShifts,
        queryParameters: queryParameters,
      );

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      return PaginatedShiftsDto.fromJson(response);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException(
        'Invalid data format: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw UnknownException(
        'Failed to fetch shifts: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
