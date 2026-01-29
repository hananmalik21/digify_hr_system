import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_balances_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/leave_balances_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_balances_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveBalancesState {
  final PaginatedLeaveBalances? data;
  final bool isLoading;
  final String? error;

  const LeaveBalancesState({this.data, this.isLoading = false, this.error});

  LeaveBalancesState copyWith({PaginatedLeaveBalances? data, bool? isLoading, String? error}) {
    return LeaveBalancesState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final _leaveBalancesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leaveBalancesRemoteDataSourceProvider = Provider<LeaveBalancesRemoteDataSource>((ref) {
  final apiClient = ref.watch(_leaveBalancesApiClientProvider);
  return LeaveBalancesRemoteDataSourceImpl(apiClient: apiClient);
});

final leaveBalancesRepositoryProvider = Provider<LeaveBalancesRepository>((ref) {
  final remoteDataSource = ref.watch(leaveBalancesRemoteDataSourceProvider);
  return LeaveBalancesRepositoryImpl(remoteDataSource: remoteDataSource);
});

final leaveBalancesPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

class LeaveBalancesNotifier extends StateNotifier<LeaveBalancesState> {
  final LeaveBalancesRepository _repository;
  final Ref _ref;

  LeaveBalancesNotifier(this._repository, this._ref) : super(const LeaveBalancesState(isLoading: true)) {
    _ref.listen(leaveBalancesPaginationProvider, (previous, next) {
      if (previous != next) {
        _loadBalances();
      }
    });
    _ref.listen(leaveManagementEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        final pagination = _ref.read(leaveBalancesPaginationProvider);
        if (pagination.page != 1) {
          _ref.read(leaveBalancesPaginationProvider.notifier).state = (page: 1, pageSize: pagination.pageSize);
        } else {
          _loadBalances();
        }
      }
    });
    _loadBalances();
  }

  Future<void> _loadBalances() async {
    final pagination = _ref.read(leaveBalancesPaginationProvider);
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);

    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repository.getLeaveBalances(
        page: pagination.page,
        pageSize: pagination.pageSize,
        tenantId: tenantId,
      );
      state = state.copyWith(data: data, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load leave balances: ${e.toString()}', isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = const LeaveBalancesState(isLoading: true);
    final pagination = _ref.read(leaveBalancesPaginationProvider);
    if (pagination.page != 1) {
      _ref.read(leaveBalancesPaginationProvider.notifier).state = (page: 1, pageSize: pagination.pageSize);
    } else {
      await _loadBalances();
    }
  }

  Future<void> updateLeaveBalance(String employeeLeaveBalanceGuid, UpdateLeaveBalanceParams params) async {
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
    await _repository.updateLeaveBalance(employeeLeaveBalanceGuid, params, tenantId: tenantId);

    final current = state.data;
    if (current == null) return;

    final updated = current.balances.map((b) {
      if (b.employeeLeaveBalanceGuid != employeeLeaveBalanceGuid) return b;
      return b.copyWith(
        openingBalanceDays: params.openingBalanceDays,
        accruedDays: params.accruedDays,
        takenDays: params.takenDays,
        adjustedDays: params.adjustedDays,
        availableDays: params.availableDays,
        status: params.status,
      );
    }).toList();

    state = state.copyWith(
      data: PaginatedLeaveBalances(balances: updated, pagination: current.pagination),
    );
  }
}

final leaveBalancesNotifierProvider = StateNotifierProvider<LeaveBalancesNotifier, LeaveBalancesState>((ref) {
  final repository = ref.watch(leaveBalancesRepositoryProvider);
  return LeaveBalancesNotifier(repository, ref);
});

final leaveBalancesProvider = Provider<AsyncValue<PaginatedLeaveBalances>>((ref) {
  final state = ref.watch(leaveBalancesNotifierProvider);

  if (state.isLoading && state.data == null) {
    return const AsyncValue.loading();
  }

  if (state.error != null && state.data == null) {
    return AsyncValue.error(Exception(state.error!), StackTrace.current);
  }

  if (state.data != null) {
    return AsyncValue.data(state.data!);
  }

  return const AsyncValue.loading();
});

final leaveBalancesRefreshProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(leaveBalancesNotifierProvider.notifier).refresh();
  };
});
