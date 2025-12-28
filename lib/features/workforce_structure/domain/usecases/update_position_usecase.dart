import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/position_repository.dart';

class UpdatePositionUseCase {
  final PositionRepository repository;

  UpdatePositionUseCase({required this.repository});

  Future<Position> execute(int id, Map<String, dynamic> positionData) async {
    return await repository.updatePosition(id, positionData);
  }
}
