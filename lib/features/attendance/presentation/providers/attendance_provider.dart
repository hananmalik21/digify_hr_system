import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance_record.dart';
import 'package:digify_hr_system/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

// Repository provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl();
});

class AttendanceState {
  final DateTime fromDate;
  final DateTime toDate;
  final String employeeNumber;
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
    : super(
        AttendanceState(
          fromDate: DateTime(2026, 2, 2),
          toDate: DateTime(2026, 2, 2),
        ),
      ) {
    // Load initial data
    loadAttendance();
  }

  /// Loads attendance records from repository
  Future<void> loadAttendance() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final attendances = await _repository.getAttendance(
        fromDate: state.fromDate,
        toDate: state.toDate,
        employeeNumber: state.employeeNumber.isEmpty
            ? null
            : state.employeeNumber,
      );

      // Convert Attendance domain models to AttendanceRecord for UI
      final records = attendances
          .map((a) => AttendanceRecord.fromAttendance(a))
          .toList();

      // Calculate statistics
      final stats = _calculateStatistics(attendances);

      state = state.copyWith(
        records: records,
        totalItems: records.length,
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

  /// Calculates attendance statistics from list of attendances
  Map<String, int> _calculateStatistics(List<Attendance> attendances) {
    final stats = <String, int>{
      'totalStaff': attendances.length,
      'present': 0,
      'late': 0,
      'absent': 0,
      'halfDay': 0,
      'onLeave': 0,
    };

    for (final attendance in attendances) {
      switch (attendance.status) {
        case AttendanceStatus.present:
          stats['present'] = (stats['present'] ?? 0) + 1;
          break;
        case AttendanceStatus.late:
          stats['late'] = (stats['late'] ?? 0) + 1;
          break;
        case AttendanceStatus.absent:
          stats['absent'] = (stats['absent'] ?? 0) + 1;
          break;
        case AttendanceStatus.halfDay:
          stats['halfDay'] = (stats['halfDay'] ?? 0) + 1;
          break;
        case AttendanceStatus.onLeave:
          stats['onLeave'] = (stats['onLeave'] ?? 0) + 1;
          break;
        case AttendanceStatus.early:
        case AttendanceStatus.officialWork:
        case AttendanceStatus.businessTrip:
          // These can be counted as present for statistics
          stats['present'] = (stats['present'] ?? 0) + 1;
          break;
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
}

// State Notifier Provider
final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
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
