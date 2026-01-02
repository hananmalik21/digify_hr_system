import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

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

  // Grade categories
  final Map<String, String> gradeCategories = {
    'ENTRY_LEVEL': 'Entry Level',
    'PROFESSIONAL': 'Professional',
    'EXECUTIVE': 'Executive',
    'MANAGEMENT': 'Management',
  };

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.grade.description);
    step1Controller = TextEditingController(text: widget.grade.step1Salary.toString());
    step2Controller = TextEditingController(text: widget.grade.step2Salary.toString());
    step3Controller = TextEditingController(text: widget.grade.step3Salary.toString());
    step4Controller = TextEditingController(text: widget.grade.step4Salary.toString());
    step5Controller = TextEditingController(text: widget.grade.step5Salary.toString());
    // Normalize grade category to match dropdown keys (handle case variations from API)
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
        Navigator.of(context).pop();
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(localizations),
                    SizedBox(height: 16.h),
                    _buildGradeInfo(localizations),
                    SizedBox(height: 16.h),
                    _buildGradeCategoryDropdown(localizations),
                    SizedBox(height: 16.h),
                    _buildStepSalaries(localizations),
                    SizedBox(height: 18.h),
                    _buildDescription(localizations),
                    SizedBox(height: 24.h),
                    _buildActions(localizations, isUpdating),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: Text(
            localizations.editGrade,
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
    );
  }

  Widget _buildGradeInfo(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20.sp, color: AppColors.textSecondary),
          SizedBox(width: 8.w),
          Text(
            '${localizations.gradeNumber}: ${widget.grade.gradeLabel}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          SizedBox(width: 8.w),
          Text(
            '(Cannot be changed)',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeCategoryDropdown(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.gradeCategory,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
        SizedBox(height: 4.h),
        DropdownButtonFormField<String>(
          initialValue: selectedGradeCategory,
          decoration: InputDecoration(
            hintText: localizations.selectCategory,
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
          items: gradeCategories.entries.map((entry) {
            return DropdownMenuItem(value: entry.key, child: Text(entry.value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGradeCategory = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.fieldRequired;
            }
            return null;
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
        Text(
          localizations.stepSalaryStructureTitle,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            suffixText: localizations.kdSymbol,
            suffixStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            fillColor: AppColors.inputBg,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
            if (value == null || value.isEmpty) {
              return '';
            }
            final number = double.tryParse(value);
            if (number == null || number < 0) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescription(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.descriptionOptional,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: localizations.gradeDescriptionHint,
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
        ),
      ],
    );
  }

  Widget _buildActions(AppLocalizations localizations, bool isUpdating) {
    return Row(
      children: [
        Expanded(
          child: AppButton.outline(
            label: localizations.cancel,
            onPressed: isUpdating ? null : () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppButton.primary(label: 'Update Grade', onPressed: _handleSave, isLoading: isUpdating),
        ),
      ],
    );
  }
}
