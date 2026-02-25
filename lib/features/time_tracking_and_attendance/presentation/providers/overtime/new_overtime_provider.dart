import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewOvertimeRequestFormState {
  final int? employeeId;
  final String? employeeName;
  final DateTime? date;
  final String? overtimeType;
  final String? numberOfHours;
  final String? reason;

  final bool isLoading;

  const NewOvertimeRequestFormState({
    this.employeeId,
    this.employeeName,
    this.date,
    this.overtimeType,
    this.numberOfHours,
    this.reason,
    this.isLoading = false,
  });

  NewOvertimeRequestFormState copyWith({
    int? employeeId,
    String? employeeName,
    DateTime? date,
    String? overtimeType,
    String? numberOfHours,
    String? reason,
    bool? isLoading,
  }) {
    return NewOvertimeRequestFormState(
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      date: date ?? this.date,
      overtimeType: overtimeType ?? this.overtimeType,
      numberOfHours: numberOfHours ?? this.numberOfHours,
      reason: reason ?? this.reason,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NewOvertimeRequestNotifier
    extends StateNotifier<NewOvertimeRequestFormState> {
  NewOvertimeRequestNotifier()
    : super(NewOvertimeRequestFormState(date: DateTime.now()));

  void setEmployee({int? employeeId, String? employeeName}) {
    state = state.copyWith(employeeId: employeeId, employeeName: employeeName);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(date: date);
  }

  void setOvertimeType(String? overtimeType) {
    state = state.copyWith(overtimeType: overtimeType);
  }

  void setNumberOfHours(String? numberOfHours) {
    state = state.copyWith(numberOfHours: numberOfHours);
  }

  void setReason(String? reason) {
    state = state.copyWith(reason: reason);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    state = NewOvertimeRequestFormState(date: DateTime.now());
  }
}

final newOvertimeRequestProvider =
    StateNotifierProvider<
      NewOvertimeRequestNotifier,
      NewOvertimeRequestFormState
    >((ref) => NewOvertimeRequestNotifier());
