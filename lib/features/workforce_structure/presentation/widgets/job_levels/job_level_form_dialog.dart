import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

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

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 896.w, maxWidth: 896.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 26.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEdit ? localizations.editJobLevel : localizations.addNewJobLevel,
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints.tight(Size(32.w, 32.h)),
                        icon: Icon(Icons.close_rounded, size: 20.sp, color: AppColors.textSecondary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      localizations.basicInformation,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildField(
                    label: localizations.levelName,
                    hint: localizations.levelNameHint,
                    controller: nameController,
                    readOnly: isEdit,
                  ),
                  SizedBox(height: 12.h),
                  _buildField(
                    label: localizations.jobLevelCode,
                    hint: localizations.jobLevelCodeHint,
                    controller: codeController,
                    readOnly: isEdit,
                  ),
                  SizedBox(height: 12.h),
                  _buildField(
                    label: localizations.description,
                    hint: localizations.jobLevelDescriptionHint,
                    controller: descriptionController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: localizations.minimumGrade,
                          hint: localizations.gradeRangeHint,
                          controller: minGradeIdController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildField(
                          label: localizations.maximumGrade,
                          hint: localizations.gradeRangeHint,
                          controller: maxGradeIdController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          label: localizations.cancel,
                          onPressed: isCreating ? null : () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton.primary(
                          label: isEdit ? localizations.saveChanges : localizations.createJobLevel,
                          onPressed: isCreating ? null : _handleSave,
                          isLoading: isCreating,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRtl = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            fillColor: readOnly ? AppColors.inputBg : AppColors.inputBg,
            filled: true,
            enabled: !readOnly,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
          ),
          validator: (value) {
            if ((value ?? '').isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }
}
