import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/create_company_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/update_company_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/company_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddCompanyDialog extends ConsumerStatefulWidget {
  final bool isEditMode;
  final Map<String, dynamic>? initialData;

  const AddCompanyDialog({
    super.key,
    this.isEditMode = false,
    this.initialData,
  });

  static Future<void> show(BuildContext context, {bool isEditMode = false, Map<String, dynamic>? initialData}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AddCompanyDialog(
        isEditMode: isEditMode,
        initialData: initialData,
      ),
    );
  }

  @override
  ConsumerState<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends ConsumerState<AddCompanyDialog> {
  late final Map<String, TextEditingController> _controllers;
  String? _selectedStatus;
  String? _selectedCurrency;
  int? _selectedOrgStructureId;
  bool _isSubmitting = false;

  final List<String> _statusOptions = ['Active', 'Inactive'];
  final List<String> _currencyOptions = [
    'KWD - Kuwaiti Dinar',
    'USD - US Dollar',
    'EUR - Euro',
    'GBP - British Pound',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialData?['status'] ?? 'Active';
    _selectedCurrency = widget.initialData?['currency'] ?? 'KWD - Kuwaiti Dinar';
    _selectedOrgStructureId = widget.initialData?['orgStructureId'] as int?;
    
    _controllers = {
      'companyCode': TextEditingController(text: widget.initialData?['companyCode'] ?? ''),
      'nameEn': TextEditingController(text: widget.initialData?['nameEn'] ?? ''),
      'nameAr': TextEditingController(text: widget.initialData?['nameAr'] ?? ''),
      'legalNameEn': TextEditingController(text: widget.initialData?['legalNameEn'] ?? ''),
      'legalNameAr': TextEditingController(text: widget.initialData?['legalNameAr'] ?? ''),
      'registrationNumber': TextEditingController(text: widget.initialData?['registrationNumber'] ?? ''),
      'taxId': TextEditingController(text: widget.initialData?['taxId'] ?? ''),
      'establishedDate': TextEditingController(text: widget.initialData?['establishedDate'] ?? ''),
      'industry': TextEditingController(text: widget.initialData?['industry'] ?? ''),
      'country': TextEditingController(text: widget.initialData?['country'] ?? ''),
      'city': TextEditingController(text: widget.initialData?['city'] ?? ''),
      'address': TextEditingController(text: widget.initialData?['address'] ?? ''),
      'poBox': TextEditingController(text: widget.initialData?['poBox'] ?? ''),
      'zipCode': TextEditingController(text: widget.initialData?['zipCode'] ?? ''),
      'phone': TextEditingController(text: widget.initialData?['phone'] ?? ''),
      'email': TextEditingController(text: widget.initialData?['email'] ?? ''),
      'website': TextEditingController(text: widget.initialData?['website'] ?? ''),
      'totalEmployees': TextEditingController(text: widget.initialData?['totalEmployees'] ?? ''),
      'fiscalYearStart': TextEditingController(text: widget.initialData?['fiscalYearStart'] ?? ''),
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
    // Parse initial date if provided, otherwise use current date
    DateTime initialDate = DateTime.now();
    if (widget.initialData?['establishedDate'] != null && 
        widget.initialData!['establishedDate'].toString().isNotEmpty) {
      try {
        final dateStr = widget.initialData!['establishedDate'].toString();
        // Try parsing DD/MM/YYYY format
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        // If parsing fails, use current date
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
    
    // Pre-load organization structures when dialog opens (only once)
    // The provider will automatically load data when first accessed
    ref.read(orgStructuresDropdownProvider.notifier);
    

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
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.companyCode,
                        keyName: 'companyCode',
                        isRequired: true,
                        hintText: localizations.hintCompanyCode,
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
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.companyNameEnglish,
                        keyName: 'nameEn',
                        isRequired: true,
                        hintText: localizations.hintCompanyNameEnglish,
                      ),
                      right: _buildTextField(
                        label: localizations.companyNameArabic,
                        keyName: 'nameAr',
                        isRequired: true,
                        hintText: localizations.hintCompanyNameArabic,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.legalNameEnglish,
                        keyName: 'legalNameEn',
                        hintText: localizations.hintLegalNameEnglish,
                      ),
                      right: _buildTextField(
                        label: localizations.legalNameArabic,
                        keyName: 'legalNameAr',
                        hintText: localizations.hintLegalNameArabic,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.registrationNumber,
                        keyName: 'registrationNumber',
                        isRequired: true,
                        hintText: localizations.hintRegistrationNumber,
                      ),
                      right: _buildTextField(
                        label: localizations.taxId,
                        keyName: 'taxId',
                        hintText: localizations.hintTaxId,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildDateField(
                        label: localizations.establishedDate,
                        keyName: 'establishedDate',
                      ),
                      right: _buildTextField(
                        label: localizations.industry,
                        keyName: 'industry',
                        hintText: localizations.hintIndustry,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.country,
                        keyName: 'country',
                        hintText: localizations.hintCountry,
                      ),
                      right: _buildTextField(
                        label: localizations.city,
                        keyName: 'city',
                        hintText: localizations.hintCity,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      label: localizations.address,
                      keyName: 'address',
                      hintText: localizations.hintAddress,
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.poBox,
                        keyName: 'poBox',
                        hintText: localizations.hintPoBox,
                      ),
                      right: _buildTextField(
                        label: localizations.zipCode,
                        keyName: 'zipCode',
                        hintText: localizations.hintZipCode,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.phone,
                        keyName: 'phone',
                        hintText: localizations.hintPhone,
                        keyboardType: TextInputType.phone,
                      ),
                      right: _buildTextField(
                        label: localizations.email,
                        keyName: 'email',
                        hintText: localizations.hintEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildTextField(
                        label: localizations.website,
                        keyName: 'website',
                        hintText: localizations.hintWebsite,
                        keyboardType: TextInputType.url,
                      ),
                      right: _buildTextField(
                        label: localizations.totalEmployees,
                        keyName: 'totalEmployees',
                        hintText: localizations.hintTotalEmployees,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTwoColumnRow(
                      left: _buildDropdown(
                        label: localizations.currency,
                        value: _selectedCurrency,
                        items: _currencyOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value;
                          });
                        },
                      ),
                      right: _buildTextField(
                        label: localizations.fiscalYearStart,
                        keyName: 'fiscalYearStart',
                        hintText: localizations.hintFiscalYearStart,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildOrgStructureDropdown(),
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
          colors: [Color(0xFF4F39F6), Color(0xFF432DD7)],
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
                assetPath: 'assets/icons/company_stat_icon.svg',
                size: 20.sp,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.isEditMode ? localizations.editCompany : localizations.addCompany,
                style: TextStyle(
                  fontSize: 18.8.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 30 / 18.8,
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return EnterpriseStructureDropdown(
      label: label,
      isRequired: isRequired,
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildOrgStructureDropdown() {
    final structureListState = ref.watch(orgStructuresDropdownProvider);
    final structures = structureListState.structures;
    
    if (structureListState.isLoading) {
      return EnterpriseStructureDropdown(
        label: 'Organization',
        isRequired: true,
        value: _selectedOrgStructureId != null ? 'Loading...' : null,
        items: const ['Loading...'],
        onChanged: (_) {},
      );
    }

    if (structureListState.hasError) {
      return EnterpriseStructureDropdown(
        label: 'Organization',
        isRequired: true,
        value: 'Error loading organizations',
        items: const ['Error loading organizations'],
        onChanged: (_) {},
      );
    }

    if (structures.isEmpty) {
      return EnterpriseStructureDropdown(
        label: 'Organization',
        isRequired: true,
        value: 'No organizations available',
        items: const ['No organizations available'],
        onChanged: (_) {},
      );
    }

    // Show all structures (both active and inactive)
    final structureItems = structures
        .map((structure) => '${structure.structureName} (${structure.structureCode})')
        .toList();
    
    // Find and set selected value based on orgStructureId
    String? selectedValue;
    // Only try to set selection if we have a valid orgStructureId (not null and not 0)
    if (_selectedOrgStructureId != null && 
        _selectedOrgStructureId! > 0 && 
        structures.isNotEmpty) {
      // Try to find the structure by ID
      try {
        final matchingStructure = structures.firstWhere(
          (s) => s.structureId == _selectedOrgStructureId,
        );
        selectedValue = '${matchingStructure.structureName} (${matchingStructure.structureCode})';
      } catch (e) {
        // If exact match not found, try string comparison as fallback
        try {
          final matchingByString = structures.firstWhere(
            (s) => s.structureId.toString() == _selectedOrgStructureId.toString(),
          );
          selectedValue = '${matchingByString.structureName} (${matchingByString.structureCode})';
          // Update the state to use the correct ID format
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedOrgStructureId = matchingByString.structureId;
              });
            }
          });
        } catch (e2) {
          // Structure not found - selectedValue remains null
          selectedValue = null;
        }
      }
    }

    return EnterpriseStructureDropdown(
      key: ValueKey('org_dropdown_${_selectedOrgStructureId}_${structures.length}'),
      label: 'Organization',
      isRequired: true,
      value: selectedValue,
      items: structureItems,
      onChanged: (value) {
        if (value != null && structureItems.contains(value)) {
          final selectedIndex = structureItems.indexOf(value);
          if (selectedIndex >= 0 && selectedIndex < structures.length) {
            setState(() {
              _selectedOrgStructureId = structures[selectedIndex].structureId;
            });
          }
        }
      },
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
            color: isDark
                ? AppColors.textPrimaryDark
                : const Color(0xFF364153),
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
              color: isDark
                  ? AppColors.inputBgDark
                  : Colors.white, // Exact Figma fill color
              border: Border.all(
                color: isDark
                    ? AppColors.inputBorderDark
                    : const Color(0xFFD1D5DC),
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
            onPressed: _isSubmitting ? null : _handleSave,
            icon: SvgIconWidget(
              assetPath: 'assets/icons/save_icon.svg',
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
                        ? localizations.updateCompany
                        : localizations.addCompany,
                    style: TextStyle(
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                      height: 24 / 15.3,
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSubmitting 
                  ? const Color(0xFF4F39F6).withValues(alpha: 0.6)
                  : const Color(0xFF4F39F6),
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

  Future<void> _handleSave() async {
    if (_isSubmitting) return;
    
    final localizations = AppLocalizations.of(context)!;

    // Validate required fields
    if (_controllers['companyCode']!.text.trim().isEmpty ||
        _controllers['nameEn']!.text.trim().isEmpty ||
        _controllers['nameAr']!.text.trim().isEmpty ||
        _controllers['registrationNumber']!.text.trim().isEmpty ||
        _selectedOrgStructureId == null) {
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

      // Extract currency code from selected currency (e.g., "KWD - Kuwaiti Dinar" -> "KWD")
      final currencyCode = _selectedCurrency?.split(' - ').first ?? 'KWD';

      // Prepare company data according to API format (uppercase field names)
      final companyData = <String, dynamic>{
        'COMPANY_CODE': _controllers['companyCode']!.text.trim(),
        'COMPANY_NAME_EN': _controllers['nameEn']!.text.trim(),
        'COMPANY_NAME_AR': _controllers['nameAr']!.text.trim(),
        'STATUS': _selectedStatus ?? 'Active',
        'REGISTRATION_NUMBER': _controllers['registrationNumber']!.text.trim(),
        'ORG_STRUCTURE_ID': _selectedOrgStructureId,
        if (_controllers['legalNameEn']!.text.trim().isNotEmpty)
          'LEGAL_NAME_EN': _controllers['legalNameEn']!.text.trim(),
        if (_controllers['legalNameAr']!.text.trim().isNotEmpty)
          'LEGAL_NAME_AR': _controllers['legalNameAr']!.text.trim(),
        if (_controllers['taxId']!.text.trim().isNotEmpty)
          'TAX_ID': _controllers['taxId']!.text.trim(),
        if (establishedDate != null) 'ESTABLISHED_DATE': establishedDate,
        if (_controllers['industry']!.text.trim().isNotEmpty)
          'INDUSTRY': _controllers['industry']!.text.trim(),
        if (_controllers['country']!.text.trim().isNotEmpty)
          'COUNTRY': _controllers['country']!.text.trim(),
        if (_controllers['city']!.text.trim().isNotEmpty)
          'CITY': _controllers['city']!.text.trim(),
        if (_controllers['address']!.text.trim().isNotEmpty)
          'ADDRESS': _controllers['address']!.text.trim(),
        if (_controllers['poBox']!.text.trim().isNotEmpty)
          'PO_BOX': _controllers['poBox']!.text.trim(),
        if (_controllers['zipCode']!.text.trim().isNotEmpty)
          'ZIP_CODE': _controllers['zipCode']!.text.trim(),
        if (_controllers['phone']!.text.trim().isNotEmpty)
          'PHONE': _controllers['phone']!.text.trim(),
        if (_controllers['email']!.text.trim().isNotEmpty)
          'EMAIL': _controllers['email']!.text.trim(),
        if (_controllers['website']!.text.trim().isNotEmpty)
          'WEBSITE': _controllers['website']!.text.trim(),
        if (_controllers['totalEmployees']!.text.trim().isNotEmpty)
          'TOTAL_EMPLOYEES': int.tryParse(_controllers['totalEmployees']!.text.trim()) ?? 0,
        if (currencyCode.isNotEmpty) 'CURRENCY_CODE': currencyCode,
        if (_controllers['fiscalYearStart']!.text.trim().isNotEmpty)
          'FISCAL_YEAR_START': _controllers['fiscalYearStart']!.text.trim(),
        "LAST_UPDATE_LOGIN": "ADMIN"
      };

      if (widget.isEditMode) {
        // Update existing company
        final companyId = widget.initialData?['companyId'] as int?;
        if (companyId == null) {
          throw Exception('Company ID is required for update');
        }

        final updateCompanyUseCase = ref.read(updateCompanyUseCaseProvider);
        await updateCompanyUseCase(companyId, companyData);
      } else {
        // Create new company
        final createCompanyUseCase = ref.read(createCompanyUseCaseProvider);
        await createCompanyUseCase(companyData);
      }

      // Refresh companies list
      ref.read(companiesProvider.notifier).refresh();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditMode
                  ? localizations.updateCompany ?? 'Company updated successfully'
                  : localizations.addCompany ?? 'Company created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${widget.isEditMode ? 'update' : 'create'} company: ${e.toString()}'),
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
