import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/enums/overtime_status.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../data/repositories/overtime_repository_impl.dart';
import '../../../domain/models/overtime/overtime_management.dart';
import '../../../domain/repositories/overtime_repository.dart';

final overtimeRepositoryProvider = Provider<OvertimeRepository>((ref) {
  return OvertimeRepositoryImpl();
});

class OvertimeManagementNotifier extends StateNotifier<OvertimeManagement> {
  final OvertimeRepository _repository;
  OvertimeManagementNotifier(this._repository) : super(OvertimeManagement()) {
    _initializeMockData();
    loadOvertime();
  }

  void _initializeMockData() {
    state = state.copyWith(
      categories: OvertimeCategory.values,
      selectedCategory: OvertimeCategory.all,
      stats: [
        OvertimeStat(
          title: 'Total Overtime',
          subTitle: '8 records',
          value: '25.0',
          icon: Assets.icons.attendance.halfDay.path,
        ),
        OvertimeStat(
          title: 'Total Amount',
          subTitle: 'Overtime compensation',
          value: 'KKWD 1085.00',
          icon: Assets.icons.budgetGreenIcon.path,
        ),
        OvertimeStat(
          title: 'Pending Approvals',
          subTitle: 'Awaiting manager review',
          value: '3',
          icon: Assets.icons.errorCircleRed.path,
        ),
        OvertimeStat(
          title: 'Approved',
          subTitle: 'Ready for payroll',
          value: '4',
          icon: Assets.icons.activeStructureIcon.path,
        ),
      ],
      records: [],
    );
  }

  Future<void> loadOvertime({int? page}) async {
    final tenantId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (tenantId == null) {
      state = state.copyWith(records: [], isLoading: false, clearError: true);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    if (page != null) {
      state = state.copyWith(currentPage: page);
    }

    try {
      final pageToFetch = page ?? state.currentPage;
      final result = await _repository.getOvertimeRequests(
        tenantId: tenantId,
        status: state.selectedStatus?.apiValue,
        orgUnitId: state.orgUnitId,
        levelCode: state.orgLevelCode,
        page: pageToFetch,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        records: result.records,
        currentPage: result.page,
        pageSize: result.pageSize,
        totalItems: result.total,
        hasMore: result.hasMore,
        isLoading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message, clearError: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load overtime requests: ${e.toString()}',
        clearError: false,
      );
    }
  }

  void selectCategory(OvertimeCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void selectStatus(OvertimeStatus? status) {
    state = state.copyWith(selectedStatus: status, clearStatus: status == null, currentPage: 1);
    loadOvertime(page: 1);
  }

  void toggleOvertimeRecord(String? id) {
    state = state.copyWith(expandedRecord: id, clearExpandedRecord: id == null);
  }

  void setCompanyId(String? companyId) {
    if (state.companyId != companyId) {
      state = state.copyWith(companyId: companyId, clearOrgFilter: true);
      loadOvertime();
    }
  }

  void setOrgFilter(String? unitId, String? levelCode) {
    state = state.copyWith(orgUnitId: unitId, orgLevelCode: levelCode, clearOrgFilter: unitId == null, currentPage: 1);
    loadOvertime(page: 1);
  }

  void goToPage(int page) {
    loadOvertime(page: page);
  }
}

final overtimeManagementProvider = StateNotifierProvider<OvertimeManagementNotifier, OvertimeManagement>((ref) {
  final repo = ref.watch(overtimeRepositoryProvider);
  return OvertimeManagementNotifier(repo);
});
