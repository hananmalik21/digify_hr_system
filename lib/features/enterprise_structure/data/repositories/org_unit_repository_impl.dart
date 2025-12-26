import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/org_unit_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/paginated_org_units_response.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Implementation of OrgUnitRepository
class OrgUnitRepositoryImpl implements OrgUnitRepository {
  final OrgUnitRemoteDataSource remoteDataSource;

  OrgUnitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrgStructureLevel>> getOrgUnitsByLevel(String levelCode) async {
    try {
      final dtos = await remoteDataSource.getOrgUnitsByLevel(levelCode);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<OrgStructureLevel>> getOrgUnitsByStructureAndLevel(int structureId, String levelCode) async {
    try {
      final dtos = await remoteDataSource.getOrgUnitsByStructureAndLevel(structureId, levelCode);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<PaginatedOrgUnitsResponse> getOrgUnitsByStructureAndLevelPaginated(
    int structureId,
    String levelCode, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final dto = await remoteDataSource.getOrgUnitsByStructureAndLevelPaginated(
        structureId,
        levelCode,
        search: search,
        page: page,
        pageSize: pageSize,
      );
      return PaginatedOrgUnitsResponse(
        units: dto.units.map((unitDto) => unitDto.toDomain()).toList(),
        currentPage: dto.currentPage,
        pageSize: dto.pageSize,
        totalPages: dto.totalPages,
        totalItems: dto.totalItems,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<OrgStructureLevel>> getParentOrgUnits(int structureId, String levelCode) async {
    try {
      final dtos = await remoteDataSource.getParentOrgUnits(structureId, levelCode);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgStructureLevel> createOrgUnit(int structureId, Map<String, dynamic> data) async {
    try {
      final dto = await remoteDataSource.createOrgUnit(structureId, data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgStructureLevel> updateOrgUnit(int structureId, int orgUnitId, Map<String, dynamic> data) async {
    try {
      final dto = await remoteDataSource.updateOrgUnit(structureId, orgUnitId, data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteOrgUnit(int structureId, int orgUnitId, {bool hard = true}) async {
    try {
      await remoteDataSource.deleteOrgUnit(structureId, orgUnitId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

