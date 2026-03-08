import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_update_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class JobFamilyFormDialog extends ConsumerStatefulWidget {
  final JobFamily? jobFamily;
  final ValueChanged<JobFamily>? onSave;
  final bool isEdit;

  const JobFamilyFormDialog({super.key, this.jobFamily, this.onSave, this.isEdit = false});

  static Future<void> show(
    BuildContext context, {
    JobFamily? jobFamily,
    ValueChanged<JobFamily>? onSave,
    bool isEdit = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => JobFamilyFormDialog(jobFamily: jobFamily, onSave: onSave, isEdit: isEdit),
    );
  }

  @override
  ConsumerState<JobFamilyFormDialog> createState() => _JobFamilyFormDialogState();
}

class _JobFamilyFormDialogState extends ConsumerState<JobFamilyFormDialog> {
  late final TextEditingController codeController;
  late final TextEditingController englishController;
  late final TextEditingController arabicController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final jobFamily = widget.jobFamily;
    codeController = TextEditingController(text: jobFamily?.code ?? '');
    englishController = TextEditingController(text: jobFamily?.nameEnglish ?? '');
    arabicController = TextEditingController(text: jobFamily?.nameArabic ?? '');
    descriptionController = TextEditingController(text: jobFamily?.description ?? '');
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
    final l10n = AppLocalizations.of(context)!;
    final code = codeController.text.trim();
    final nameEnglish = englishController.text.trim();
    final description = descriptionController.text.trim();

    if (code.isEmpty) {
      ToastService.error(context, l10n.jobFamilyCodeRequired);
      return;
    }
    if (nameEnglish.isEmpty) {
      ToastService.error(context, l10n.jobFamilyNameEnglishRequired);
      return;
    }
    if (description.isEmpty) {
      ToastService.error(context, l10n.jobFamilyDescriptionRequired);
      return;
    }

    try {
      if (widget.isEdit && widget.jobFamily != null) {
        await ref.updateJobFamily(
          id: widget.jobFamily!.id,
          code: code,
          nameEnglish: nameEnglish,
          nameArabic: arabicController.text.trim(),
          description: description,
        );
        if (mounted) {
          context.pop();
          ToastService.success(context, l10n.jobFamilyUpdatedSuccessfully);
        }
      } else {
        await ref.createJobFamily(
          code: code,
          nameEnglish: nameEnglish,
          nameArabic: arabicController.text.trim(),
          description: description,
        );
        if (mounted) {
          context.pop();
          ToastService.success(context, l10n.jobFamilyCreatedSuccessfully);
        }
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEdit = widget.isEdit;

    return AppDialog(
      title: isEdit ? localizations.editJobFamily : localizations.addNewJobFamily,
      width: 540.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.basicInformation,
            style: context.textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary),
          ),
          Gap(22.h),
          _buildField(
            label: localizations.jobFamilyCode,
            hint: localizations.jobFamilyCodeHint,
            controller: codeController,
            readOnly: isEdit,
          ),
          Gap(12.h),
          _buildField(
            label: localizations.jobFamilyNameEnglish,
            hint: localizations.jobFamilyNameEnglishHint,
            controller: englishController,
          ),
          Gap(12.h),
          _buildField(
            label: localizations.jobFamilyNameArabic,
            hint: 'e.g. Finance Manager (Optional)',
            controller: arabicController,
            isRequired: false,
            inputFormatters: [AppInputFormatters.nameAny],
            validator: (_) => null,
          ),
          Gap(12.h),
          DigifyTextArea(
            labelText: localizations.description,
            hintText: localizations.positionFamilyDescription,
            controller: descriptionController,
            maxLines: 3,
            isRequired: true,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: isEdit ? localizations.saveChanges : localizations.createJobFamily,
          onPressed: _handleSubmit,
          isLoading: isEdit ? ref.watch(jobFamilyUpdateStateProvider).isUpdating : ref.watch(jobFamilyCreatingProvider),
        ),
      ],
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
    bool isRequired = true,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return DigifyTextField(
      labelText: label,
      hintText: hint,
      controller: controller,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: isRtl ? TextAlign.right : TextAlign.start,
      maxLines: maxLines,
      isRequired: isRequired,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator:
          validator ??
          (value) {
            if ((value ?? '').isEmpty) {
              return '';
            }
            return null;
          },
    );
  }
}
