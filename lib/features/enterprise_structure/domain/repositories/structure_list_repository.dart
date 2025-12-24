import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';

/// Repository interface for structure list operations
abstract class StructureListRepository {
  /// Gets paginated list of structures
  /// 
  /// Throws [AppException] if the operation fails
  Future<PaginatedStructureList> getStructures({
    int page = 1,
    int pageSize = 10,
  });
}

