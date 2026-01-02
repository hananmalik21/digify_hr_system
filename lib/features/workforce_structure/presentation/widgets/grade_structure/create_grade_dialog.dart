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

  // Grade numbers from 1 to 12
  final List<String> gradeNumbers = List.generate(12, (index) => (index + 1).toString());

  // Grade categories
  final Map<String, String> gradeCategories = {
    'ENTRY_LEVEL': 'Entry Level',
    'PROFESSIONAL': 'Professional',
    'EXECUTIVE': 'Executive',
    'MANAGEMENT': 'Management',
  };

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
                    _buildGradeFields(localizations),
                    SizedBox(height: 16.h),
                    _buildStepSalaries(localizations),
                    SizedBox(height: 18.h),
                    _buildDescription(localizations),
                    SizedBox(height: 24.h),
                    _buildActions(localizations),
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
            localizations.addGrade,
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

  Widget _buildGradeFields(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(child: _buildGradeNumberDropdown(localizations)),
        SizedBox(width: 12.w),
        Expanded(child: _buildGradeCategoryDropdown(localizations)),
      ],
    );
  }

  Widget _buildGradeNumberDropdown(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.gradeNumber,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
        SizedBox(height: 4.h),
        DropdownButtonFormField<String>(
          initialValue: selectedGradeNumber,
          decoration: InputDecoration(
            hintText: localizations.selectGrade,
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
          items: gradeNumbers.map((number) {
            return DropdownMenuItem(value: number, child: Text('Grade $number'));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGradeNumber = value;
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

  Widget _buildActions(AppLocalizations localizations) {
    final isCreating = ref.watch(gradeCreatingProvider);

    return Row(
      children: [
        Expanded(
          child: AppButton.outline(
            label: localizations.cancel,
            onPressed: isCreating ? null : () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppButton.primary(label: localizations.createGrade, onPressed: _handleSave, isLoading: isCreating),
        ),
      ],
    );
  }
}
