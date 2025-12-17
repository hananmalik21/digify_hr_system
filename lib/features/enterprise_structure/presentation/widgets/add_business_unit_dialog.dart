import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddBusinessUnitDialog extends StatefulWidget {
  final bool isEditMode;
  final BusinessUnitOverview? businessUnit;

  const AddBusinessUnitDialog({
    super.key,
    this.isEditMode = false,
    this.businessUnit,
  });

  static Future<void> show(
    BuildContext context, {
    bool isEditMode = false,
    BusinessUnitOverview? businessUnit,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AddBusinessUnitDialog(
        isEditMode: isEditMode,
        businessUnit: businessUnit,
      ),
    );
  }

  @override
  State<AddBusinessUnitDialog> createState() => _AddBusinessUnitDialogState();
}

class _AddBusinessUnitDialogState extends State<AddBusinessUnitDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _statusOptions = ['Active', 'Inactive'];
  final List<String> _divisionOptions = [
    'Finance & Accounting Division',
    'Human Resources Division',
    'Operations Division',
  ];
  late String? _selectedStatus;
  String? _selectedDivision;

  @override
  void initState() {
    super.initState();
    final fieldKeys = [
      'unitCode',
      'unitNameEnglish',
      'unitNameArabic',
      'headOfUnit',
      'headEmail',
      'headPhone',
      'location',
      'city',
      'establishedDate',
      'businessFocus',
      'totalEmployees',
      'totalDepartments',
      'annualBudget',
      'description',
    ];

    for (final key in fieldKeys) {
      final initialValue = _getInitialValue(key);
      _controllers[key] = TextEditingController(text: initialValue);
    }

    _selectedStatus = widget.businessUnit != null
        ? (widget.businessUnit!.isActive ? 'Active' : 'Inactive')
        : 'Active';
    _selectedDivision = widget.businessUnit?.divisionName;
  }

  String _getInitialValue(String key) {
    final bu = widget.businessUnit;
    switch (key) {
      case 'unitCode':
        return bu?.code ?? '';
      case 'unitNameEnglish':
        return bu?.name ?? '';
      case 'unitNameArabic':
        return bu?.nameArabic ?? '';
      case 'headOfUnit':
        return bu?.headName ?? '';
      case 'headEmail':
        return bu?.headEmail ?? '';
      case 'headPhone':
        return bu?.headPhone ?? '';
      case 'location':
        return bu?.location ?? '';
      case 'city':
        return bu?.city ?? '';
      case 'establishedDate':
        return bu?.establishedDate ?? '';
      case 'businessFocus':
        return bu?.focusArea ?? '';
      case 'totalEmployees':
        return bu?.employees.toString() ?? '';
      case 'totalDepartments':
        return bu?.departments.toString() ?? '';
      case 'annualBudget':
        return bu?.budget ?? '';
      case 'description':
        return bu?.description ?? '';
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_controllers['establishedDate']!.text.isNotEmpty) {
      try {
        final parts = _controllers['establishedDate']!.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {
        initialDate = DateTime.now();
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _controllers['establishedDate']!.text =
            DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(localizations),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(
                  start: 24.w,
                  end: 24.w,
                  top: 24.h,
                  bottom: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.unitCode,
                        keyName: 'unitCode',
                        isRequired: true,
                        hintText: localizations.hintBusinessUnitCode,
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
                        label: localizations.unitNameEnglish,
                        keyName: 'unitNameEnglish',
                        isRequired: true,
                        hintText: localizations.hintBusinessUnitName,
                      ),
                      right: _buildTextField(
                        label: localizations.unitNameArabic,
                        keyName: 'unitNameArabic',
                        isRequired: true,
                        hintText: localizations.hintBusinessUnitNameArabic,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildDropdown(
                        label: localizations.division,
                        value: _selectedDivision,
                        items: _divisionOptions,
                        isRequired: true,
                        hintText: localizations.hintSelectDivision,
                        onChanged: (value) {
                          setState(() {
                            _selectedDivision = value;
                          });
                        },
                      ),
                      right: _buildTextField(
                        label: localizations.headOfUnit,
                        keyName: 'headOfUnit',
                        isRequired: true,
                        hintText: localizations.hintHeadOfUnit,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.headEmail,
                        keyName: 'headEmail',
                        hintText: localizations.hintBusinessUnitHeadEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      right: _buildTextField(
                        label: localizations.headPhone,
                        keyName: 'headPhone',
                        hintText: localizations.hintBusinessUnitHeadPhone,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.location,
                        keyName: 'location',
                        hintText: localizations.hintLocation,
                      ),
                      right: _buildTextField(
                        label: localizations.city,
                        keyName: 'city',
                        hintText: localizations.hintCity,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildDateField(
                        label: localizations.establishedDate,
                        keyName: 'establishedDate',
                      ),
                      right: _buildTextField(
                        label: localizations.businessFocus,
                        keyName: 'businessFocus',
                        hintText: localizations.hintBusinessUnitFocus,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildRow(
                      left: _buildTextField(
                        label: localizations.totalEmployees,
                        keyName: 'totalEmployees',
                        hintText: localizations.hintTotalEmployees,
                        keyboardType: TextInputType.number,
                      ),
                      right: _buildTextField(
                        label: localizations.totalDepartments,
                        keyName: 'totalDepartments',
                        hintText: localizations.hintTotalDepartments,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      label: localizations.annualBudgetKwd,
                      keyName: 'annualBudget',
                      hintText: localizations.hintAnnualBudgetKwd,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8.h),
                    _buildTextArea(
                      label: localizations.description,
                      keyName: 'description',
                      hintText: localizations.hintBusinessUnitDescription,
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

  Widget _buildHeader(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF155DFC), Color(0xFF1447E6)],
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
                assetPath: 'assets/icons/business_unit_icon.svg',
                size: 20.sp,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.isEditMode
                    ? localizations.editBusinessUnit
                    : localizations.addBusinessUnit,
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

  Widget _buildDateField({required String label, required String keyName}) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 24 / 15.3,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 42.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : Colors.white,
              border: Border.all(
                color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _controllers[keyName]!.text.isEmpty
                        ? localizations.hintEstablishedDate
                        : _controllers[keyName]!.text,
                    style: TextStyle(
                      fontSize: 15.6.sp,
                      fontWeight: FontWeight.w400,
                      color: _controllers[keyName]!.text.isEmpty
                          ? (isDark
                              ? AppColors.textPlaceholderDark
                              : const Color(0xFF0A0A0A).withValues(alpha: 0.5))
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF0A0A0A)),
                      height: 24 / 15.6,
                    ),
                  ),
                ),
                SvgIconWidget(
                  assetPath: 'assets/icons/calendar_icon.svg',
                  size: 20.sp,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                ),
              ],
            ),
          ),
        ),
      ],
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
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 9.h),
              backgroundColor: Colors.white,
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
                      ? localizations.updateBusinessUnit
                      : localizations.createBusinessUnit),
                ),
              );
            },
            icon: SvgIconWidget(
              assetPath: 'assets/icons/add_business_unit_icon.svg',
              size: 16.sp,
              color: Colors.white,
            ),
            label: Text(
              widget.isEditMode
                  ? localizations.updateBusinessUnit
                  : localizations.createBusinessUnit,
              style: TextStyle(
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 24 / 15.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF155DFC),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
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
