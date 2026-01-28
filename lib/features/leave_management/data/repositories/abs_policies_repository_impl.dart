import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/abs_policies_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/paginated_policies.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/abs_policies_repository.dart';

class AbsPoliciesRepositoryImpl implements AbsPoliciesRepository {
  final AbsPoliciesRemoteDataSource remoteDataSource;

  AbsPoliciesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedPolicies> getPolicies({required int tenantId, int page = 1, int pageSize = 10}) async {
    try {
      final dto = await remoteDataSource.getPolicies(tenantId: tenantId, page: page, pageSize: pageSize);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }
}
