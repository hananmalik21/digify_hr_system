import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_policies_local_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/leave_policies_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for leave policies local data source
final leavePoliciesLocalDataSourceProvider = Provider<LeavePoliciesLocalDataSource>(
  (ref) => LeavePoliciesLocalDataSourceImpl(),
);

/// Provider for leave policies repository
final leavePoliciesRepositoryProvider = Provider<LeavePoliciesRepositoryImpl>(
  (ref) => LeavePoliciesRepositoryImpl(localDataSource: ref.watch(leavePoliciesLocalDataSourceProvider)),
);

/// Provider for leave policies
final leavePoliciesProvider = FutureProvider<List<LeavePolicy>>((ref) async {
  final repository = ref.watch(leavePoliciesRepositoryProvider);
  try {
    return await repository.getLeavePolicies();
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load leave policies: ${e.toString()}');
  }
});
