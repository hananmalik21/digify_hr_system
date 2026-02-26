import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/repositories/attendance_repository_impl.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/repositories/attendance_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

// Repository provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AttendanceRepositoryImpl(apiClient: apiClient);
});

class AttendanceState {
  final DateTime fromDate;
  final DateTime toDate;
  final String employeeNumber;
  final String? companyId;
  final String? orgUnitId;
  final String? levelCode;
  final int totalStaff;
  final int present;
  final int lateCount;
  final int absent;
  final int halfDay;
  final int onLeave;
  final bool isLoading;
  final String? error;
  final List<AttendanceRecord> records;
  final int currentPage;
  final int pageSize;
  final int totalItems;

  const AttendanceState({
    required this.fromDate,
    required this.toDate,
    this.employeeNumber = '',
    this.companyId,
    this.orgUnitId,
    this.levelCode,
    this.totalStaff = 0,
    this.present = 0,
    this.lateCount = 0,
    this.absent = 0,
    this.halfDay = 0,
    this.onLeave = 0,
    this.isLoading = false,
    this.error,
    this.records = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
  });

  AttendanceState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? employeeNumber,
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    int? totalStaff,
    int? present,
    int? lateCount,
    int? absent,
    int? halfDay,
    int? onLeave,
    bool? isLoading,
    String? error,
    List<AttendanceRecord>? records,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    bool clearError = false,
  }) {
    return AttendanceState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      companyId: companyId ?? this.companyId,
      orgUnitId: orgUnitId ?? this.orgUnitId,
      levelCode: levelCode ?? this.levelCode,
      totalStaff: totalStaff ?? this.totalStaff,
      present: present ?? this.present,
      lateCount: lateCount ?? this.lateCount,
      absent: absent ?? this.absent,
      halfDay: halfDay ?? this.halfDay,
      onLeave: onLeave ?? this.onLeave,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      records: records ?? this.records,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceNotifier(this._repository)
    : super(AttendanceState(fromDate: DateTime(2026, 2, 2), toDate: DateTime(2026, 2, 2)));

  Future<void> loadAttendance() async {
    final enterpriseId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (enterpriseId == null) {
      state = state.copyWith(
        records: [],
        totalItems: 0,
        totalStaff: 0,
        present: 0,
        lateCount: 0,
        absent: 0,
        halfDay: 0,
        onLeave: 0,
        isLoading: false,
        clearError: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final page = await _repository.getAttendanceLogs(
        enterpriseId: enterpriseId,
        page: state.currentPage,
        pageSize: state.pageSize,
        orgUnitId: state.orgUnitId,
        levelCode: state.levelCode,
      );

      final stats = _calculateStatsFromRecords(page.records);

      state = state.copyWith(
        records: page.records,
        totalItems: page.total,
        currentPage: page.page,
        pageSize: page.pageSize,
        totalStaff: stats['totalStaff']!,
        present: stats['present']!,
        lateCount: stats['late']!,
        absent: stats['absent']!,
        halfDay: stats['halfDay']!,
        onLeave: stats['onLeave']!,
        isLoading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message, clearError: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load attendance: ${e.toString()}', clearError: false);
    }
  }

  Map<String, int> _calculateStatsFromRecords(List<AttendanceRecord> records) {
    final stats = <String, int>{
      'totalStaff': records.length,
      'present': 0,
      'late': 0,
      'absent': 0,
      'halfDay': 0,
      'onLeave': 0,
    };

    for (final r in records) {
      final s = r.status.toUpperCase();
      if (s.contains('PRESENT') ||
          s.contains('ON-TIME') ||
          s.contains('ONTIME') ||
          s.contains('EARLY') ||
          s.contains('OFFICIAL') ||
          s.contains('BUSINESS')) {
        stats['present'] = (stats['present'] ?? 0) + 1;
      } else if (s.contains('LATE')) {
        stats['late'] = (stats['late'] ?? 0) + 1;
      } else if (s.contains('ABSENT')) {
        stats['absent'] = (stats['absent'] ?? 0) + 1;
      } else if (s.contains('HALF')) {
        stats['halfDay'] = (stats['halfDay'] ?? 0) + 1;
      } else if (s.contains('LEAVE')) {
        stats['onLeave'] = (stats['onLeave'] ?? 0) + 1;
      } else if (s != '-' && s.isNotEmpty) {
        stats['present'] = (stats['present'] ?? 0) + 1;
      }
    }

    return stats;
  }

  /// Refreshes attendance data
  Future<void> refresh() async {
    await loadAttendance();
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
    loadAttendance();
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, currentPage: 1);
    loadAttendance();
  }

  void setFromDate(DateTime date) {
    state = state.copyWith(fromDate: date);
    loadAttendance();
  }

  void setToDate(DateTime date) {
    state = state.copyWith(toDate: date);
    loadAttendance();
  }

  void setEmployeeNumber(String number) {
    state = state.copyWith(employeeNumber: number);
    loadAttendance();
  }

  void setCompanyId(String companyId) {
    state = state.copyWith(companyId: companyId);
    loadAttendance();
  }

  void setOrgFilter(String? orgUnitId, String? levelCode) {
    state = state.copyWith(orgUnitId: orgUnitId, levelCode: levelCode);
    loadAttendance();
  }
}

// State Notifier Provider
final attendanceNotifierProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return AttendanceNotifier(repository);
});

// Convenience Providers
final attendanceProvider = Provider<AttendanceState>((ref) {
  return ref.watch(attendanceNotifierProvider);
});

final attendanceRecordsProvider = Provider<List<AttendanceRecord>>((ref) {
  return ref.watch(attendanceNotifierProvider).records;
});

final attendanceLoadingProvider = Provider<bool>((ref) {
  return ref.watch(attendanceNotifierProvider).isLoading;
});

final attendanceErrorProvider = Provider<String?>((ref) {
  return ref.watch(attendanceNotifierProvider).error;
});

final attendanceStatsProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(attendanceNotifierProvider);
  return {
    'totalStaff': state.totalStaff,
    'present': state.present,
    'late': state.lateCount,
    'absent': state.absent,
    'halfDay': state.halfDay,
    'onLeave': state.onLeave,
  };
});

final attendanceExpandedIndexProvider = StateProvider<int?>((ref) => null);
