import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/org_structure_level_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/org_structure_level_repository.dart';

/// Implementation of OrgStructureLevelRepository
class OrgStructureLevelRepositoryImpl implements OrgStructureLevelRepository {
  final OrgStructureLevelRemoteDataSource remoteDataSource;

  OrgStructureLevelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ActiveStructureLevel>> getActiveLevels() async {
    try {
      final responseDto = await remoteDataSource.getActiveLevels();
      // Filter only active levels and sort by display_order
      final activeLevels = responseDto.levels
          .where((dto) => dto.isActive.toUpperCase() == 'Y')
          .map((dto) => dto.toDomain())
          .toList();
      activeLevels.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return activeLevels;
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

