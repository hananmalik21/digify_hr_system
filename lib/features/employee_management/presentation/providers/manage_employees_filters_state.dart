import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds filter values for the manage employees list API.
class ManageEmployeesFiltersState {
  final String? positionId;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final String? orgUnitId;
  final String? levelCode;

  const ManageEmployeesFiltersState({
    this.positionId,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.orgUnitId,
    this.levelCode,
  });

  bool get hasAnyFilter =>
      positionId != null ||
      jobFamilyId != null ||
      jobLevelId != null ||
      gradeId != null ||
      orgUnitId != null ||
      levelCode != null;

  ManageEmployeesFiltersState copyWith({
    String? positionId,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    String? orgUnitId,
    String? levelCode,
    bool clearPositionId = false,
    bool clearJobFamilyId = false,
    bool clearJobLevelId = false,
    bool clearGradeId = false,
    bool clearOrgUnitId = false,
    bool clearLevelCode = false,
  }) {
    return ManageEmployeesFiltersState(
      positionId: clearPositionId ? null : (positionId ?? this.positionId),
      jobFamilyId: clearJobFamilyId ? null : (jobFamilyId ?? this.jobFamilyId),
      jobLevelId: clearJobLevelId ? null : (jobLevelId ?? this.jobLevelId),
      gradeId: clearGradeId ? null : (gradeId ?? this.gradeId),
      orgUnitId: clearOrgUnitId ? null : (orgUnitId ?? this.orgUnitId),
      levelCode: clearLevelCode ? null : (levelCode ?? this.levelCode),
    );
  }
}

class ManageEmployeesFiltersNotifier extends Notifier<ManageEmployeesFiltersState> {
  @override
  ManageEmployeesFiltersState build() => const ManageEmployeesFiltersState();

  void setPositionId(String? value) {
    state = state.copyWith(positionId: value, clearPositionId: value == null);
  }

  void setJobFamilyId(int? value) {
    state = state.copyWith(jobFamilyId: value, clearJobFamilyId: value == null);
  }

  void setJobLevelId(int? value) {
    state = state.copyWith(jobLevelId: value, clearJobLevelId: value == null);
  }

  void setGradeId(int? value) {
    state = state.copyWith(gradeId: value, clearGradeId: value == null);
  }

  void setOrgFilter(String? orgUnitId, String? levelCode) {
    state = state.copyWith(
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      clearOrgUnitId: orgUnitId == null,
      clearLevelCode: levelCode == null,
    );
  }

  void clearAll() {
    state = const ManageEmployeesFiltersState();
  }
}

final manageEmployeesFiltersProvider = NotifierProvider<ManageEmployeesFiltersNotifier, ManageEmployeesFiltersState>(
  ManageEmployeesFiltersNotifier.new,
);
