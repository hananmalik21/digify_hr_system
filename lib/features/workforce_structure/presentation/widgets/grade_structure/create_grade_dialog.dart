import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/create_grade_form_state_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class CreateGradeDialog extends ConsumerStatefulWidget {
  const CreateGradeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, builder: (_) => const CreateGradeDialog());
  }

  @override
  ConsumerState<CreateGradeDialog> createState() => _CreateGradeDialogState();
}

class _CreateGradeDialogState extends ConsumerState<CreateGradeDialog> {
  late final TextEditingController step1Controller;
  late final TextEditingController step2Controller;
  late final TextEditingController step3Controller;
  late final TextEditingController step4Controller;
  late final TextEditingController step5Controller;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createGradeFormStateProvider);
    step1Controller = TextEditingController(text: state.step1Salary);
    step2Controller = TextEditingController(text: state.step2Salary);
    step3Controller = TextEditingController(text: state.step3Salary);
    step4Controller = TextEditingController(text: state.step4Salary);
    step5Controller = TextEditingController(text: state.step5Salary);
    descriptionController = TextEditingController(text: state.description);
  }

  @override
  void dispose() {
    step1Controller.dispose();
    step2Controller.dispose();
    step3Controller.dispose();
    step4Controller.dispose();
    step5Controller.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await ref.read(createGradeFormStateProvider.notifier).submit(context, ref);
    if (mounted && success) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isCreating = ref.watch(gradeCreatingProvider);

    return AppDialog(
      title: localizations.addGrade,
      width: 896.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGradeFields(localizations),
          Gap(24.h),
          _buildStepSalaries(localizations),
          Gap(24.h),
          _buildDescription(localizations),
        ],
      ),
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: localizations.createGrade,
          svgPath: Assets.icons.saveIcon.path,
          onPressed: _handleSave,
          isLoading: isCreating,
        ),
      ],
    );
  }

  Widget _buildGradeFields(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(child: _buildGradeCategoryDropdown(localizations)),
        Gap(12.w),
        Expanded(child: _buildGradeNumberDropdown(localizations)),
      ],
    );
  }

  Widget _buildGradeNumberDropdown(AppLocalizations localizations) {
    final gradeNumbersAsync = ref.watch(gradeNumberLookupValuesProvider);
    final isLoading = gradeNumbersAsync.isLoading;
    final items = ref.watch(gradeNumbersForCreateGradeFormProvider);
    final formState = ref.watch(createGradeFormStateProvider);
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);
    final categorySelected = formState.selectedGradeCategory != null;

    String hint;
    if (isLoading) {
      hint = localizations.pleaseWait;
    } else if (!categorySelected) {
      hint = localizations.selectGradeCategoryFirst;
    } else if (items.isEmpty) {
      hint = localizations.noGradeNumbersForCategory;
    } else {
      hint = localizations.selectGrade;
    }

    return DigifySelectFieldWithLabel<EmplLookupValue>(
      label: localizations.gradeNumber,
      hint: hint,
      value: formState.selectedGradeNumber,
      items: items,
      itemLabelBuilder: (v) => v.meaningEn,
      isRequired: true,
      onChanged: (isLoading || !categorySelected || items.isEmpty)
          ? null
          : (v) => formNotifier.setSelectedGradeNumber(v),
    );
  }

  Widget _buildGradeCategoryDropdown(AppLocalizations localizations) {
    final gradeCategoriesAsync = ref.watch(gradeCategoryLookupValuesProvider);
    final items = gradeCategoriesAsync.valueOrNull ?? [];
    final isLoading = gradeCategoriesAsync.isLoading;
    final formState = ref.watch(createGradeFormStateProvider);
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);

    return DigifySelectFieldWithLabel<EmplLookupValue>(
      label: localizations.gradeCategory,
      hint: isLoading ? localizations.pleaseWait : localizations.selectCategory,
      value: formState.selectedGradeCategory,
      items: items,
      itemLabelBuilder: (v) => v.meaningEn,
      isRequired: true,
      onChanged: isLoading ? null : (v) => formNotifier.setSelectedGradeCategory(v),
    );
  }

  Widget _buildStepSalaries(AppLocalizations localizations) {
    final controllers = [step1Controller, step2Controller, step3Controller, step4Controller, step5Controller];
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.stepSalaryStructureTitle, style: context.textTheme.titleSmall?.copyWith(fontSize: 16.0)),
        Gap(12.h),
        Row(
          children: controllers.asMap().entries.map((entry) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: entry.key == 0 ? 0 : 12.w),
                child: _buildStepInput(
                  localizations,
                  '${localizations.step} ${entry.key + 1}',
                  entry.value,
                  (v) => formNotifier.setStepSalary(entry.key, v),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepInput(
    AppLocalizations localizations,
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return DigifyTextField(
      labelText: label,
      controller: controller,
      hintText: '0.00',
      isRequired: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [AppInputFormatters.decimalWithTwoPlaces()],
      onChanged: onChanged,
      suffixIcon: Center(
        widthFactor: 1.0,
        child: Text(
          localizations.kdSymbol,
          style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildDescription(AppLocalizations localizations) {
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);

    return DigifyTextArea(
      labelText: localizations.descriptionOptional,
      controller: descriptionController,
      hintText: localizations.gradeDescriptionHint,
      maxLines: 3,
      onChanged: formNotifier.setDescription,
    );
  }
}
