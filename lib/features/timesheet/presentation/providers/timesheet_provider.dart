import 'package:digify_hr_system/features/timesheet/data/repositories/timesheet_repository_impl.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet_status.dart';
import 'package:digify_hr_system/features/timesheet/domain/repositories/timesheet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final timesheetRepositoryProvider = Provider<TimesheetRepository>((ref) {
  return TimesheetRepositoryImpl();
});

class TimesheetState {
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final String searchQuery;
  final TimesheetStatus? statusFilter;
  final String? companyId;
  final String? divisionId;
  final String? departmentId;
  final String? sectionId;
  final int total;
  final int draft;
  final int submitted;
  final int approved;
  final int rejected;
  final double regularHours;
  final double overtimeHours;
  final bool isLoading;
  final String? error;
  final List<Timesheet> records;
  final int currentPage;
  final int pageSize;
  final int totalItems;

  const TimesheetState({
    required this.weekStartDate,
    required this.weekEndDate,
    this.searchQuery = '',
    this.statusFilter,
    this.companyId,
    this.divisionId,
    this.departmentId,
    this.sectionId,
    this.total = 0,
    this.draft = 0,
    this.submitted = 0,
    this.approved = 0,
    this.rejected = 0,
    this.regularHours = 0.0,
    this.overtimeHours = 0.0,
    this.isLoading = false,
    this.error,
    this.records = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
  });

  TimesheetState copyWith({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? searchQuery,
    TimesheetStatus? statusFilter,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    int? total,
    int? draft,
    int? submitted,
    int? approved,
    int? rejected,
    double? regularHours,
    double? overtimeHours,
    bool? isLoading,
    String? error,
    List<Timesheet>? records,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    bool clearError = false,
    bool clearStatusFilter = false,
  }) {
    return TimesheetState(
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      companyId: companyId ?? this.companyId,
      divisionId: divisionId ?? this.divisionId,
      departmentId: departmentId ?? this.departmentId,
      sectionId: sectionId ?? this.sectionId,
      total: total ?? this.total,
      draft: draft ?? this.draft,
      submitted: submitted ?? this.submitted,
      approved: approved ?? this.approved,
      rejected: rejected ?? this.rejected,
      regularHours: regularHours ?? this.regularHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      records: records ?? this.records,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class TimesheetNotifier extends StateNotifier<TimesheetState> {
  final TimesheetRepository _repository;

  TimesheetNotifier(this._repository)
    : super(TimesheetState(weekStartDate: _getWeekStart(DateTime.now()), weekEndDate: _getWeekEnd(DateTime.now()))) {
    loadTimesheets();
  }

  static DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  static DateTime _getWeekEnd(DateTime date) {
    final weekday = date.weekday;
    return date.add(Duration(days: 7 - weekday));
  }

  /// Loads timesheets from repository
  Future<void> loadTimesheets() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Load statistics
      final stats = await _repository.getTimesheetStatistics(
        weekStartDate: state.weekStartDate,
        weekEndDate: state.weekEndDate,
        companyId: state.companyId,
        divisionId: state.divisionId,
        departmentId: state.departmentId,
        sectionId: state.sectionId,
      );

      // Load timesheets
      final timesheets = await _repository.getTimesheets(
        weekStartDate: state.weekStartDate,
        weekEndDate: state.weekEndDate,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
        status: state.statusFilter,
        companyId: state.companyId,
        divisionId: state.divisionId,
        departmentId: state.departmentId,
        sectionId: state.sectionId,
        page: state.currentPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        records: timesheets,
        totalItems: timesheets.length,
        total: stats['total'] as int? ?? 0,
        draft: stats['draft'] as int? ?? 0,
        submitted: stats['submitted'] as int? ?? 0,
        approved: stats['approved'] as int? ?? 0,
        rejected: stats['rejected'] as int? ?? 0,
        regularHours: (stats['regularHours'] as num?)?.toDouble() ?? 0.0,
        overtimeHours: (stats['overtimeHours'] as num?)?.toDouble() ?? 0.0,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load timesheets: ${e.toString()}', clearError: false);
    }
  }

  /// Refreshes timesheet data
  Future<void> refresh() async {
    await loadTimesheets();
  }

  void setWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    state = state.copyWith(weekStartDate: weekStart, weekEndDate: weekEnd);
    loadTimesheets();
  }

  void goToCurrentWeek() {
    final now = DateTime.now();
    setWeek(_getWeekStart(now));
  }

  void goToPreviousWeek() {
    final newStart = state.weekStartDate.subtract(const Duration(days: 7));
    setWeek(newStart);
  }

  void goToNextWeek() {
    final newStart = state.weekStartDate.add(const Duration(days: 7));
    setWeek(newStart);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadTimesheets();
  }

  void setStatusFilter(TimesheetStatus? status) {
    state = state.copyWith(statusFilter: status);
    loadTimesheets();
  }

  void setCompanyId(String? companyId) {
    state = state.copyWith(companyId: companyId, divisionId: null, departmentId: null, sectionId: null);
    loadTimesheets();
  }

  void setDivisionId(String? divisionId) {
    state = state.copyWith(divisionId: divisionId, departmentId: null, sectionId: null);
    loadTimesheets();
  }

  void setDepartmentId(String? departmentId) {
    state = state.copyWith(departmentId: departmentId, sectionId: null);
    loadTimesheets();
  }

  void setSectionId(String? sectionId) {
    state = state.copyWith(sectionId: sectionId);
    loadTimesheets();
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
    loadTimesheets();
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, currentPage: 1);
    loadTimesheets();
  }

  Future<void> approveTimesheet(int timesheetId) async {
    try {
      await _repository.approveTimesheet(timesheetId);
      await loadTimesheets();
    } catch (e) {
      state = state.copyWith(error: 'Failed to approve timesheet: ${e.toString()}', clearError: false);
    }
  }

  Future<void> rejectTimesheet(int timesheetId, String reason) async {
    try {
      await _repository.rejectTimesheet(timesheetId, reason: reason);
      await loadTimesheets();
    } catch (e) {
      state = state.copyWith(error: 'Failed to reject timesheet: ${e.toString()}', clearError: false);
    }
  }
}

// State Notifier Provider
final timesheetNotifierProvider = StateNotifierProvider<TimesheetNotifier, TimesheetState>((ref) {
  final repository = ref.watch(timesheetRepositoryProvider);
  return TimesheetNotifier(repository);
});
