import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/create_grade_dialog.dart';
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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController descriptionController;
  late final TextEditingController step1Controller;
  late final TextEditingController step2Controller;
  late final TextEditingController step3Controller;
  late final TextEditingController step4Controller;
  late final TextEditingController step5Controller;

  String? selectedGradeCategory;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.grade.description);
    step1Controller = TextEditingController(text: widget.grade.step1Salary.toStringAsFixed(2));
    step2Controller = TextEditingController(text: widget.grade.step2Salary.toStringAsFixed(2));
    step3Controller = TextEditingController(text: widget.grade.step3Salary.toStringAsFixed(2));
    step4Controller = TextEditingController(text: widget.grade.step4Salary.toStringAsFixed(2));
    step5Controller = TextEditingController(text: widget.grade.step5Salary.toStringAsFixed(2));
    selectedGradeCategory = widget.grade.gradeCategory.toUpperCase();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    step1Controller.dispose();
    step2Controller.dispose();
    step3Controller.dispose();
    step4Controller.dispose();
    step5Controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final updatedGrade = widget.grade.copyWith(
        gradeCategory: selectedGradeCategory!,
        step1Salary: double.parse(step1Controller.text),
        step2Salary: double.parse(step2Controller.text),
        step3Salary: double.parse(step3Controller.text),
        step4Salary: double.parse(step4Controller.text),
        step5Salary: double.parse(step5Controller.text),
        description: descriptionController.text,
      );

      await ref.read(gradeNotifierProvider.notifier).updateGrade(widget.grade.id, updatedGrade);

      if (mounted) {
        ToastService.success(context, 'Grade updated successfully');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Error updating grade');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final updatingGradeId = ref.watch(gradeNotifierProvider).updatingGradeId;
    final isUpdating = updatingGradeId == widget.grade.id;

    return AppDialog(
      title: localizations.editGrade,
      width: 896.w,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradeInfo(localizations),
            SizedBox(height: 16.h),
            _buildGradeCategoryDropdown(localizations),
            SizedBox(height: 16.h),
            _buildStepSalaries(localizations),
            SizedBox(height: 18.h),
            _buildDescription(localizations),
          ],
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.gradeCategory, style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
        SizedBox(height: 4.h),
        FormField<String>(
          initialValue: selectedGradeCategory,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.fieldRequired;
            }
            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifySelectField<String>(
                  label: '',
                  hint: localizations.selectCategory,
                  value: selectedGradeCategory,
                  items: GradeConfig.gradeCategories.keys.toList(),
                  itemLabelBuilder: (key) => GradeConfig.gradeCategories[key]!,
                  isRequired: true,
                  onChanged: (value) {
                    setState(() {
                      selectedGradeCategory = value;
                    });
                    field.didChange(value);
                  },
                ),
                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.error),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepSalaries(AppLocalizations localizations) {
    final controllers = [step1Controller, step2Controller, step3Controller, step4Controller, step5Controller];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.stepSalaryStructureTitle, style: context.textTheme.titleMedium),
        SizedBox(height: 12.h),
        Row(
          children: controllers.asMap().entries.map((entry) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: entry.key == 0 ? 0 : 12.w),
                child: _buildStepInput(localizations, '${localizations.step} ${entry.key + 1}', entry.value),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepInput(AppLocalizations localizations, String label, TextEditingController controller) {
    return DigifyTextField(
      labelText: label,
      controller: controller,
      hintText: '0.00',
      isRequired: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [AppInputFormatters.decimalWithTwoPlaces()],
      suffixIcon: Center(
        widthFactor: 1.0,
        child: Text(
          localizations.kdSymbol,
          style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '';
        }
        final numberError = FormValidators.number(value);
        if (numberError != null) {
          return '';
        }
        final numValue = num.parse(value);
        if (numValue < 0) {
          return '';
        }
        return null;
      },
    );
  }

  Widget _buildDescription(AppLocalizations localizations) {
    return DigifyTextArea(
      labelText: localizations.descriptionOptional,
      controller: descriptionController,
      hintText: localizations.gradeDescriptionHint,
      maxLines: 3,
    );
  }
}
