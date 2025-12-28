import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/position_repository.dart';

class CreatePositionUseCase {
  final PositionRepository repository;

  CreatePositionUseCase({required this.repository});

  Future<Position> call(Map<String, dynamic> positionData) async {
    return await repository.createPosition(positionData);
  }
}
