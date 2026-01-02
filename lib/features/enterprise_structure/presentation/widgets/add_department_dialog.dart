import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/department.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/business_unit_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/department_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

class AddDepartmentDialog extends ConsumerStatefulWidget {
  final bool isEditMode;
  final DepartmentOverview? department;

  const AddDepartmentDialog({super.key, this.isEditMode = false, this.department});

  static Future<void> show(BuildContext context, {bool isEditMode = false, DepartmentOverview? department}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AddDepartmentDialog(isEditMode: isEditMode, department: department),
    );
  }

  @override
  ConsumerState<AddDepartmentDialog> createState() => _AddDepartmentDialogState();
}

class _AddDepartmentDialogState extends ConsumerState<AddDepartmentDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _statusOptions = ['Active', 'Inactive'];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedStatus;
  String? _selectedBusinessUnit;
  int? _selectedBusinessUnitId;

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
      final initialValue = _getInitialValue(key);
      _controllers[key] = TextEditingController(text: initialValue);
    }

    _selectedStatus = widget.department != null ? (widget.department!.isActive ? 'Active' : 'Inactive') : 'Active';
    _selectedBusinessUnit = widget.department?.businessUnitName;
  }

  String _getInitialValue(String key) {
    final dept = widget.department;
    switch (key) {
      case 'departmentCode':
        return dept?.code ?? '';
      case 'departmentNameEnglish':
        return dept?.name ?? '';
      case 'departmentNameArabic':
        return dept?.nameArabic ?? '';
      case 'headOfDepartment':
        return dept?.headName ?? '';
      case 'headEmail':
        return dept?.headEmail ?? '';
      case 'headPhone':
        return dept?.headPhone ?? '';
      case 'employees':
        return dept?.employees.toString() ?? '';
      case 'sections':
        return dept?.sections.toString() ?? '';
      case 'annualBudget':
        return dept?.budget ?? '';
      case 'description':
        return dept?.focusArea ?? '';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    if (_selectedBusinessUnit == null || _selectedBusinessUnitId == null) {
      ToastService.error(context, 'Please select a business unit');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final departmentData = <String, dynamic>{
        'BUSINESS_UNIT_ID': _selectedBusinessUnitId,
        'DEPARTMENT_CODE': _controllers['departmentCode']!.text.trim(),
        'DEPARTMENT_NAME_EN': _controllers['departmentNameEnglish']!.text.trim(),
        'DEPARTMENT_NAME_AR': _controllers['departmentNameArabic']!.text.trim(),
        'STATUS': _selectedStatus?.toUpperCase() ?? 'ACTIVE',
        'HEAD_OF_DEPARTMENT': _controllers['headOfDepartment']!.text.trim(),
        if (_controllers['headEmail']!.text.trim().isNotEmpty) 'HEAD_EMAIL': _controllers['headEmail']!.text.trim(),
        if (_controllers['headPhone']!.text.trim().isNotEmpty) 'HEAD_PHONE': _controllers['headPhone']!.text.trim(),
        if (_controllers['employees']!.text.trim().isNotEmpty)
          'TOTAL_EMPLOYEES': int.tryParse(_controllers['employees']!.text.trim()),
        if (_controllers['sections']!.text.trim().isNotEmpty)
          'TOTAL_SUB_DEPARTMENTS': int.tryParse(_controllers['sections']!.text.trim()),
        if (_controllers['annualBudget']!.text.trim().isNotEmpty)
          'TOTAL_BUDGET': double.tryParse(_controllers['annualBudget']!.text.trim()),
        if (_controllers['description']!.text.trim().isNotEmpty)
          'DESCRIPTION': _controllers['description']!.text.trim(),
      };

      if (widget.isEditMode && widget.department != null) {
        final updateUseCase = ref.read(updateDepartmentUseCaseProvider);
        await updateUseCase(int.parse(widget.department!.id), departmentData);
        if (mounted) {
          Navigator.of(context).pop();
          ref.read(departmentListNotifierProvider.notifier).refresh();
          ToastService.success(context, AppLocalizations.of(context)!.updateDepartment);
        }
      } else {
        final createUseCase = ref.read(createDepartmentUseCaseProvider);
        await createUseCase(departmentData);
        if (mounted) {
          Navigator.of(context).pop();
          ref.read(departmentListNotifierProvider.notifier).refresh();
          ToastService.success(context, AppLocalizations.of(context)!.addDepartment);
        }
      }
    } on AppException catch (e) {
      if (mounted) {
        ToastService.error(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'An error occurred: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final businessUnitsState = ref.watch(businessUnitsDropdownProvider);
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 960.w, maxHeight: MediaQuery.of(context).size.height * 0.95),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
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
                          widget.isEditMode ? localizations.editDepartment : localizations.addDepartment,
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
                  child: Form(
                    key: _formKey,
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
                        _buildBusinessUnitDropdown(localizations, businessUnitsState, isDark),
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
              ),
              Divider(color: const Color(0xFFE5E7EB), height: 1, thickness: 1),
              _buildFooter(localizations),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessUnitDropdown(
    AppLocalizations localizations,
    BusinessUnitListState businessUnitsState,
    bool isDark,
  ) {
    if (businessUnitsState.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.businessUnit,
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 42.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : Colors.white,
              border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
          ),
        ],
      );
    }

    if (businessUnitsState.hasError) {
      return _buildDropdown(
        label: localizations.businessUnit,
        value: _selectedBusinessUnit,
        items: const [],
        isRequired: true,
        hintText: 'Error loading business units',
        onChanged: (_) {},
      );
    }

    final businessUnits = businessUnitsState.businessUnits;
    final businessUnitNames = businessUnits.map((bu) => bu.name).toSet().toList();

    // Validate and set selected business unit
    String? validSelectedBusinessUnit = _selectedBusinessUnit;

    // If selected business unit doesn't exist in the list, set it to null
    if (validSelectedBusinessUnit != null && !businessUnitNames.contains(validSelectedBusinessUnit)) {
      if (widget.isEditMode && widget.department != null && businessUnits.isNotEmpty) {
        final matchingBU = businessUnits.firstWhere(
          (bu) => bu.name.toLowerCase() == widget.department!.businessUnitName.toLowerCase(),
          orElse: () => businessUnits.first,
        );
        if (matchingBU.name.toLowerCase() == widget.department!.businessUnitName.toLowerCase() &&
            businessUnitNames.contains(matchingBU.name)) {
          validSelectedBusinessUnit = matchingBU.name;
        } else {
          validSelectedBusinessUnit = null;
        }
      } else {
        validSelectedBusinessUnit = null;
      }
    }

    // Ensure selected value is in the items list
    if (validSelectedBusinessUnit != null &&
        (businessUnitNames.isEmpty || !businessUnitNames.contains(validSelectedBusinessUnit))) {
      validSelectedBusinessUnit = null;
    }

    // Initialize selected business unit ID if editing and we have a valid selection
    if (widget.isEditMode &&
        widget.department != null &&
        _selectedBusinessUnitId == null &&
        validSelectedBusinessUnit != null) {
      final matchingBU = businessUnits.firstWhere(
        (bu) => bu.name == validSelectedBusinessUnit,
        orElse: () => businessUnits.isNotEmpty ? businessUnits.first : businessUnits.first,
      );
      if (matchingBU.id.isNotEmpty) {
        _selectedBusinessUnitId = int.tryParse(matchingBU.id);
      }
    }

    return _buildDropdown(
      label: localizations.businessUnit,
      value: validSelectedBusinessUnit,
      items: businessUnitNames,
      isRequired: true,
      hintText: localizations.hintBusinessUnit,
      onChanged: (value) {
        setState(() {
          _selectedBusinessUnit = value;
          if (value != null && businessUnits.isNotEmpty) {
            final bu = businessUnits.firstWhere((bu) => bu.name == value, orElse: () => businessUnits.first);
            if (bu.id.isNotEmpty) {
              _selectedBusinessUnitId = int.tryParse(bu.id);
            }
          } else {
            _selectedBusinessUnitId = null;
          }
        });
      },
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

  Widget _buildTextArea({required String label, required String keyName, String? hintText}) {
    return EnterpriseStructureTextField(
      label: label,
      controller: _controllers[keyName],
      hintText: hintText,
      maxLines: 4,
    );
  }

  Widget _buildFooter(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 24.w, end: 24.w, top: 24.h, bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: const BorderSide(color: Color(0xFFD1D5DC)),
              ),
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.6),
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
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009689),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              disabledBackgroundColor: const Color(0xFF009689).withValues(alpha: 0.6),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIconWidget(
                        assetPath: 'assets/icons/add_department_icon.svg',
                        size: 16.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.isEditMode ? localizations.updateDepartment : localizations.addDepartment,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 24 / 15.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
