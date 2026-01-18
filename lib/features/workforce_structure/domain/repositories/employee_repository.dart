import 'package:digify_hr_system/features/workforce_structure/domain/models/paginated_employees.dart';

abstract class EmployeeRepository {
  Future<PaginatedEmployees> getEmployees({required int enterpriseId, String? search, int page = 1, int pageSize = 10});
}
