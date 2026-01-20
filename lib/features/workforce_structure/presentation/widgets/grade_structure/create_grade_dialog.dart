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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class GradeConfig {
  static List<String> get gradeNumbers => List.generate(12, (index) => (index + 1).toString());

  static Map<String, String> get gradeCategories => {
    'ENTRY_LEVEL': 'Entry Level',
    'PROFESSIONAL': 'Professional',
    'EXECUTIVE': 'Executive',
    'MANAGEMENT': 'Management',
  };
}

class CreateGradeDialog extends ConsumerStatefulWidget {
  const CreateGradeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, builder: (_) => const CreateGradeDialog());
  }

  @override
  ConsumerState<CreateGradeDialog> createState() => _CreateGradeDialogState();
}

class _CreateGradeDialogState extends ConsumerState<CreateGradeDialog> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final step1Controller = TextEditingController();
  final step2Controller = TextEditingController();
  final step3Controller = TextEditingController();
  final step4Controller = TextEditingController();
  final step5Controller = TextEditingController();

  String? selectedGradeNumber;
  String? selectedGradeCategory;

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
      final grade = Grade(
        id: 0, // Will be set by backend
        gradeNumber: selectedGradeNumber!,
        gradeCategory: selectedGradeCategory!,
        currencyCode: 'KWD',
        step1Salary: double.parse(step1Controller.text),
        step2Salary: double.parse(step2Controller.text),
        step3Salary: double.parse(step3Controller.text),
        step4Salary: double.parse(step4Controller.text),
        step5Salary: double.parse(step5Controller.text),
        description: descriptionController.text,
        status: 'ACTIVE',
        createdBy: 'ADMIN',
        createdDate: DateTime.now(),
        lastUpdatedBy: 'ADMIN',
        lastUpdatedDate: DateTime.now(),
        lastUpdateLogin: 'ADMIN',
      );

      await ref.read(gradeNotifierProvider.notifier).createGrade(grade);

      if (mounted) {
        ToastService.success(context, 'Grade created successfully');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Error creating grade');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isCreating = ref.watch(gradeCreatingProvider);

    return AppDialog(
      title: localizations.addGrade,
      width: 896.w,
      content: Form(
        key: _formKey,
        child: Column(
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
        Expanded(child: _buildGradeNumberDropdown(localizations)),
        Gap(12.w),
        Expanded(child: _buildGradeCategoryDropdown(localizations)),
      ],
    );
  }

  Widget _buildGradeNumberDropdown(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.gradeNumber, style: context.textTheme.titleSmall),
        Gap(4.h),
        FormField<String>(
          initialValue: selectedGradeNumber,
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
                  hint: localizations.selectGrade,
                  value: selectedGradeNumber,
                  items: GradeConfig.gradeNumbers,
                  itemLabelBuilder: (number) => 'Grade $number',
                  isRequired: true,
                  onChanged: (value) {
                    setState(() {
                      selectedGradeNumber = value;
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

  Widget _buildGradeCategoryDropdown(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.gradeCategory, style: context.textTheme.titleSmall),
        Gap(4.h),
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
        Text(localizations.stepSalaryStructureTitle, style: context.textTheme.titleSmall?.copyWith(fontSize: 16.0)),
        Gap(12.h),
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
