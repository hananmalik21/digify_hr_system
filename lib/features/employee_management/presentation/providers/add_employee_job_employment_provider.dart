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
  final DateTime? enterpriseHireDate;
  final int? probationDays;
  final String? contractTypeCode;
  final String? employmentStatusCode;

  const AddEmployeeJobEmploymentState({
    this.selectedPosition,
    this.selectedJobFamily,
    this.selectedJobLevel,
    this.selectedGrade,
    this.enterpriseHireDate,
    this.probationDays,
    this.contractTypeCode,
    this.employmentStatusCode,
  });

  AddEmployeeJobEmploymentState copyWith({
    Position? selectedPosition,
    JobFamily? selectedJobFamily,
    JobLevel? selectedJobLevel,
    Grade? selectedGrade,
    DateTime? enterpriseHireDate,
    int? probationDays,
    String? contractTypeCode,
    String? employmentStatusCode,
    bool clearPosition = false,
    bool clearJobFamily = false,
    bool clearJobLevel = false,
    bool clearGrade = false,
    bool clearEnterpriseHireDate = false,
    bool clearProbationDays = false,
    bool clearContractTypeCode = false,
    bool clearEmploymentStatusCode = false,
  }) {
    return AddEmployeeJobEmploymentState(
      selectedPosition: clearPosition ? null : (selectedPosition ?? this.selectedPosition),
      selectedJobFamily: clearJobFamily ? null : (selectedJobFamily ?? this.selectedJobFamily),
      selectedJobLevel: clearJobLevel ? null : (selectedJobLevel ?? this.selectedJobLevel),
      selectedGrade: clearGrade ? null : (selectedGrade ?? this.selectedGrade),
      enterpriseHireDate: clearEnterpriseHireDate ? null : (enterpriseHireDate ?? this.enterpriseHireDate),
      probationDays: clearProbationDays ? null : (probationDays ?? this.probationDays),
      contractTypeCode: clearContractTypeCode ? null : (contractTypeCode ?? this.contractTypeCode),
      employmentStatusCode: clearEmploymentStatusCode ? null : (employmentStatusCode ?? this.employmentStatusCode),
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

  void setEnterpriseHireDate(DateTime? value) {
    state = state.copyWith(enterpriseHireDate: value, clearEnterpriseHireDate: value == null);
  }

  void setProbationDays(int? value) {
    state = state.copyWith(probationDays: value, clearProbationDays: value == null);
  }

  void setContractTypeCode(String? value) {
    state = state.copyWith(contractTypeCode: value, clearContractTypeCode: value == null || value.isEmpty);
  }

  void setEmploymentStatusCode(String? value) {
    state = state.copyWith(employmentStatusCode: value, clearEmploymentStatusCode: value == null || value.isEmpty);
  }

  void reset() {
    state = const AddEmployeeJobEmploymentState();
  }
}

final addEmployeeJobEmploymentProvider =
    StateNotifierProvider<AddEmployeeJobEmploymentNotifier, AddEmployeeJobEmploymentState>((ref) {
      return AddEmployeeJobEmploymentNotifier();
    });
