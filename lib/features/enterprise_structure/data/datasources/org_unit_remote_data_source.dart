import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/org_structure_level_dto.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/org_unit_tree_dto.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/paginated_org_units_response_dto.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for organization unit operations
abstract class OrgUnitRemoteDataSource {
  Future<List<OrgStructureLevelDto>> getOrgUnitsByLevel(String levelCode);
  Future<List<OrgStructureLevelDto>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode);
  Future<PaginatedOrgUnitsResponseDto> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    String? search,
    int page = 1,
    int pageSize = 10,
  });
  Future<List<OrgStructureLevelDto>> getParentOrgUnits(String structureId, String levelCode);
  Future<OrgStructureLevelDto> createOrgUnit(String structureId, Map<String, dynamic> data);
  Future<OrgStructureLevelDto> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data);
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true});
  Future<OrgUnitTreeResponseDto> getOrgUnitsTree();
}

class OrgUnitRemoteDataSourceImpl implements OrgUnitRemoteDataSource {
  final ApiClient apiClient;

  OrgUnitRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<OrgStructureLevelDto>> getOrgUnitsByLevel(String levelCode) async {
    try {
      // Use endpoint: /api/hr-org-structures/active/levels/{levelCode}/units
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresUnitsByLevel(levelCode),
      );

      // Handle different response formats
      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('units') && response['units'] is List) {
        data = response['units'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => OrgStructureLevelDto.fromJson(json))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch org units for level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<OrgStructureLevelDto>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode) async {
    try {
      // Use endpoint: /api/hr-org-structures/{structureId}/org-units?level={levelCode}
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresUnitsByStructureAndLevel(structureId, levelCode),
        queryParameters: {'level': levelCode},
      );

      // Handle different response formats
      // Expected format: {success: true, meta: {...}, data: [...]}
      List<dynamic> data = [];
      
      // Check for nested data structure: {success: true, data: [...]}
      if (response.containsKey('data')) {
        final responseData = response['data'];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          // Handle nested data structure
          if (responseData.containsKey('data') && responseData['data'] is List) {
            data = responseData['data'] as List<dynamic>;
          } else if (responseData.containsKey('units') && responseData['units'] is List) {
            data = responseData['units'] as List<dynamic>;
          }
        }
      } else if (response.containsKey('units') && response['units'] is List) {
        data = response['units'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      }

      // Debug: Print response structure
      debugPrint('OrgUnitRemoteDataSource: Response keys: ${response.keys}');
      debugPrint('OrgUnitRemoteDataSource: Response has data key: ${response.containsKey('data')}');
      if (response.containsKey('data')) {
        debugPrint('OrgUnitRemoteDataSource: data type: ${response['data'].runtimeType}');
      }
      debugPrint('OrgUnitRemoteDataSource: Parsed data type: ${data.runtimeType}, length: ${data.length}');
      if (data.isNotEmpty) {
        debugPrint('OrgUnitRemoteDataSource: First item keys: ${(data.first as Map).keys}');
      } else {
        debugPrint('OrgUnitRemoteDataSource: No data found in response');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map((json) {
            try {
              return OrgStructureLevelDto.fromJson(json);
            } catch (e) {
              debugPrint('OrgUnitRemoteDataSource: Error parsing item: $e');
              debugPrint('OrgUnitRemoteDataSource: Item data: $json');
              rethrow;
            }
          })
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<PaginatedOrgUnitsResponseDto> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      // Use endpoint: GET /api/hr-org-structures/{structureId}/org-units?level={levelCode}&search={search}&page={page}&page_size={pageSize}
      final queryParameters = <String, String>{
        'level': levelCode,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresUnitsByStructureAndLevel(structureId, levelCode),
        queryParameters: queryParameters,
      );

      debugPrint('=== OrgUnitRemoteDataSource: Paginated API Response ===');
      debugPrint('Endpoint: ${ApiEndpoints.hrOrgStructuresUnitsByStructureAndLevel(structureId, levelCode)}');
      debugPrint('Query params: $queryParameters');
      debugPrint('Response keys: ${response.keys.toList()}');
      debugPrint('Response has data: ${response.containsKey('data')}');
      debugPrint('Response has pagination: ${response.containsKey('pagination')}');
      debugPrint('Response has meta: ${response.containsKey('meta')}');
      if (response.containsKey('pagination')) {
        debugPrint('Pagination object: ${response['pagination']}');
      }
      if (response.containsKey('data')) {
        final data = response['data'];
        debugPrint('Data type: ${data.runtimeType}');
        if (data is List) {
          debugPrint('Data length: ${data.length}');
        }
      }
      debugPrint('Full response: $response');
      debugPrint('=== End API Response ===');

      return PaginatedOrgUnitsResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch paginated org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<OrgStructureLevelDto>> getParentOrgUnits(String structureId, String levelCode) async {
    try {
      // Use endpoint: /api/hr-org-structures/{structureId}/org-units/parents?level={levelCode}
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresParentUnits(structureId, levelCode),
        queryParameters: {'level': levelCode},
      );

      // Handle different response formats
      List<dynamic> data = [];
      
      if (response.containsKey('data')) {
        final responseData = response['data'];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          if (responseData.containsKey('data') && responseData['data'] is List) {
            data = responseData['data'] as List<dynamic>;
          } else if (responseData.containsKey('parents') && responseData['parents'] is List) {
            data = responseData['parents'] as List<dynamic>;
          } else if (responseData.containsKey('units') && responseData['units'] is List) {
            data = responseData['units'] as List<dynamic>;
          }
        }
      } else if (response.containsKey('parents') && response['parents'] is List) {
        data = response['parents'] as List<dynamic>;
      } else if (response.containsKey('units') && response['units'] is List) {
        data = response['units'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      }

      debugPrint('OrgUnitRemoteDataSource: Parent units response - data length: ${data.length}');

      return data
          .whereType<Map<String, dynamic>>()
          .map((json) {
            try {
              return OrgStructureLevelDto.fromJson(json);
            } catch (e) {
              debugPrint('OrgUnitRemoteDataSource: Error parsing parent item: $e');
              debugPrint('OrgUnitRemoteDataSource: Item data: $json');
              rethrow;
            }
          })
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch parent org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgStructureLevelDto> createOrgUnit(String structureId, Map<String, dynamic> data) async {
    try {
      // Use endpoint: POST /api/hr-org-structures/{structureId}/org-units
      final response = await apiClient.post(
        ApiEndpoints.hrOrgStructuresCreateUnit(structureId),
        body: data,
      );

      debugPrint('OrgUnitRemoteDataSource: Create org unit response: $response');

      // Handle different response formats
      Map<String, dynamic> responseData;
      if (response.containsKey('data')) {
        responseData = response['data'] is Map<String, dynamic>
            ? response['data'] as Map<String, dynamic>
            : response;
      } else {
        responseData = response;
      }

      return OrgStructureLevelDto.fromJson(responseData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create org unit for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgStructureLevelDto> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data) async {
    try {
      // Use endpoint: PUT /api/hr-org-structures/{structureId}/org-units/{orgUnitId}
      final response = await apiClient.put(
        ApiEndpoints.hrOrgStructuresUpdateUnit(structureId, orgUnitId),
        body: data,
      );

      debugPrint('OrgUnitRemoteDataSource: Update org unit response: $response');

      // Handle different response formats
      Map<String, dynamic> responseData;
      if (response.containsKey('data')) {
        responseData = response['data'] is Map<String, dynamic>
            ? response['data'] as Map<String, dynamic>
            : response;
      } else {
        responseData = response;
      }

      return OrgStructureLevelDto.fromJson(responseData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update org unit $orgUnitId for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true}) async {
    try {
      // Use endpoint: DELETE /api/hr-org-structures/{structureId}/org-units/{orgUnitId}?hard=true
      await apiClient.delete(
        ApiEndpoints.hrOrgStructuresDeleteUnit(structureId, orgUnitId),
        queryParameters: {'hard': hard.toString()},
      );

      debugPrint('OrgUnitRemoteDataSource: Delete org unit $orgUnitId for structure $structureId (hard=$hard)');
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete org unit $orgUnitId for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgUnitTreeResponseDto> getOrgUnitsTree() async {
    try {
      final response = await apiClient.get(ApiEndpoints.orgUnitsTreeActive);

      debugPrint('OrgUnitRemoteDataSource: Tree API Response keys: ${response.keys}');

      return OrgUnitTreeResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch org units tree: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

