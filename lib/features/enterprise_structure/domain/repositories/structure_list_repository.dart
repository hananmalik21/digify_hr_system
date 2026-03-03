import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';

abstract class StructureListRepository {
  Future<PaginatedStructureList> getStructures({required int enterpriseId, int page = 1, int pageSize = 10});
}
