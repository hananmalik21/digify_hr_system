import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/update_grade_form_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class UpdateGradeDialog extends ConsumerStatefulWidget {
  final Grade grade;

  const UpdateGradeDialog({super.key, required this.grade});

  static Future<void> show(BuildContext context, {required Grade grade}) {
    return showDialog<void>(
      context: context,
      builder: (_) => UpdateGradeDialog(grade: grade),
    );
  }

  @override
  ConsumerState<UpdateGradeDialog> createState() => _UpdateGradeDialogState();
}

class _UpdateGradeDialogState extends ConsumerState<UpdateGradeDialog> {
  late final TextEditingController step1Controller;
  late final TextEditingController step2Controller;
  late final TextEditingController step3Controller;
  late final TextEditingController step4Controller;
  late final TextEditingController step5Controller;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(updateGradeFormStateProvider(widget.grade));
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
    final success = await ref
        .read(updateGradeFormStateProvider(widget.grade).notifier)
        .submit(context, ref, widget.grade);
    if (mounted && success) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final updatingGradeId = ref.watch(gradeNotifierProvider).updatingGradeId;
    final isUpdating = updatingGradeId == widget.grade.id;

    return AppDialog(
      title: localizations.editGrade,
      width: 896.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGradeInfo(localizations),
          Gap(16.h),
          _buildGradeCategoryDropdown(localizations),
          Gap(16.h),
          _buildStepSalaries(localizations),
          Gap(18.h),
          _buildDescription(localizations),
        ],
      ),
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: isUpdating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: localizations.saveChanges,
          svgPath: Assets.icons.saveIcon.path,
          onPressed: _handleSave,
          isLoading: isUpdating,
        ),
      ],
    );
  }

  Widget _buildGradeInfo(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20.sp, color: AppColors.textSecondary),
          Gap(8.w),
          Text('${localizations.gradeNumber}: ${widget.grade.gradeLabel}', style: context.textTheme.titleSmall),
          Gap(8.w),
          Text('(Cannot be changed)', style: context.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildGradeCategoryDropdown(AppLocalizations localizations) {
    final gradeCategoriesAsync = ref.watch(gradeCategoryLookupValuesProvider);
    final items = gradeCategoriesAsync.valueOrNull ?? [];
    final isLoading = gradeCategoriesAsync.isLoading;
    final formState = ref.watch(updateGradeFormStateProvider(widget.grade));
    final formNotifier = ref.read(updateGradeFormStateProvider(widget.grade).notifier);

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
    final formNotifier = ref.read(updateGradeFormStateProvider(widget.grade).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.stepSalaryStructureTitle, style: context.textTheme.titleMedium),
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
    final formNotifier = ref.read(updateGradeFormStateProvider(widget.grade).notifier);

    return DigifyTextArea(
      labelText: localizations.descriptionOptional,
      controller: descriptionController,
      hintText: localizations.gradeDescriptionHint,
      maxLines: 3,
      onChanged: formNotifier.setDescription,
    );
  }
}
