import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_policies_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/leave_policies_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_policies_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_policies_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _leavePoliciesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leavePoliciesRemoteDataSourceProvider = Provider<LeavePoliciesRemoteDataSource>((ref) {
  final apiClient = ref.watch(_leavePoliciesApiClientProvider);
  return LeavePoliciesRemoteDataSourceImpl(apiClient: apiClient);
});

final leavePoliciesRepositoryProvider = Provider<LeavePoliciesRepository>((ref) {
  final remoteDataSource = ref.watch(leavePoliciesRemoteDataSourceProvider);
  return LeavePoliciesRepositoryImpl(remoteDataSource: remoteDataSource);
});

final leavePoliciesProvider = FutureProvider<List<LeavePolicy>>((ref) async {
  final tenantId = ref.watch(leaveManagementSelectedEnterpriseProvider);
  if (tenantId == null) return <LeavePolicy>[];

  final filter = ref.watch(leavePoliciesFilterProvider);
  String? kuwait;
  if (filter.type == 'kuwait_y') {
    kuwait = 'Y';
  } else if (filter.type == 'kuwait_n') {
    kuwait = 'N';
  }

  final repository = ref.watch(leavePoliciesRepositoryProvider);
  try {
    return await repository.getLeavePolicies(tenantId: tenantId, status: filter.status, kuwaitLaborCompliant: kuwait);
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load leave policies: ${e.toString()}');
  }
});
