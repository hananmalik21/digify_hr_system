import 'package:digify_hr_system/features/leave_management/domain/models/paginated_policies.dart';

abstract class AbsPoliciesRepository {
  Future<PaginatedPolicies> getPolicies({required int tenantId, int page = 1, int pageSize = 10});
}
