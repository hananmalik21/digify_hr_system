import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';

abstract class WorkPatternRepository {
  Future<PaginatedWorkPatterns> getWorkPatterns({int page = 1, int pageSize = 10});
}
