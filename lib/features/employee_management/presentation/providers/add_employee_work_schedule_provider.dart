import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeWorkScheduleState {
  final WorkSchedule? selectedWorkSchedule;

  const AddEmployeeWorkScheduleState({this.selectedWorkSchedule});

  int? get workScheduleId => selectedWorkSchedule?.workScheduleId;
}

class AddEmployeeWorkScheduleNotifier extends StateNotifier<AddEmployeeWorkScheduleState> {
  AddEmployeeWorkScheduleNotifier() : super(const AddEmployeeWorkScheduleState());

  void setSelectedWorkSchedule(WorkSchedule? value) {
    state = AddEmployeeWorkScheduleState(selectedWorkSchedule: value);
  }

  void reset() {
    state = const AddEmployeeWorkScheduleState();
  }
}

final addEmployeeWorkScheduleProvider =
    StateNotifierProvider<AddEmployeeWorkScheduleNotifier, AddEmployeeWorkScheduleState>((ref) {
      return AddEmployeeWorkScheduleNotifier();
    });
