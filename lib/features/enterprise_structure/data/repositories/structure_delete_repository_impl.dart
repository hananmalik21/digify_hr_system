import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/structure_delete_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/structure_delete_repository.dart';

/// Implementation of StructureDeleteRepository
class StructureDeleteRepositoryImpl implements StructureDeleteRepository {
  final StructureDeleteRemoteDataSource remoteDataSource;

  StructureDeleteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> deleteStructure({
    required int structureId,
    bool? hard,
    bool? autoFallback,
  }) async {
    try {
      final result = await remoteDataSource.deleteStructure(
        structureId: structureId,
        hard: hard,
        autoFallback: autoFallback,
      );
      return result;
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

