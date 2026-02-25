import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../../../generated/assets.dart';
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

  _initializeMockData() {
    state = state.copyWith(
      categories: OvertimeCategory.values,
      selectedCategory: OvertimeCategory.all,
      stats: [
        OvertimeStat(
          title: 'Total Overtime',
          subTitle: '8 records',
          value: '25.0',
          icon: Assets.iconsTimeManagementIcon,
        ),
        OvertimeStat(
          title: 'Total Amount',
          subTitle: 'Overtime compensation',
          value: 'KKWD 1085.00',
          icon: Assets.leaveManagementDollar,
        ),
        OvertimeStat(
          title: 'Pending Approvals',
          subTitle: 'Awaiting manager review',
          value: '3',
          icon: Assets.iconsCheckIconGreen,
        ),
        OvertimeStat(
          title: 'Approved',
          subTitle: 'Ready for payroll',
          value: '4',
          icon: Assets.iconsCheckIconGreen,
        ),
      ],
      records: [],
    );
  }

  /// Loads attendance records from repository
  Future<void> loadOvertime() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final records = await _repository.getOvertimeRecords();

      state = state.copyWith(
        records: records,
        isLoading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
        clearError: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load attendance: ${e.toString()}',
        clearError: false,
      );
    }
  }

  void selectCategory(OvertimeCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleOvertimeRecord(String? id) {
    state = state.copyWith(expandedRecord: id);
  }
}

final overtimeManagementProvider =
    StateNotifierProvider<OvertimeManagementNotifier, OvertimeManagement>((
      ref,
    ) {
      final repo = ref.watch(overtimeRepositoryProvider);
      return OvertimeManagementNotifier(repo);
    });
