import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/business_unit_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDepartmentDialog extends ConsumerStatefulWidget {
  final bool isEditMode;

  const AddDepartmentDialog({super.key, this.isEditMode = false});

  static Future<void> show(BuildContext context, {bool isEditMode = false}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AddDepartmentDialog(
        isEditMode: isEditMode,
      ),
    );
  }

  @override
  ConsumerState<AddDepartmentDialog> createState() =>
      _AddDepartmentDialogState();
}

class _AddDepartmentDialogState extends ConsumerState<AddDepartmentDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _statusOptions = ['Active', 'Inactive'];
  String? _selectedStatus = 'Active';
  String? _selectedBusinessUnit;

  @override
  void initState() {
    super.initState();
    final keys = [
      'departmentCode',
      'departmentNameEnglish',
      'departmentNameArabic',
      'headOfDepartment',
      'headEmail',
      'headPhone',
      'employees',
      'sections',
      'annualBudget',
      'description',
    ];
    for (final key in keys) {
      _controllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final businessUnits = ref.watch(businessUnitListProvider);
    final isDark = context.isDark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 960.w,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF009689), Color(0xFF00817A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgIconWidget(
                        assetPath: 'assets/icons/department_card_icon.svg',
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.isEditMode
                            ? localizations.editDepartment
                            : localizations.addDepartment,
                        style: TextStyle(
                          fontSize: 18.6.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 30 / 18.6,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: SvgIconWidget(
                        assetPath: 'assets/icons/close_dialog_icon.svg',
                        size: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.departmentCode,
                        keyName: 'departmentCode',
                        isRequired: true,
                        hintText: localizations.hintDepartmentCode,
                      ),
                      right: _buildDropdown(
                        label: localizations.status,
                        value: _selectedStatus,
                        items: _statusOptions,
                        isRequired: true,
                        hintText: _selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.departmentNameEnglish,
                        keyName: 'departmentNameEnglish',
                        isRequired: true,
                        hintText: localizations.hintDepartmentNameEnglish,
                      ),
                      right: _buildTextField(
                        label: localizations.departmentNameArabic,
                        keyName: 'departmentNameArabic',
                        isRequired: true,
                        hintText: localizations.hintDepartmentNameArabic,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildDropdown(
                      label: localizations.businessUnit,
                      value: _selectedBusinessUnit,
                      items: businessUnits.map((e) => e.name).toList(),
                      isRequired: true,
                      hintText: localizations.hintBusinessUnit,
                      onChanged: (value) {
                        setState(() {
                          _selectedBusinessUnit = value;
                        });
                      },
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      label: localizations.headOfDepartment,
                      keyName: 'headOfDepartment',
                      isRequired: true,
                      hintText: localizations.hintHeadOfDepartment,
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.headEmail,
                        keyName: 'headEmail',
                        hintText: localizations.hintEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      right: _buildTextField(
                        label: localizations.headPhone,
                        keyName: 'headPhone',
                        hintText: localizations.hintPhone,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.totalEmployees,
                        keyName: 'employees',
                        hintText: localizations.hintTotalEmployees,
                        keyboardType: TextInputType.number,
                      ),
                      right: _buildTextField(
                        label: localizations.totalDepartments,
                        keyName: 'sections',
                        hintText: localizations.hintTotalDepartments,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      label: localizations.totalBudgetDept,
                      keyName: 'annualBudget',
                      hintText: localizations.hintAnnualBudgetDepartment,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8.h),
                    _buildTextArea(
                      label: localizations.description,
                      keyName: 'description',
                      hintText: localizations.hintDescriptionDepartment,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Divider(color: const Color(0xFFE5E7EB), height: 1, thickness: 1),
            _buildFooter(localizations),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 16.w),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String keyName,
    bool isRequired = false,
    String? hintText,
    TextInputType? keyboardType,
    ui.TextDirection? textDirection,
    int? maxLines,
  }) {
    return EnterpriseStructureTextField(
      label: label,
      controller: _controllers[keyName],
      isRequired: isRequired,
      hintText: hintText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      maxLines: maxLines,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
    String? hintText,
  }) {
    return EnterpriseStructureDropdown(
      label: label,
      value: value,
      items: items,
      isRequired: isRequired,
      hintText: hintText,
      onChanged: onChanged,
    );
  }

  Widget _buildTextArea({
    required String label,
    required String keyName,
    String? hintText,
  }) {
    return EnterpriseStructureTextField(
      label: label,
      controller: _controllers[keyName],
      hintText: hintText,
      maxLines: 4,
    );
  }

  Widget _buildFooter(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 24.w,
        end: 24.w,
        top: 24.h,
        bottom: 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: const BorderSide(color: Color(0xFFD1D5DC)),
              ),
            ),
            child: Text(
              localizations.cancel,
              style: TextStyle(
                color: const Color(0xFF364153),
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                height: 24 / 15.3,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.isEditMode
                      ? localizations.updateDepartment
                      : localizations.addDepartment),
                ),
              );
            },
            icon: SvgIconWidget(
              assetPath: 'assets/icons/add_department_icon.svg',
              size: 16.sp,
              color: Colors.white,
            ),
            label: Text(
              widget.isEditMode
                  ? localizations.updateDepartment
                  : localizations.addDepartment,
              style: TextStyle(
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 24 / 15.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009689),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

