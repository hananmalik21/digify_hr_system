import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/division_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/division.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/division_repository.dart';

/// Implementation of DivisionRepository
class DivisionRepositoryImpl implements DivisionRepository {
  final DivisionRemoteDataSource remoteDataSource;

  DivisionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DivisionOverview>> getDivisions({
    String? search,
    int? page,
    int? pageSize,
  }) async {
    try {
      final dtos = await remoteDataSource.getDivisions(
        search: search,
        page: page,
        pageSize: pageSize,
      );
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
  Future<DivisionOverview> createDivision(Map<String, dynamic> divisionData) async {
    try {
      final dto = await remoteDataSource.createDivision(divisionData);
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
  Future<DivisionOverview> updateDivision(int divisionId, Map<String, dynamic> divisionData) async {
    try {
      final dto = await remoteDataSource.updateDivision(divisionId, divisionData);
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
  Future<void> deleteDivision(int divisionId, {bool hard = true}) async {
    try {
      await remoteDataSource.deleteDivision(divisionId, hard: hard);
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

