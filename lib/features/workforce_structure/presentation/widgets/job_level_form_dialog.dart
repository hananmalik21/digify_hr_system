import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelFormDialog extends StatefulWidget {
  final JobLevel? jobLevel;
  final ValueChanged<JobLevel>? onSave;
  final bool isEdit;

  const JobLevelFormDialog({
    super.key,
    this.jobLevel,
    this.onSave,
    this.isEdit = false,
  });

  static Future<void> show(
    BuildContext context, {
    JobLevel? jobLevel,
    ValueChanged<JobLevel>? onSave,
    bool isEdit = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => JobLevelFormDialog(
        jobLevel: jobLevel,
        onSave: onSave,
        isEdit: isEdit,
      ),
    );
  }

  @override
  State<JobLevelFormDialog> createState() => _JobLevelFormDialogState();
}

class _JobLevelFormDialogState extends State<JobLevelFormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  late final TextEditingController descriptionController;
  late final TextEditingController minGradeController;
  late final TextEditingController maxGradeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final level = widget.jobLevel;
    nameController = TextEditingController(text: level?.nameEnglish ?? '');
    codeController = TextEditingController(text: level?.code ?? '');
    descriptionController = TextEditingController(text: level?.description ?? '');
    final gradeRange = level?.gradeRange.split('-').map((part) => part.trim()).toList() ??
        ['Grade 1', 'Grade 1'];
    minGradeController = TextEditingController(text: gradeRange.first);
    maxGradeController = TextEditingController(text: gradeRange.length > 1 ? gradeRange[1] : gradeRange.first);
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    minGradeController.dispose();
    maxGradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEdit = widget.isEdit;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 896.w,
          maxWidth: 896.w,
        ),
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
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tight(Size(32.w, 32.h)),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  localizations.basicInformation,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildField(
                label: localizations.levelName,
                hint: localizations.levelNameHint,
                controller: nameController,
              ),
              SizedBox(height: 12.h),
              _buildField(
                label: localizations.jobLevelCode,
                hint: localizations.jobLevelCodeHint,
                controller: codeController,
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
                      controller: minGradeController,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildField(
                      label: localizations.maximumGrade,
                      hint: localizations.gradeRangeHint,
                      controller: maxGradeController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        localizations.cancel,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final gradeText =
                              '${minGradeController.text} - ${maxGradeController.text}';
                          final updated = widget.jobLevel?.copyWith(
                                nameEnglish: nameController.text,
                                code: codeController.text,
                                description: descriptionController.text,
                                gradeRange: gradeText,
                                totalPositions: widget.jobLevel?.totalPositions ?? 0,
                                fillRate: widget.jobLevel?.fillRate ?? 0.0,
                                jobFamily: widget.jobLevel?.jobFamily ?? localizations.defaultJobFamily,
                              ) ??
                              JobLevel(
                                nameEnglish: nameController.text,
                                code: codeController.text,
                                description: descriptionController.text,
                                gradeRange: gradeText,
                                isActive: true,
                                jobFamily: localizations.defaultJobFamily,
                                filledPositions: 0,
                                fillRate: 0.0,
                                minSalary: localizations.notAvailable,
                                maxSalary: localizations.notAvailable,
                                medianSalary: localizations.notAvailable,
                                averageTenure: localizations.notAvailable,
                                talentStatus: localizations.notAvailable,
                                responsibilities: const [],
                                progressionLevels: const [],
                                totalPositions: 0
                              );
                          widget.onSave?.call(updated);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        isEdit ? localizations.saveChanges : localizations.createJobLevel,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
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
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
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
            fillColor: AppColors.inputBg,
            filled: true,
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

