import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../data/repositories/attendance_summary_repository_impl.dart';
import '../../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../../domain/repositories/attendance_summary_repository.dart';
import '../../../domain/usecases/attendance_summary/get_attendance_summary_usecase.dart';

final attendanceSummaryRepositoryProvider =
    Provider<AttendanceSummaryRepository>(
      (ref) => AttendanceSummaryRepositoryImpl(),
    );

final getAttendanceSummaryUseCaseProvider =
    Provider<GetAttendanceSummaryUseCase>((ref) {
      final repository = ref.watch(attendanceSummaryRepositoryProvider);
      return GetAttendanceSummaryUseCase(repository: repository);
    });

class AttendanceSummary {
  final String? companyId;
  final String? orgUnitId;
  final String? levelCode;
  final String? date;
  final int? page;
  final int? pageSize;
  final List<AttendanceSummaryRecord> records;
  bool isLoading;
  bool clearError;
  String? error;

  AttendanceSummary({
    this.companyId,
    this.orgUnitId,
    this.levelCode,
    this.date,
    this.page,
    this.pageSize,
    this.records = const [],
    this.isLoading = false,
    this.clearError = true,
    this.error,
  });

  AttendanceSummary copyWith({
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    int? page,
    int? pageSize,
    List<AttendanceSummaryRecord>? records,
    bool? isLoading,
    bool? clearError,
    String? error,
    bool clearOrgFilter = false,
  }) {
    return AttendanceSummary(
      companyId: companyId ?? this.companyId,
      orgUnitId: clearOrgFilter ? null : (orgUnitId ?? this.orgUnitId),
      levelCode: clearOrgFilter ? null : (levelCode ?? this.levelCode),
      date: date ?? this.date,
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
    );
  }
}

class AttendanceSummaryNotifier extends StateNotifier<AttendanceSummary> {
  final AttendanceSummaryRepository _repository;
  AttendanceSummaryNotifier(this._repository) : super(AttendanceSummary()) {
    loadAttendanceSummary();
  }

  /// Refresh Attendance Summary
  Future<void> refresh() async {
    await loadAttendanceSummary();
  }

  Future<void> loadAttendanceSummary() async {
    if (state.companyId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final records = await _repository.getAttendanceSummaryRecords(
        companyId: state.companyId!,
        orgUnitId: state.orgUnitId,
        levelCode: state.levelCode,
        date: state.date,
        page: state.page,
        pageSize: state.pageSize,
      );

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

  /// Set Company ID
  void setCompanyId(String companyId) {
    state = state.copyWith(companyId: companyId);
    loadAttendanceSummary();
  }

  /// Set Org Filter
  void setOrgFilter(String? orgUnitId, String? levelCode) {
    state = state.copyWith(
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      clearOrgFilter: orgUnitId == null && levelCode == null,
    );
    loadAttendanceSummary();
  }

  /// Set Page
  void setPage(int page) {
    state = state.copyWith(page: page);
    loadAttendanceSummary();
  }

  /// Set Page Size
  void setPageSize(int pageSize) {
    state = state.copyWith(pageSize: pageSize);
    loadAttendanceSummary();
  }

  /// Set Date
  void setDate(String? date) {
    state = state.copyWith(date: date);
    loadAttendanceSummary();
  }
}

final attendanceSummaryProvider =
    StateNotifierProvider<AttendanceSummaryNotifier, AttendanceSummary>((ref) {
      final repository = ref.watch(attendanceSummaryRepositoryProvider);
      return AttendanceSummaryNotifier(repository);
    });
