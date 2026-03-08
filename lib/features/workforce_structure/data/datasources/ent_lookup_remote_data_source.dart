import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/employee_management/data/dto/empl_lookup_dto.dart';

abstract class EntLookupRemoteDataSource {
  Future<EmplLookupTypesResponseDto> getLookupTypes(int enterpriseId);
  Future<EmplLookupValuesResponseDto> getLookupValues(int enterpriseId, String lookupTypeCode);
}

class EntLookupRemoteDataSourceImpl implements EntLookupRemoteDataSource {
  EntLookupRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<EmplLookupTypesResponseDto> getLookupTypes(int enterpriseId) async {
    final response = await apiClient.get(
      ApiEndpoints.entLookupTypes,
      queryParameters: {'enterprise_id': enterpriseId.toString()},
    );
    return EmplLookupTypesResponseDto.fromJson(response);
  }

  @override
  Future<EmplLookupValuesResponseDto> getLookupValues(int enterpriseId, String lookupTypeCode) async {
    final response = await apiClient.get(
      ApiEndpoints.entLookupValues,
      queryParameters: {'enterprise_id': enterpriseId.toString(), 'lookup_type': lookupTypeCode},
    );
    return EmplLookupValuesResponseDto.fromJson(response);
  }
}
