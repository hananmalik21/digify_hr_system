import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/position_form_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GradeSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const GradeSelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(positionFormNotifierProvider);
    final selectedJobLevel = formState.jobLevel;
    final selectedGrade = formState.grade;
    final gradesAsync = ref.watch(gradesInRangeForPositionFormProvider);
    final isEnabled = selectedJobLevel != null;

    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: gradesAsync.when(
        data: (grades) => PositionFormHelpers.buildDropdownField<Grade>(
          value: selectedGrade != null && grades.any((g) => g.id == selectedGrade.id) ? selectedGrade : null,
          items: grades,
          onChanged: isEnabled ? (v) => ref.read(positionFormNotifierProvider.notifier).setGrade(v) : null,
          itemLabelProvider: (g) => g.gradeLabel,
          hint: !isEnabled ? 'Select job level first' : (grades.isEmpty ? 'No grades in range' : 'Select grade'),
          readOnly: !isEnabled,
        ),
        loading: () => PositionFormHelpers.buildDropdownField<Grade>(
          value: null,
          items: const [],
          itemLabelProvider: (_) => '',
          hint: 'Loading grades...',
          readOnly: true,
        ),
        error: (_, __) => PositionFormHelpers.buildDropdownField<Grade>(
          value: null,
          items: const [],
          itemLabelProvider: (_) => '',
          hint: isEnabled ? 'Error loading grades' : 'Select job level first',
          readOnly: true,
        ),
      ),
    );
  }
}
