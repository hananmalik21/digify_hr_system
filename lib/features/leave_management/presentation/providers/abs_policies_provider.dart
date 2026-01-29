import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/abs_policies_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/abs_policies_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/paginated_policies.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/abs_policies_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbsPoliciesState {
  final PaginatedPolicies? data;
  final bool isLoading;
  final String? error;

  const AbsPoliciesState({this.data, this.isLoading = false, this.error});

  AbsPoliciesState copyWith({PaginatedPolicies? data, bool? isLoading, String? error}) {
    return AbsPoliciesState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final _absPoliciesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final absPoliciesRemoteDataSourceProvider = Provider<AbsPoliciesRemoteDataSource>((ref) {
  final apiClient = ref.watch(_absPoliciesApiClientProvider);
  return AbsPoliciesRemoteDataSourceImpl(apiClient: apiClient);
});

final absPoliciesRepositoryProvider = Provider<AbsPoliciesRepository>((ref) {
  final remoteDataSource = ref.watch(absPoliciesRemoteDataSourceProvider);
  return AbsPoliciesRepositoryImpl(remoteDataSource: remoteDataSource);
});

final absPoliciesPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

class AbsPoliciesNotifier extends StateNotifier<AbsPoliciesState> {
  final AbsPoliciesRepository _repository;
  final Ref _ref;

  AbsPoliciesNotifier(this._repository, this._ref) : super(const AbsPoliciesState(isLoading: true)) {
    _ref.listen(absPoliciesPaginationProvider, (previous, next) {
      if (previous != next) _load();
    });
    _ref.listen(leaveManagementEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        final pagination = _ref.read(absPoliciesPaginationProvider);
        if (pagination.page != 1) {
          _ref.read(absPoliciesPaginationProvider.notifier).state = (page: 1, pageSize: pagination.pageSize);
        } else {
          _load();
        }
      }
    });
    _load();
  }

  Future<void> _load() async {
    final pagination = _ref.read(absPoliciesPaginationProvider);
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);

    state = state.copyWith(isLoading: true, error: null);

    if (tenantId == null) {
      state = state.copyWith(data: PaginatedPolicies.empty, isLoading: false, error: null);
      return;
    }

    try {
      final data = await _repository.getPolicies(
        tenantId: tenantId,
        page: pagination.page,
        pageSize: pagination.pageSize,
      );
      state = state.copyWith(data: data, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load leave policies: ${e.toString()}', isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = const AbsPoliciesState(isLoading: true);
    final pagination = _ref.read(absPoliciesPaginationProvider);
    if (pagination.page != 1) {
      _ref.read(absPoliciesPaginationProvider.notifier).state = (page: 1, pageSize: pagination.pageSize);
    } else {
      await _load();
    }
  }
}

final absPoliciesNotifierProvider = StateNotifierProvider<AbsPoliciesNotifier, AbsPoliciesState>((ref) {
  final repository = ref.watch(absPoliciesRepositoryProvider);
  return AbsPoliciesNotifier(repository, ref);
});

final absPoliciesProvider = Provider<AsyncValue<PaginatedPolicies>>((ref) {
  final state = ref.watch(absPoliciesNotifierProvider);
  if (state.error != null) {
    return AsyncValue.error(Exception(state.error!), StackTrace.current);
  }
  if (state.isLoading && state.data == null) {
    return const AsyncValue.loading();
  }
  if (state.data != null) {
    return AsyncValue.data(state.data!);
  }
  return const AsyncValue.loading();
});
