import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/position_form_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _formatStepLabel(GradeStep step, String currencyCode) {
  final salaryStr = step.salary.toStringAsFixed(0);
  return 'Step ${step.step} - $salaryStr $currencyCode';
}

class StepSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const StepSelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(allGradesForPositionFormProvider);
    final formState = ref.watch(positionFormNotifierProvider);
    final grade = formState.grade;
    final gradesInRangeAsync = ref.watch(gradesInRangeForPositionFormProvider);

    if (grade == null) {
      return PositionLabeledField(
        label: label,
        isRequired: isRequired,
        child: PositionFormHelpers.buildDropdownField<GradeStep>(
          value: null,
          items: const [],
          onChanged: null,
          itemLabelProvider: (s) => '',
          hint: 'Select grade first',
          readOnly: true,
        ),
      );
    }

    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: gradesInRangeAsync.when(
        data: (grades) {
          final resolvedGrade = grades.where((g) => g.id == grade.id).firstOrNull;
          final gradeHasSteps = resolvedGrade != null && resolvedGrade.minSalary > 0;
          final steps = gradeHasSteps ? resolvedGrade.steps : <GradeStep>[];
          final selectedStep = ref.watch(selectedStepForPositionFormProvider);
          final selectedStepObj = selectedStep != null
              ? steps.where((s) => s.step == selectedStep.step).firstOrNull
              : null;
          final currencyCode = (resolvedGrade ?? grade).currencyCode;

          return PositionFormHelpers.buildDropdownField<GradeStep>(
            value: selectedStepObj,
            items: steps,
            onChanged: (v) => ref.read(positionFormNotifierProvider.notifier).setStep(v?.step.toString()),
            itemLabelProvider: (s) => _formatStepLabel(s, currencyCode),
            hint: 'Select step',
          );
        },
        loading: () => PositionFormHelpers.buildDropdownField<GradeStep>(
          value: null,
          items: const [],
          onChanged: null,
          itemLabelProvider: (s) => '',
          hint: 'Loading...',
          readOnly: true,
        ),
        error: (_, __) => PositionFormHelpers.buildDropdownField<GradeStep>(
          value: null,
          items: const [],
          onChanged: null,
          itemLabelProvider: (s) => '',
          hint: 'Error loading steps',
          readOnly: true,
        ),
      ),
    );
  }
}
