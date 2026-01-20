import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_policies_local_data_source.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_policies_repository.dart';

/// Implementation of LeavePoliciesRepository
class LeavePoliciesRepositoryImpl implements LeavePoliciesRepository {
  final LeavePoliciesLocalDataSource localDataSource;

  LeavePoliciesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<LeavePolicy>> getLeavePolicies() async {
    try {
      return localDataSource.getLeavePolicies();
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }
}
