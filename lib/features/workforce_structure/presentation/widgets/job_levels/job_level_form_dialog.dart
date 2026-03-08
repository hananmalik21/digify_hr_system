import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_form_state_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobLevelFormDialog extends ConsumerStatefulWidget {
  final JobLevel? jobLevel;
  final ValueChanged<JobLevel>? onSave;
  final bool isEdit;

  const JobLevelFormDialog({super.key, this.jobLevel, this.onSave, this.isEdit = false});

  static Future<void> show(
    BuildContext context, {
    JobLevel? jobLevel,
    ValueChanged<JobLevel>? onSave,
    bool isEdit = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => JobLevelFormDialog(jobLevel: jobLevel, onSave: onSave, isEdit: isEdit),
    );
  }

  @override
  ConsumerState<JobLevelFormDialog> createState() => _JobLevelFormDialogState();
}

class _JobLevelFormDialogState extends ConsumerState<JobLevelFormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final level = widget.jobLevel;
    nameController = TextEditingController(text: level?.nameEn ?? '');
    codeController = TextEditingController(text: level?.code ?? '');
    descriptionController = TextEditingController(text: level?.description ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final result = await ref
        .read(jobLevelFormStateProvider(widget.jobLevel).notifier)
        .submitJobLevel(
          context,
          ref,
          nameEn: nameController.text,
          code: codeController.text,
          description: descriptionController.text,
          isEdit: widget.isEdit,
          existingJobLevel: widget.jobLevel,
        );
    if (!mounted) return;
    switch (result) {
      case JobLevelSubmitSuccess(:final level, :final successMessage):
        ToastService.success(context, successMessage);
        widget.onSave?.call(level);
        context.pop();
      case JobLevelSubmitApiError(:final errorMessage):
        ToastService.error(context, errorMessage);
      case JobLevelSubmitValidationFailure():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEdit = widget.isEdit;
    final isCreating = ref.watch(jobLevelCreatingProvider);

    return AppDialog(
      title: isEdit ? localizations.editJobLevel : localizations.addNewJobLevel,
      width: 896.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.basicInformation,
            style: context.textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary),
          ),
          Gap(20.h),
          DigifyTextField(
            labelText: localizations.levelName,
            hintText: localizations.levelNameHint,
            controller: nameController,
            readOnly: isEdit,
            isRequired: true,
          ),
          Gap(12.h),
          DigifyTextField(
            labelText: localizations.jobLevelCode,
            hintText: localizations.jobLevelCodeHint,
            controller: codeController,
            readOnly: isEdit,
            isRequired: true,
          ),
          Gap(12.h),
          DigifyTextArea(
            labelText: localizations.description,
            hintText: localizations.jobLevelDescriptionHint,
            controller: descriptionController,
            maxLines: 3,
            isRequired: true,
          ),
          Gap(12.h),
          Builder(
            builder: (context) {
              final gradesAsync = ref.watch(gradesForJobLevelFormProvider);
              final grades = gradesAsync.valueOrNull ?? [];
              final gradesLoading = gradesAsync.isLoading;
              final formState = ref.watch(jobLevelFormStateProvider(widget.jobLevel));
              final formNotifier = ref.read(jobLevelFormStateProvider(widget.jobLevel).notifier);

              return Row(
                children: [
                  Expanded(
                    child: DigifySelectFieldWithLabel<Grade>(
                      label: localizations.minimumGrade,
                      hint: gradesLoading ? localizations.pleaseWait : localizations.selectGrade,
                      items: grades,
                      itemLabelBuilder: (g) => g.gradeLabel,
                      value: formState.selectedMinGrade,
                      onChanged: gradesLoading ? null : (v) => formNotifier.setMinGrade(v),
                      isRequired: true,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: DigifySelectFieldWithLabel<Grade>(
                      label: localizations.maximumGrade,
                      hint: gradesLoading ? localizations.pleaseWait : localizations.selectGrade,
                      items: grades,
                      itemLabelBuilder: (g) => g.gradeLabel,
                      value: formState.selectedMaxGrade,
                      onChanged: gradesLoading ? null : (v) => formNotifier.setMaxGrade(v),
                      isRequired: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: isEdit ? localizations.saveChanges : localizations.createJobLevel,
          onPressed: isCreating ? null : _handleSave,
          isLoading: isCreating,
        ),
      ],
    );
  }
}
