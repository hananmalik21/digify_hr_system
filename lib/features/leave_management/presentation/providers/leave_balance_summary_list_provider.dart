import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balance_summary_list_state.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveBalanceSummaryListNotifier extends Notifier<LeaveBalanceSummaryListState> {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  Debouncer? _searchDebouncer;

  @override
  LeaveBalanceSummaryListState build() {
    ref.onDispose(() {
      _searchDebouncer?.dispose();
      _searchDebouncer = null;
    });
    ref.listen<int?>(leaveManagementEnterpriseIdProvider, (previous, next) {
      if (next != null && previous != next) {
        state = state.copyWith(items: [], pagination: null, clearSearchQuery: true, lastEnterpriseId: next);
        loadPage(next, 1);
      } else if (next != null) {
        state = state.copyWith(lastEnterpriseId: next);
      }
    });
    final enterpriseId = ref.read(leaveManagementEnterpriseIdProvider);
    return LeaveBalanceSummaryListState(lastEnterpriseId: enterpriseId);
  }

  void setSearchQueryInput(String value) {
    _searchDebouncer ??= Debouncer(delay: _searchDebounceDuration);
    final trimmed = value.trim();
    _searchDebouncer!.run(() => search(trimmed));
  }

  void search(String query) {
    _searchDebouncer?.dispose();
    _searchDebouncer = null;
    final enterpriseId = ref.read(leaveManagementEnterpriseIdProvider);
    if (enterpriseId == null) return;
    final q = query.trim();
    if (q.isEmpty) {
      state = state.copyWith(clearSearchQuery: true);
      loadPage(enterpriseId, 1, search: null);
      return;
    }
    loadPage(enterpriseId, 1, search: q);
  }

  Future<void> loadPage(int enterpriseId, int page, {int pageSize = 10, String? search}) async {
    final effectiveSearch = search ?? state.searchQuery;
    state = state.copyWith(
      isLoading: true,
      error: null,
      lastEnterpriseId: enterpriseId,
      currentPage: page,
      searchQuery: effectiveSearch,
    );
    final repository = ref.read(leaveBalancesRepositoryProvider);
    try {
      final result = await repository.getLeaveBalanceSummaries(
        page: page,
        pageSize: pageSize,
        tenantId: enterpriseId,
        search: effectiveSearch,
      );
      state = state.copyWith(
        items: result.items,
        pagination: result.pagination,
        isLoading: false,
        error: null,
        searchQuery: effectiveSearch,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> goToPage(int page, {int pageSize = 10}) async {
    final enterpriseId = state.lastEnterpriseId;
    if (enterpriseId == null) return;
    await loadPage(enterpriseId, page, pageSize: pageSize);
  }

  Future<void> refresh() async {
    final enterpriseId = state.lastEnterpriseId;
    if (enterpriseId == null) return;
    await loadPage(enterpriseId, state.currentPage);
  }

  void updateItemBalances(int employeeId, {required double annualLeave, required double sickLeave}) {
    final index = state.items.indexWhere((e) => e.employeeId == employeeId);
    if (index < 0) return;
    final item = state.items[index];
    final updated = item.copyWith(
      annualLeave: annualLeave,
      sickLeave: sickLeave,
      totalAvailable: annualLeave + sickLeave,
    );
    final newItems = List<LeaveBalanceSummaryItem>.from(state.items)..[index] = updated;
    state = state.copyWith(items: newItems);
  }
}

final leaveBalanceSummaryListProvider = NotifierProvider<LeaveBalanceSummaryListNotifier, LeaveBalanceSummaryListState>(
  LeaveBalanceSummaryListNotifier.new,
);
