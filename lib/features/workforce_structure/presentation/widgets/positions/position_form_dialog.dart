import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionFormDialog extends StatefulWidget {
  final Position initialPosition;
  final bool isEdit;

  const PositionFormDialog({
    super.key,
    required this.initialPosition,
    required this.isEdit,
  });

  static void show(
    BuildContext context, {
    required Position position,
    required bool isEdit,
  }) {
    showDialog(
      context: context,
      builder: (context) =>
          PositionFormDialog(initialPosition: position, isEdit: isEdit),
    );
  }

  @override
  State<PositionFormDialog> createState() => _PositionFormDialogState();
}

class _PositionFormDialogState extends State<PositionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _statusController;
  late final TextEditingController _titleEnglishController;
  late final TextEditingController _titleArabicController;
  late final TextEditingController _divisionController;
  late final TextEditingController _departmentController;
  late final TextEditingController _costCenterController;
  late final TextEditingController _locationController;
  late final TextEditingController _jobFamilyController;
  late final TextEditingController _jobLevelController;
  late final TextEditingController _gradeController;
  late final TextEditingController _stepController;
  late final TextEditingController _positionsController;
  late final TextEditingController _filledController;
  late final TextEditingController _employmentController;
  late final TextEditingController _budgetedMinController;
  late final TextEditingController _budgetedMaxController;
  late final TextEditingController _actualAverageController;
  late final TextEditingController _reportsTitleController;
  late final TextEditingController _reportsCodeController;

  @override
  void initState() {
    super.initState();
    final position = widget.initialPosition;
    _codeController = TextEditingController(text: position.code);
    _statusController = TextEditingController(
      text: position.isActive ? 'Active' : 'Inactive',
    );
    _titleEnglishController = TextEditingController(
      text: position.titleEnglish,
    );
    _titleArabicController = TextEditingController(text: position.titleArabic);
    _divisionController = TextEditingController(text: position.division);
    _departmentController = TextEditingController(text: position.department);
    _costCenterController = TextEditingController(text: position.costCenter);
    _locationController = TextEditingController(text: position.location);
    _jobFamilyController = TextEditingController(text: position.jobFamily);
    _jobLevelController = TextEditingController(text: position.level);
    _gradeController = TextEditingController(text: position.grade);
    _stepController = TextEditingController(text: position.step);
    _positionsController = TextEditingController(
      text: position.headcount.toString(),
    );
    _filledController = TextEditingController(text: position.filled.toString());
    _employmentController = TextEditingController(text: 'Full-Time');
    _budgetedMinController = TextEditingController(text: position.budgetedMin);
    _budgetedMaxController = TextEditingController(text: position.budgetedMax);
    _actualAverageController = TextEditingController(
      text: position.actualAverage,
    );
    _reportsTitleController = TextEditingController(
      text: position.reportsTo ?? '',
    );
    _reportsCodeController = TextEditingController(
      text: position.reportsTo ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _statusController.dispose();
    _titleEnglishController.dispose();
    _titleArabicController.dispose();
    _divisionController.dispose();
    _departmentController.dispose();
    _costCenterController.dispose();
    _locationController.dispose();
    _jobFamilyController.dispose();
    _jobLevelController.dispose();
    _gradeController.dispose();
    _stepController.dispose();
    _positionsController.dispose();
    _filledController.dispose();
    _employmentController.dispose();
    _budgetedMinController.dispose();
    _budgetedMaxController.dispose();
    _actualAverageController.dispose();
    _reportsTitleController.dispose();
    _reportsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1050.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PositionDialogHeader(
                title: widget.isEdit
                    ? localizations.editPosition
                    : localizations.addPosition,
                onClose: () => Navigator.of(context).pop(),
              ),
              Divider(height: 1.h, color: const Color(0xffD1D5DC)),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PositionDialogSection(
                        title: localizations.basicInformation,
                        children: [
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.positionCode,
                                _codeController,
                              ),
                              _buildFormField(
                                localizations.status,
                                _statusController,
                              ),
                            ],
                          ),
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.titleEnglish,
                                _titleEnglishController,
                              ),
                              _buildFormField(
                                localizations.titleArabic,
                                _titleArabicController,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      PositionDialogSection(
                        title: localizations.organizationalInformation,
                        children: [
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.division,
                                _divisionController,
                              ),
                              _buildFormField(
                                localizations.department,
                                _departmentController,
                              ),
                            ],
                          ),
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.costCenter,
                                _costCenterController,
                              ),
                              _buildFormField(
                                localizations.location,
                                _locationController,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      PositionDialogSection(
                        title: localizations.jobClassification,
                        children: [
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.jobFamily,
                                _jobFamilyController,
                              ),
                              _buildFormField(
                                localizations.jobLevel,
                                _jobLevelController,
                              ),
                            ],
                          ),
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.gradeStep,
                                _gradeController,
                              ),
                              _buildFormField(
                                localizations.step,
                                _stepController,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      PositionDialogSection(
                        title: localizations.headcountInformation,
                        children: [
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.positionCode,
                                _positionsController,
                              ),
                              _buildFormField(
                                localizations.filled,
                                _filledController,
                              ),
                              _buildFormField(
                                localizations.employmentType,
                                _employmentController,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      PositionDialogSection(
                        title: localizations.salaryInformation,
                        children: [
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.budgetedMin,
                                _budgetedMinController,
                              ),
                              _buildFormField(
                                localizations.budgetedMax,
                                _budgetedMaxController,
                              ),
                              _buildFormField(
                                localizations.actualAverage,
                                _actualAverageController,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      PositionDialogSection(
                        title: localizations.reportingRelationship,
                        children: [
                          PositionFormRow(
                            children: [
                              _buildFormField(
                                localizations.reportsTo,
                                _reportsTitleController,
                              ),
                              _buildFormField(
                                localizations.reportsTo,
                                _reportsCodeController,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.h),
              _buildFooter(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return PositionLabeledField(
      label: label,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.inputBg,
          hintText: label,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
        ),
        validator: (value) =>
            (value ?? '').isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _buildFooter(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            label: localizations.cancel,
            onTap: () => Navigator.of(context).pop(),
            isPrimary: false,
          ),
          SizedBox(width: 12.w),
          _buildActionButton(
            label: widget.isEdit
                ? localizations.saveUpdates
                : localizations.saveChanges,
            icon: Icons.save,
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop();
              }
            },
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: isPrimary ? null : Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: Colors.white),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isPrimary ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
