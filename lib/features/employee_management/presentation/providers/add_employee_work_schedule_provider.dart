import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeWorkScheduleState {
  final WorkSchedule? selectedWorkSchedule;
  final DateTime? wsStart;
  final DateTime? wsEnd;

  const AddEmployeeWorkScheduleState({this.selectedWorkSchedule, this.wsStart, this.wsEnd});

  int? get workScheduleId => selectedWorkSchedule?.workScheduleId;

  bool get isStepValid =>
      selectedWorkSchedule != null && wsStart != null && wsEnd != null && !wsEnd!.isBefore(wsStart!);
}

class AddEmployeeWorkScheduleNotifier extends StateNotifier<AddEmployeeWorkScheduleState> {
  AddEmployeeWorkScheduleNotifier() : super(const AddEmployeeWorkScheduleState());

  void setSelectedWorkSchedule(WorkSchedule? value) {
    state = AddEmployeeWorkScheduleState(selectedWorkSchedule: value, wsStart: state.wsStart, wsEnd: state.wsEnd);
  }

  void setWsStart(DateTime? value) {
    state = AddEmployeeWorkScheduleState(
      selectedWorkSchedule: state.selectedWorkSchedule,
      wsStart: value,
      wsEnd: state.wsEnd,
    );
  }

  void setWsEnd(DateTime? value) {
    state = AddEmployeeWorkScheduleState(
      selectedWorkSchedule: state.selectedWorkSchedule,
      wsStart: state.wsStart,
      wsEnd: value,
    );
  }

  void reset() {
    state = const AddEmployeeWorkScheduleState();
  }
}

final addEmployeeWorkScheduleProvider =
    StateNotifierProvider<AddEmployeeWorkScheduleNotifier, AddEmployeeWorkScheduleState>((ref) {
      return AddEmployeeWorkScheduleNotifier();
    });
