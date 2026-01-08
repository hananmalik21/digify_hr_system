import 'package:digify_hr_system/features/workforce_structure/domain/repositories/position_repository.dart';

class DeletePositionUseCase {
  final PositionRepository repository;

  DeletePositionUseCase({required this.repository});

  Future<void> execute(String id, {bool hard = true}) async {
    return await repository.deletePosition(id, hard: hard);
  }
}
