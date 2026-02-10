import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
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

  void initialize({
    String? employmentType,
    bool? isActive,
    String? step,
    JobFamily? jobFamily,
    JobLevel? jobLevel,
    Grade? grade,
  }) {
    state = state.copyWith(
      employmentType: employmentType ?? state.employmentType,
      isActive: isActive ?? state.isActive,
      step: step ?? state.step,
      jobFamily: jobFamily ?? state.jobFamily,
      jobLevel: jobLevel ?? state.jobLevel,
      grade: grade ?? state.grade,
    );
  }

  /// Validates form data and returns the first error message, or null if valid.
  String? validateForm({
    required String positionCode,
    required String titleEnglish,
    required String titleArabic,
    required String costCenter,
    required String location,
    required String numberOfPositionsStr,
    required String filledPositionsStr,
    required String budgetedMinStr,
    required String budgetedMaxStr,
    required String actualAverageStr,
    required bool hasOrgUnitSelected,
    required bool hasReportsToEmployeeSelected,
    required bool isEdit,
    required AppLocalizations l,
  }) {
    if (!isEdit && positionCode.trim().isEmpty) {
      return '${l.positionCode} ${l.fieldRequired}';
    }
    if (titleEnglish.trim().isEmpty) {
      return '${l.positionTitle} (English) ${l.fieldRequired}';
    }
    if (titleArabic.trim().isEmpty) {
      return '${l.positionTitle} (Arabic) ${l.fieldRequired}';
    }
    if (costCenter.trim().isEmpty) {
      return '${l.costCenter} ${l.fieldRequired}';
    }
    if (location.trim().isEmpty) {
      return '${l.location} ${l.fieldRequired}';
    }
    final positionsStr = numberOfPositionsStr.trim();
    if (positionsStr.isEmpty) {
      return 'Number of positions ${l.fieldRequired}';
    }
    final positions = int.tryParse(positionsStr);
    if (positions == null || positions < 0) {
      return 'Number of positions must be a valid number (0 or more)';
    }
    final filledStr = filledPositionsStr.trim();
    if (filledStr.isEmpty) {
      return 'Filled positions ${l.fieldRequired}';
    }
    final filled = int.tryParse(filledStr);
    if (filled == null || filled < 0) {
      return 'Filled positions must be a valid number (0 or more)';
    }
    if (filled > positions) {
      return 'Filled positions cannot exceed number of positions';
    }
    if (state.employmentType == null || state.employmentType!.isEmpty) {
      return 'Employment type ${l.fieldRequired}';
    }
    if (state.jobFamily == null || state.jobLevel == null || state.grade == null) {
      return 'Please select Job Family, Level and Grade';
    }
    if (!hasOrgUnitSelected) {
      return 'Please select at least one organizational unit';
    }
    if (!hasReportsToEmployeeSelected) {
      return 'Please select a reporting manager';
    }
    final budgetedMin = budgetedMinStr.trim();
    if (budgetedMin.isEmpty) {
      return '${l.budgetedMin} ${l.fieldRequired}';
    }
    if (double.tryParse(budgetedMin) == null || double.tryParse(budgetedMin)! < 0) {
      return '${l.budgetedMin} must be a valid number (0 or more)';
    }
    final budgetedMax = budgetedMaxStr.trim();
    if (budgetedMax.isEmpty) {
      return '${l.budgetedMax} ${l.fieldRequired}';
    }
    if (double.tryParse(budgetedMax) == null || double.tryParse(budgetedMax)! < 0) {
      return '${l.budgetedMax} must be a valid number (0 or more)';
    }
    final actualAvg = actualAverageStr.trim();
    if (actualAvg.isEmpty) {
      return '${l.actualAverage} ${l.fieldRequired}';
    }
    if (double.tryParse(actualAvg) == null || double.tryParse(actualAvg)! < 0) {
      return '${l.actualAverage} must be a valid number (0 or more)';
    }
    return null;
  }
}

final positionFormNotifierProvider = StateNotifierProvider.autoDispose<PositionFormNotifier, PositionFormState>((ref) {
  return PositionFormNotifier();
});
