import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionFormState {
  final String? employmentType;
  final bool isActive;
  final JobFamily? jobFamily;
  final JobLevel? jobLevel;
  final Grade? grade;
  final String? step;

  const PositionFormState({
    this.employmentType = 'FULL_TIME',
    this.isActive = true,
    this.jobFamily,
    this.jobLevel,
    this.grade,
    this.step,
  });

  PositionFormState copyWith({
    String? employmentType,
    bool? isActive,
    JobFamily? jobFamily,
    JobLevel? jobLevel,
    Grade? grade,
    String? step,
  }) {
    return PositionFormState(
      employmentType: employmentType ?? this.employmentType,
      isActive: isActive ?? this.isActive,
      jobFamily: jobFamily ?? this.jobFamily,
      jobLevel: jobLevel ?? this.jobLevel,
      grade: grade ?? this.grade,
      step: step ?? this.step,
    );
  }
}

class PositionFormNotifier extends StateNotifier<PositionFormState> {
  PositionFormNotifier() : super(const PositionFormState());

  void setEmploymentType(String? value) {
    state = state.copyWith(employmentType: value);
  }

  void setIsActive(bool value) {
    state = state.copyWith(isActive: value);
  }

  void setJobFamily(JobFamily? value) {
    state = state.copyWith(jobFamily: value);
  }

  void setJobLevel(JobLevel? value) {
    state = state.copyWith(jobLevel: value);
  }

  void setGrade(Grade? value) {
    state = state.copyWith(grade: value);
  }

  void setStep(String? value) {
    state = state.copyWith(step: value);
  }

  void reset() {
    state = const PositionFormState();
  }

  void initialize({String? employmentType, bool? isActive, String? step}) {
    state = state.copyWith(
      employmentType: employmentType ?? state.employmentType,
      isActive: isActive ?? state.isActive,
      step: step ?? state.step,
    );
  }
}

final positionFormNotifierProvider =
    StateNotifierProvider.autoDispose<PositionFormNotifier, PositionFormState>((
      ref,
    ) {
      return PositionFormNotifier();
    });
