import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class JobFamilyFormDialog extends ConsumerStatefulWidget {
  final JobFamily? jobFamily;
  final ValueChanged<JobFamily>? onSave;
  final bool isEdit;

  const JobFamilyFormDialog({
    super.key,
    this.jobFamily,
    this.onSave,
    this.isEdit = false,
  });

  static Future<void> show(
    BuildContext context, {
    JobFamily? jobFamily,
    ValueChanged<JobFamily>? onSave,
    bool isEdit = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => JobFamilyFormDialog(
        jobFamily: jobFamily,
        onSave: onSave,
        isEdit: isEdit,
      ),
    );
  }

  @override
  ConsumerState<JobFamilyFormDialog> createState() =>
      _JobFamilyFormDialogState();
}

class _JobFamilyFormDialogState extends ConsumerState<JobFamilyFormDialog> {
  late final TextEditingController codeController;
  late final TextEditingController englishController;
  late final TextEditingController arabicController;
  late final TextEditingController descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final jobFamily = widget.jobFamily;
    codeController = TextEditingController(text: jobFamily?.code ?? '');
    englishController = TextEditingController(
      text: jobFamily?.nameEnglish ?? '',
    );
    arabicController = TextEditingController(text: jobFamily?.nameArabic ?? '');
    descriptionController = TextEditingController(
      text: jobFamily?.description ?? '',
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    englishController.dispose();
    arabicController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      await ref.createJobFamily(
        code: codeController.text.trim(),
        nameEnglish: englishController.text.trim(),
        nameArabic: arabicController.text.trim(),
        description: descriptionController.text.trim(),
      );
      context.pop();
      ToastService.success(
        context,
        'Job family created successfully',
        title: 'Success',
      );
    } catch (e) {
      if (mounted) {
        ToastService.error(context, e.toString(), title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEdit = widget.isEdit;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: 540.w,
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
                      isEdit
                          ? localizations.editJobFamily
                          : localizations.addNewJobFamily,
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
                    onPressed: () => context.pop(),
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
              SizedBox(height: 22.h),
              _buildField(
                label: localizations.jobFamilyCode,
                hint: localizations.jobFamilyCodeHint,
                controller: codeController,
              ),
              SizedBox(height: 12.h),
              _buildField(
                label: localizations.jobFamilyNameEnglish,
                hint: localizations.jobFamilyNameEnglishHint,
                controller: englishController,
              ),
              SizedBox(height: 12.h),
              _buildField(
                label: localizations.jobFamilyNameArabic,
                hint: localizations.jobFamilyNameArabicHint,
                controller: arabicController,
                isRtl: true,
              ),
              SizedBox(height: 12.h),
              _buildField(
                label: localizations.description,
                hint: localizations.positionFamilyDescription,
                controller: descriptionController,
                maxLines: 3,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
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
                    child: AppButton.primary(
                      label: isEdit
                          ? localizations.saveChanges
                          : localizations.createJobFamily,
                      onPressed: _handleSubmit,
                      isLoading: ref.watch(jobFamilyCreatingProvider),
                    ),
                  ),
                ],
              ),
            ],
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
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
            fillColor: AppColors.inputBg,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
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
