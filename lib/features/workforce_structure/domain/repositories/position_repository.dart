import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position_response.dart';

/// Position repository interface
/// Defines the contract for position data operations
abstract class PositionRepository {
  Future<PositionResponse> getPositions({int page = 1, int pageSize = 10});
  Future<Position> createPosition(Map<String, dynamic> positionData);
  Future<void> deletePosition(int id, {bool hard = true});
}
