import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/company_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/division_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddDivisionDialog extends ConsumerStatefulWidget {
  final bool isEditMode;
  final Map<String, dynamic>? initialData;

  const AddDivisionDialog({
    super.key,
    this.isEditMode = false,
    this.initialData,
  });

  static Future<void> show(BuildContext context,
      {bool isEditMode = false, Map<String, dynamic>? initialData}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AddDivisionDialog(
        isEditMode: isEditMode,
        initialData: initialData,
      ),
    );
  }

  @override
  ConsumerState<AddDivisionDialog> createState() => _AddDivisionDialogState();
}

class _AddDivisionDialogState extends ConsumerState<AddDivisionDialog> {
  late final Map<String, TextEditingController> _controllers;
  String? _selectedStatus;
  int? _selectedCompanyId;
  String? _selectedCompanyName;
  bool _isSubmitting = false;

  final List<String> _statusOptions = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialData?['status'] ?? 'Active';
    // Initialize company selection if provided
    if (widget.initialData?['companyId'] != null) {
      _selectedCompanyId = widget.initialData?['companyId'] as int?;
      _selectedCompanyName = widget.initialData?['company'] as String?;
    } else if (widget.initialData?['company'] != null) {
      // If company name is provided but not ID, we'll need to find it
      _selectedCompanyName = widget.initialData?['company'] as String?;
    }

    _controllers = {
      'divisionCode':
          TextEditingController(text: widget.initialData?['divisionCode'] ?? ''),
      'nameEn': TextEditingController(text: widget.initialData?['nameEn'] ?? ''),
      'nameAr': TextEditingController(text: widget.initialData?['nameAr'] ?? ''),
      'headOfDivision':
          TextEditingController(text: widget.initialData?['headOfDivision'] ?? ''),
      'headEmail':
          TextEditingController(text: widget.initialData?['headEmail'] ?? ''),
      'headPhone':
          TextEditingController(text: widget.initialData?['headPhone'] ?? ''),
      'location':
          TextEditingController(text: widget.initialData?['location'] ?? ''),
      'city': TextEditingController(text: widget.initialData?['city'] ?? ''),
      'address':
          TextEditingController(text: widget.initialData?['address'] ?? ''),
      'establishedDate':
          TextEditingController(text: widget.initialData?['establishedDate'] ?? ''),
      'businessFocus':
          TextEditingController(text: widget.initialData?['businessFocus'] ?? ''),
      'totalEmployees':
          TextEditingController(text: widget.initialData?['totalEmployees'] ?? '0'),
      'totalDepartments':
          TextEditingController(text: widget.initialData?['totalDepartments'] ?? '0'),
      'annualBudget':
          TextEditingController(text: widget.initialData?['annualBudget'] ?? '0'),
      'description':
          TextEditingController(text: widget.initialData?['description'] ?? ''),
    };
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
        final dateStr = _controllers['establishedDate']!.text;
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9810FA),
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
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _controllers['establishedDate']!.text = formattedDate;
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
          maxWidth: 900.w,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                    // Row 1: Division Code | Status
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.divisionCode,
                        keyName: 'divisionCode',
                        isRequired: true,
                        hintText: localizations.hintDivisionCode,
                      ),
                      right: _buildDropdown(
                        label: localizations.status,
                        value: _selectedStatus,
                        items: _statusOptions,
                        isRequired: true,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Row 2: Division Name (English) | Division Name (Arabic)
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.divisionNameEnglish,
                        keyName: 'nameEn',
                        isRequired: true,
                        hintText: localizations.hintDivisionNameEnglish,
                      ),
                      right: _buildTextField(
                        label: localizations.divisionNameArabic,
                        keyName: 'nameAr',
                        isRequired: true,
                        hintText: localizations.hintDivisionNameArabic,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Row 3: Company | Head of Division
                    _buildTwoColumnRow(
                      left: _buildCompanyDropdown(),
                      right: _buildTextField(
                        label: localizations.headOfDivision,
                        keyName: 'headOfDivision',
                        isRequired: true,
                        hintText: localizations.hintHeadOfDivision,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Row 4: Head Email | Head Phone
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.headEmail,
                        keyName: 'headEmail',
                        hintText: localizations.hintHeadEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      right: _buildTextField(
                        label: localizations.headPhone,
                        keyName: 'headPhone',
                        hintText: localizations.hintHeadPhone,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Row 5: Location | City
                    _buildTwoColumnRow(
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
                    // Row 6: Address (full width)
                    _buildTextField(
                      label: localizations.address,
                      keyName: 'address',
                      hintText: localizations.hintAddress,
                    ),
                    SizedBox(height: 8.h),
                    // Row 7: Established Date | Business Focus
                    _buildTwoColumnRow(
                      left: _buildDateField(
                        label: localizations.establishedDate,
                        keyName: 'establishedDate',
                      ),
                      right: _buildTextField(
                        label: localizations.businessFocus,
                        keyName: 'businessFocus',
                        hintText: localizations.hintBusinessFocus,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Row 8: Total Employees | Total Departments
                    _buildTwoColumnRow(
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
                    // Row 9: Annual Budget (KWD) - only left side
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.annualBudgetKwd,
                        keyName: 'annualBudget',
                        hintText: localizations.hintAnnualBudgetKwd,
                        keyboardType: TextInputType.number,
                      ),
                      right: const SizedBox(), // Empty right side
                    ),
                    SizedBox(height: 8.h),
                    // Row 10: Description (full width, textarea)
                    _buildTextArea(
                      label: localizations.divisionDescription,
                      keyName: 'description',
                      hintText: localizations.hintDivisionDescription,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
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
          colors: [Color(0xFF9810FA), Color(0xFF8200DB)],
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
                assetPath: 'assets/icons/division_header_icon.svg',
                size: 20.sp,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.isEditMode
                    ? localizations.editDivision
                    : localizations.addNewDivision,
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

  Widget _buildTwoColumnRow({
    required Widget left,
    required Widget right,
  }) {
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
  }) {
    return EnterpriseStructureTextField(
      label: label,
      isRequired: isRequired,
      controller: _controllers[keyName],
      hintText: hintText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      onChanged: (value) {},
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
      maxLines: 3,
      onChanged: (value) {},
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
      isRequired: isRequired,
      value: value,
      items: items,
      onChanged: onChanged,
      hintText: hintText,
    );
  }

  Widget _buildDateField({
    required String label,
    required String keyName,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

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
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 17.w,
              vertical: 9.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : Colors.white,
              border: Border.all(
                color:
                    isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
                width: 1,
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
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF0A0A0A),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(AppLocalizations localizations) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      padding: EdgeInsetsDirectional.only(
        start: 24.w,
        end: 24.w,
        top: 25.h,
        bottom: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 19.h),
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
            onPressed: _isSubmitting ? null : _handleSave,
            icon: _isSubmitting
                ? SizedBox(
                    width: 16.sp,
                    height: 16.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SvgIconWidget(
                    assetPath: 'assets/icons/save_division_icon.svg',
                    size: 16.sp,
                    color: Colors.white,
                  ),
            label: _isSubmitting
                ? SizedBox(
                    width: 16.sp,
                    height: 16.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.isEditMode
                        ? localizations.updateDivision
                        : localizations.createDivision,
                    style: TextStyle(
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                      height: 24 / 15.3,
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSubmitting 
                  ? const Color(0xFF9810FA).withValues(alpha: 0.6)
                  : const Color(0xFF9810FA),
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

  Widget _buildCompanyDropdown() {
    final localizations = AppLocalizations.of(context)!;
    final companiesState = ref.watch(companiesProvider);
    final companies = companiesState.companies;
    
    // Find and set selected value based on companyId
    String? selectedValue;
    if (_selectedCompanyId != null && companies.isNotEmpty) {
      try {
        final selectedCompany = companies.firstWhere(
          (c) => int.tryParse(c.id) == _selectedCompanyId,
        );
        selectedValue = selectedCompany.name;
        _selectedCompanyName ??= selectedCompany.name;
      } catch (e) {
        // Company not found, use provided name if available
        selectedValue = _selectedCompanyName;
      }
    }

    return EnterpriseStructureDropdown(
      key: ValueKey('company_dropdown_${_selectedCompanyId}_${companies.length}_${companiesState.isLoading}'),
      label: localizations.company,
      isRequired: true,
      value: companiesState.isLoading
          ? 'Loading...'
          : companiesState.hasError
              ? 'Error loading companies'
              : companies.isEmpty
                  ? 'No companies available'
                  : selectedValue,
      items: companiesState.isLoading
          ? const ['Loading...']
          : companiesState.hasError
              ? const ['Error loading companies']
              : companies.isEmpty
                  ? const ['No companies available']
                  : companies.map((company) => company.name).toList(),
      onChanged: (value) {
        if (value != null && !companiesState.isLoading && !companiesState.hasError && companies.isNotEmpty) {
          try {
            final selectedCompany = companies.firstWhere(
              (c) => c.name == value,
            );
            setState(() {
              _selectedCompanyId = int.tryParse(selectedCompany.id);
              _selectedCompanyName = selectedCompany.name;
            });
          } catch (e) {
            // Company not found, ignore
          }
        }
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSubmitting) return;

    final localizations = AppLocalizations.of(context)!;

    // Validate required fields
    if (_controllers['divisionCode']!.text.trim().isEmpty ||
        _controllers['nameEn']!.text.trim().isEmpty ||
        _controllers['nameAr']!.text.trim().isEmpty ||
        _selectedCompanyId == null ||
        _controllers['headOfDivision']!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Format date from DD/MM/YYYY to YYYY-MM-DD
      String? establishedDate;
      if (_controllers['establishedDate']!.text.isNotEmpty) {
        try {
          final parts = _controllers['establishedDate']!.text.split('/');
          if (parts.length == 3) {
            establishedDate = '${parts[2]}-${parts[1]}-${parts[0]}';
          }
        } catch (e) {
          // If parsing fails, use as is
          establishedDate = _controllers['establishedDate']!.text;
        }
      }

      // Prepare division data according to API format (uppercase field names)
      final divisionData = <String, dynamic>{
        'COMPANY_ID': _selectedCompanyId,
        'DIVISION_CODE': _controllers['divisionCode']!.text.trim(),
        'DIVISION_NAME_EN': _controllers['nameEn']!.text.trim(),
        'DIVISION_NAME_AR': _controllers['nameAr']!.text.trim(),
        'STATUS': _selectedStatus ?? 'Active',
        'HEAD_OF_DIVISION': _controllers['headOfDivision']!.text.trim(),
        if (_controllers['headEmail']!.text.trim().isNotEmpty)
          'HEAD_EMAIL': _controllers['headEmail']!.text.trim(),
        if (_controllers['headPhone']!.text.trim().isNotEmpty)
          'HEAD_PHONE': _controllers['headPhone']!.text.trim(),
        if (_controllers['location']!.text.trim().isNotEmpty)
          'LOCATION': _controllers['location']!.text.trim(),
        if (_controllers['city']!.text.trim().isNotEmpty)
          'CITY': _controllers['city']!.text.trim(),
        if (_controllers['address']!.text.trim().isNotEmpty)
          'ADDRESS': _controllers['address']!.text.trim(),
        if (establishedDate != null) 'ESTABLISHED_DATE': establishedDate,
        if (_controllers['businessFocus']!.text.trim().isNotEmpty)
          'BUSINESS_FOCUS': _controllers['businessFocus']!.text.trim(),
        if (_controllers['totalEmployees']!.text.trim().isNotEmpty)
          'TOTAL_EMPLOYEES': int.tryParse(_controllers['totalEmployees']!.text.trim()) ?? 0,
        if (_controllers['totalDepartments']!.text.trim().isNotEmpty)
          'TOTAL_DEPARTMENTS': int.tryParse(_controllers['totalDepartments']!.text.trim()) ?? 0,
        if (_controllers['annualBudget']!.text.trim().isNotEmpty)
          'ANNUAL_BUDGET_KWD': double.tryParse(_controllers['annualBudget']!.text.trim()) ?? 0.0,
        if (_controllers['description']!.text.trim().isNotEmpty)
          'DESCRIPTION': _controllers['description']!.text.trim(),
        "LAST_UPDATE_LOGIN": "ADMIN"
      };

      if (widget.isEditMode && widget.initialData != null) {
        final divisionId = widget.initialData!['divisionId'] as int?;
        if (divisionId != null && divisionId > 0) {
          final updateDivisionUseCase = ref.read(updateDivisionUseCaseProvider);
          await updateDivisionUseCase(divisionId, divisionData);
        } else {
          throw Exception('Invalid division ID for update');
        }
      } else {
        final createDivisionUseCase = ref.read(createDivisionUseCaseProvider);
        await createDivisionUseCase(divisionData);
      }

      // Refresh divisions list
      ref.read(divisionsProvider.notifier).refresh();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditMode
                  ? localizations.updateDivision
                  : localizations.createDivision,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditMode
                  ? 'Failed to update division: ${e.toString()}'
                  : 'Failed to create division: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

