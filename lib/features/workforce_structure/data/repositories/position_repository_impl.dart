import 'package:digify_hr_system/features/workforce_structure/data/datasources/position_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/position_repository.dart';

/// Position repository implementation
/// Implements the repository interface and delegates to data sources
class PositionRepositoryImpl implements PositionRepository {
  final PositionRemoteDataSource remoteDataSource;

  const PositionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await remoteDataSource.getPositions(page: page, pageSize: pageSize);
  }

  @override
  Future<Position> createPosition(Map<String, dynamic> positionData) async {
    return await remoteDataSource.createPosition(positionData);
  }

  @override
  Future<void> deletePosition(int id, {bool hard = true}) async {
    await remoteDataSource.deletePosition(id, hard: hard);
  }
}
