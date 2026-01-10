import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late final TextEditingController minGradeIdController;
  late final TextEditingController maxGradeIdController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final level = widget.jobLevel;
    nameController = TextEditingController(text: level?.nameEn ?? '');
    codeController = TextEditingController(text: level?.code ?? '');
    descriptionController = TextEditingController(text: level?.description ?? '');
    minGradeIdController = TextEditingController(text: level?.minGradeId.toString() ?? '');
    maxGradeIdController = TextEditingController(text: level?.maxGradeId.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    minGradeIdController.dispose();
    maxGradeIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final localizations = AppLocalizations.of(context)!;

    try {
      final jobLevel = JobLevel(
        id: widget.jobLevel?.id ?? 0,
        nameEn: nameController.text,
        code: codeController.text,
        description: descriptionController.text,
        minGradeId: int.parse(minGradeIdController.text),
        maxGradeId: int.parse(maxGradeIdController.text),
        status: 'ACTIVE',
      );

      if (widget.isEdit) {
        final updatedLevel = await ref.read(jobLevelNotifierProvider.notifier).updateJobLevel(ref, jobLevel);

        if (mounted) {
          ToastService.success(context, localizations.jobLevelUpdatedSuccessfully);
          widget.onSave?.call(updatedLevel);
          Navigator.of(context).pop();
        }
      } else {
        final createdLevel = await ref.read(jobLevelNotifierProvider.notifier).createJobLevel(ref, jobLevel);

        if (mounted) {
          ToastService.success(context, localizations.jobLevelCreatedSuccessfully);
          widget.onSave?.call(createdLevel);
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, localizations.errorCreatingJobLevel);
      }
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
      content: Form(
        key: _formKey,
        child: Column(
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
              validator: (value) => (value ?? '').isEmpty ? '' : null,
            ),
            Gap(12.h),
            DigifyTextField(
              labelText: localizations.jobLevelCode,
              hintText: localizations.jobLevelCodeHint,
              controller: codeController,
              readOnly: isEdit,
              isRequired: true,
              validator: (value) => (value ?? '').isEmpty ? '' : null,
            ),
            Gap(12.h),
            DigifyTextArea(
              labelText: localizations.description,
              hintText: localizations.jobLevelDescriptionHint,
              controller: descriptionController,
              maxLines: 3,
              isRequired: true,
              validator: (value) => (value ?? '').isEmpty ? '' : null,
            ),
            Gap(12.h),
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    labelText: localizations.minimumGrade,
                    hintText: localizations.gradeRangeHint,
                    controller: minGradeIdController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    validator: (value) => (value ?? '').isEmpty ? '' : null,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: DigifyTextField(
                    labelText: localizations.maximumGrade,
                    hintText: localizations.gradeRangeHint,
                    controller: maxGradeIdController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    validator: (value) => (value ?? '').isEmpty ? '' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        AppButton.outline(
          label: localizations.cancel,
          onPressed: isCreating ? null : () => Navigator.of(context).pop(),
        ),
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
