import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
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
    _statusController = TextEditingController(text: position.isActive ? 'Active' : 'Inactive');
    _titleEnglishController = TextEditingController(text: position.titleEnglish);
    _titleArabicController = TextEditingController(text: position.titleArabic);
    _divisionController = TextEditingController(text: position.division);
    _departmentController = TextEditingController(text: position.department);
    _costCenterController = TextEditingController(text: position.costCenter);
    _locationController = TextEditingController(text: position.location);
    _jobFamilyController = TextEditingController(text: position.jobFamily);
    _jobLevelController = TextEditingController(text: position.level);
    _gradeController = TextEditingController(text: position.grade);
    _stepController = TextEditingController(text: position.step);
    _positionsController = TextEditingController(text: position.headcount.toString());
    _filledController = TextEditingController(text: position.filled.toString());
    _employmentController = TextEditingController(text: 'Full-Time');
    _budgetedMinController = TextEditingController(text: position.budgetedMin);
    _budgetedMaxController = TextEditingController(text: position.budgetedMax);
    _actualAverageController = TextEditingController(text: position.actualAverage);
    _reportsTitleController = TextEditingController(text: position.reportsTo ?? '');
    _reportsCodeController = TextEditingController(text: position.reportsTo ?? '');
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
              _buildHeader(localizations),
              Divider(height: 1.h,color: Color(0xffD1D5DC),),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        localizations.basicInformation,
                        [
                          _buildFormRow([
                            _buildLabeledField(localizations.positionCode, _codeController),
                            _buildLabeledField(localizations.status, _statusController),
                          ]),
                          _buildFormRow([
                            _buildLabeledField(localizations.titleEnglish, _titleEnglishController),
                            _buildLabeledField(localizations.titleArabic, _titleArabicController),
                          ]),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        localizations.organizationalInformation,
                        [
                          _buildFormRow([
                            _buildLabeledField(localizations.division, _divisionController),
                            _buildLabeledField(localizations.department, _departmentController),
                          ]),
                          _buildFormRow([
                            _buildLabeledField(localizations.costCenter, _costCenterController),
                            _buildLabeledField(localizations.location, _locationController),
                          ]),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        localizations.jobClassification,
                        [
                          _buildFormRow([
                            _buildLabeledField(localizations.jobFamily, _jobFamilyController),
                            _buildLabeledField(localizations.jobLevel, _jobLevelController),
                          ]),
                          _buildFormRow([
                            _buildLabeledField(localizations.gradeStep, _gradeController),
                            _buildLabeledField(localizations.step, _stepController),
                          ]),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        localizations.headcountInformation,
                        [
                          _buildFormRow([
                            _buildLabeledField(localizations.positionCode, _positionsController),
                            _buildLabeledField(localizations.filled, _filledController),
                            _buildLabeledField(localizations.employmentType, _employmentController),
                          ]),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        localizations.salaryInformation,
                        [
                          _buildFormRow([
                            _buildLabeledField(localizations.budgetedMin, _budgetedMinController),
                            _buildLabeledField(localizations.budgetedMax, _budgetedMaxController),
                            _buildLabeledField(localizations.actualAverage, _actualAverageController),
                          ]),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        localizations.reportingRelationship,
                        [
                          _buildFormRow([
                            _buildLabeledField(localizations.reportsTo, _reportsTitleController),
                            _buildLabeledField(localizations.reportsTo, _reportsCodeController),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildTextButton(localizations.cancel, () => Navigator.of(context).pop()),
                    SizedBox(width: 12.w),
                    _buildPrimaryButton(
                      widget.isEdit ? localizations.saveUpdates : localizations.saveChanges,
                      () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    final title = widget.isEdit ? localizations.editPosition : localizations.addPosition;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(Icons.close, size: 20.sp, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: children,
        ),
      ],
    );
  }

  Widget _buildFormRow(List<Widget> columns) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.asMap().entries.map((entry) {
        final isLast = entry.key == columns.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 16.w),
            child: entry.value,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
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
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          validator: (value) => (value ?? '').isEmpty ? label + ' is required' : null,
        ),
      ],
    );
  }

  Widget _buildTextButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.save, size: 16.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

