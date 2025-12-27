import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/structure_list_repository.dart';

/// Use case for getting structure list
class GetStructureListUseCase {
  final StructureListRepository repository;

  GetStructureListUseCase({required this.repository});

  /// Executes the use case to get paginated structure list
  /// 
  /// Returns [PaginatedStructureList]
  /// Throws [AppException] if the operation fails
  Future<PaginatedStructureList> call({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      if (page < 1) {
        throw ValidationException('Page number must be greater than 0');
      }
      if (pageSize < 1) {
        throw ValidationException('Page size must be greater than 0');
      }

      return await repository.getStructures(
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get structure list: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

