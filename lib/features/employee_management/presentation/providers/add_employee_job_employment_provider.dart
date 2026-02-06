import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeJobEmploymentState {
  final Position? selectedPosition;
  final JobFamily? selectedJobFamily;
  final JobLevel? selectedJobLevel;
  final Grade? selectedGrade;

  const AddEmployeeJobEmploymentState({
    this.selectedPosition,
    this.selectedJobFamily,
    this.selectedJobLevel,
    this.selectedGrade,
  });

  AddEmployeeJobEmploymentState copyWith({
    Position? selectedPosition,
    JobFamily? selectedJobFamily,
    JobLevel? selectedJobLevel,
    Grade? selectedGrade,
    bool clearPosition = false,
    bool clearJobFamily = false,
    bool clearJobLevel = false,
    bool clearGrade = false,
  }) {
    return AddEmployeeJobEmploymentState(
      selectedPosition: clearPosition ? null : (selectedPosition ?? this.selectedPosition),
      selectedJobFamily: clearJobFamily ? null : (selectedJobFamily ?? this.selectedJobFamily),
      selectedJobLevel: clearJobLevel ? null : (selectedJobLevel ?? this.selectedJobLevel),
      selectedGrade: clearGrade ? null : (selectedGrade ?? this.selectedGrade),
    );
  }
}

class AddEmployeeJobEmploymentNotifier extends StateNotifier<AddEmployeeJobEmploymentState> {
  AddEmployeeJobEmploymentNotifier() : super(const AddEmployeeJobEmploymentState());

  void setPosition(Position? value) {
    state = state.copyWith(selectedPosition: value, clearPosition: value == null);
  }

  void setJobFamily(JobFamily? value) {
    state = state.copyWith(selectedJobFamily: value, clearJobFamily: value == null);
  }

  void setJobLevel(JobLevel? value) {
    state = state.copyWith(selectedJobLevel: value, clearJobLevel: value == null);
  }

  void setGrade(Grade? value) {
    state = state.copyWith(selectedGrade: value, clearGrade: value == null);
  }

  void reset() {
    state = const AddEmployeeJobEmploymentState();
  }
}

final addEmployeeJobEmploymentProvider =
    StateNotifierProvider<AddEmployeeJobEmploymentNotifier, AddEmployeeJobEmploymentState>((ref) {
      return AddEmployeeJobEmploymentNotifier();
    });
