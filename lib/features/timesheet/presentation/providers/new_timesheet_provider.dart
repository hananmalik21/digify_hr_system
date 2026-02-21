import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTimesheetFormState {
  final int? employeeId;
  final String? employeeName;
  final String? projectName;
  final String? position;
  final String? departmentId;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isLoading;
  final List<DateTime> weekDays;

  const NewTimesheetFormState({
    this.employeeId,
    this.employeeName,
    this.projectName,
    this.startDate,
    this.endDate,
    this.position,
    this.departmentId,
    this.description,
    this.isLoading = false,
    this.weekDays = const [],
  });

  NewTimesheetFormState copyWith({
    int? employeeId,
    String? employeeName,
    String? projectName,
    DateTime? startDate,
    DateTime? endDate,
    String? position,
    String? departmentId,
    String? description,
    bool? isLoading,
    List<DateTime>? weekDays,
  }) {
    return NewTimesheetFormState(
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      projectName: projectName ?? this.projectName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      position: position ?? this.position,
      departmentId: departmentId ?? this.departmentId,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      weekDays: weekDays ?? this.weekDays,
    );
  }
}

class NewTimesheetNotifier extends StateNotifier<NewTimesheetFormState> {
  NewTimesheetNotifier()
    : super(
        NewTimesheetFormState(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 6)),
          weekDays: _generateWeekDays(DateTime.now()),
        ),
      );
  static List<DateTime> _generateWeekDays(DateTime start) {
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  void setEmployee({int? employeeId, String? employeeName}) {
    state = state.copyWith(employeeId: employeeId, employeeName: employeeName);
  }

  void setProjectName(String? projectName) {
    state = state.copyWith(projectName: projectName);
  }

  void setPosition(String? position) {
    state = state.copyWith(position: position);
  }

  void setDepartmentId(String? departmentId) {
    state = state.copyWith(departmentId: departmentId);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void setStartDate(DateTime? startDate) {
    state = state.copyWith(startDate: startDate);

    final end = startDate?.add(const Duration(days: 6));

    state = state.copyWith(endDate: end);

    if (startDate != null) {
      final weekDays = List.generate(
        7,
        (index) => startDate.add(Duration(days: index)),
      );

      state = state.copyWith(weekDays: weekDays);
    }
  }

  void setEndDate(DateTime? endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    state = NewTimesheetFormState(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 6)),
      weekDays: _generateWeekDays(DateTime.now()),
    );
  }
}

final newTimesheetProvider =
    StateNotifierProvider<NewTimesheetNotifier, NewTimesheetFormState>(
      (ref) => NewTimesheetNotifier(),
    );
