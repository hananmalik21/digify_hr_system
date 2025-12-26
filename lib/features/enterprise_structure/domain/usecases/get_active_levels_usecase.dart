import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/org_structure_level_repository.dart';

/// Use case for getting active organization structure levels
class GetActiveLevelsUseCase {
  final OrgStructureLevelRepository repository;

  GetActiveLevelsUseCase({required this.repository});

  /// Executes the use case to get active levels
  ///
  /// Returns a list of [ActiveStructureLevel] sorted by display_order
  /// Throws [AppException] if the operation fails
  Future<List<ActiveStructureLevel>> call() async {
    try {
      return await repository.getActiveLevels();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get active levels: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

