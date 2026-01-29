import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/abs_lookups_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/abs_lookups_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/abs_lookups_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _absLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _absLookupsRemoteDataSourceProvider = Provider<AbsLookupsRemoteDataSource>((ref) {
  final apiClient = ref.watch(_absLookupsApiClientProvider);
  return AbsLookupsRemoteDataSourceImpl(apiClient: apiClient);
});

final absLookupsRepositoryProvider = Provider<AbsLookupsRepository>((ref) {
  final dataSource = ref.watch(_absLookupsRemoteDataSourceProvider);
  return AbsLookupsRepositoryImpl(remoteDataSource: dataSource);
});

class AbsLookupsNotifier extends StateNotifier<AsyncValue<List<AbsLookup>>> {
  AbsLookupsNotifier(this._repository, this._ref) : super(const AsyncValue.data([])) {
    _ref.listen<int?>(leaveManagementEnterpriseIdProvider, (previous, next) {
      if (previous != next && next != null) fetch(next);
    });
  }

  final AbsLookupsRepository _repository;
  final Ref _ref;

  Future<void> fetch(int tenantId) async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getLookups(tenantId: tenantId);
      state = AsyncValue.data(list);
    } on AppException catch (e) {
      state = AsyncValue.error(Exception(e.message), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final absLookupsNotifierProvider = StateNotifierProvider<AbsLookupsNotifier, AsyncValue<List<AbsLookup>>>((ref) {
  final repository = ref.watch(absLookupsRepositoryProvider);
  return AbsLookupsNotifier(repository, ref);
});

/// Lookups grouped by [AbsLookup.lookupCode] for dropdowns (e.g. ACCRUAL_METHOD, CONTRACT_TYPE).
final absLookupsByCodeProvider = Provider<Map<String, List<AbsLookup>>>((ref) {
  final async = ref.watch(absLookupsNotifierProvider);
  return async.when(
    data: (list) {
      final map = <String, List<AbsLookup>>{};
      for (final l in list) {
        map.putIfAbsent(l.lookupCode, () => []).add(l);
      }
      return map;
    },
    loading: () => <String, List<AbsLookup>>{},
    error: (_, __) => <String, List<AbsLookup>>{},
  );
});

final absLookupValuesByCodeProvider =
    StateNotifierProvider<AbsLookupValuesNotifier, AsyncValue<Map<String, List<AbsLookupValue>>>>((ref) {
      final repository = ref.watch(absLookupsRepositoryProvider);
      return AbsLookupValuesNotifier(repository, ref);
    });

class AbsLookupValuesNotifier extends StateNotifier<AsyncValue<Map<String, List<AbsLookupValue>>>> {
  AbsLookupValuesNotifier(this._repository, this._ref) : super(const AsyncValue.data({})) {
    _ref.listen<AsyncValue<List<AbsLookup>>>(absLookupsNotifierProvider, (_, __) => _maybeFetch());
    _ref.listen<int?>(leaveManagementEnterpriseIdProvider, (_, __) => _maybeFetch());
    _maybeFetch();
  }

  final AbsLookupsRepository _repository;
  final Ref _ref;

  int? get _tenantId => _ref.read(leaveManagementEnterpriseIdProvider);

  void _maybeFetch() {
    final async = _ref.read(absLookupsNotifierProvider);
    final tenantId = _tenantId;
    if (async.valueOrNull == null || async.value!.isEmpty || tenantId == null) {
      return;
    }
    fetch(async.value!, tenantId);
  }

  Future<void> fetchForTenant(int tenantId) async {
    final async = _ref.read(absLookupsNotifierProvider);
    final lookups = async.valueOrNull;
    if (lookups == null || lookups.isEmpty) return;
    await fetch(lookups, tenantId);
  }

  Future<void> fetch(List<AbsLookup> lookups, int tenantId) async {
    state = const AsyncValue.loading();
    try {
      final map = <String, List<AbsLookupValue>>{};
      for (final lookup in lookups) {
        final values = await _repository.getLookupValues(lookupId: lookup.lookupId, tenantId: tenantId);
        final active = values.where((v) => v.isActive).toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        map[lookup.lookupCode] = active;
      }
      state = AsyncValue.data(map);
    } on AppException catch (e) {
      state = AsyncValue.error(Exception(e.message), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Lookup values for a given [AbsLookupCode]. Use enum instead of raw strings.
final absLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, lookupCode) {
  final async = ref.watch(absLookupValuesByCodeProvider);
  return async.valueOrNull?[lookupCode.code] ?? [];
});
