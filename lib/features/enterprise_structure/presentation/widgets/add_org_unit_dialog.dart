import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/date_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/parent_org_unit_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dialog for adding or editing an org unit
class AddOrgUnitDialog extends ConsumerStatefulWidget {
  final int structureId;
  final String levelCode;
  final OrgStructureLevel? initialValue;

  const AddOrgUnitDialog({
    super.key,
    required this.structureId,
    required this.levelCode,
    this.initialValue,
  });

  static Future<void> show(
    BuildContext context, {
    required int structureId,
    required String levelCode,
    OrgStructureLevel? initialValue,
  }) {
    debugPrint(
      'AddOrgUnitDialog.show called with structureId=$structureId, levelCode=$levelCode, isEdit=${initialValue != null}',
    );
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (dialogContext) {
        debugPrint('AddOrgUnitDialog builder called');
        return AddOrgUnitDialog(
          structureId: structureId,
          levelCode: levelCode,
          initialValue: initialValue,
        );
      },
    );
  }

  @override
  ConsumerState<AddOrgUnitDialog> createState() => _AddOrgUnitDialogState();
}

class _AddOrgUnitDialogState extends ConsumerState<AddOrgUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  String? _selectedStatus;

  int? _selectedParentId;
  String? _selectedParentName;
  bool _isLoading = false;

  final List<String> _statusOptions = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;
    _selectedStatus = initial?.isActive == true ? 'Active' : 'Inactive';

    _controllers = {
      'orgUnitCode': TextEditingController(text: initial?.orgUnitCode ?? ''),
      'nameEn': TextEditingController(text: initial?.orgUnitNameEn ?? ''),
      'nameAr': TextEditingController(text: initial?.orgUnitNameAr ?? ''),
      'legalNameEn': TextEditingController(text: ''),
      'legalNameAr': TextEditingController(text: ''),
      'registrationNumber': TextEditingController(text: ''),
      'taxId': TextEditingController(text: ''),
      'establishedDate': TextEditingController(text: ''),
      'industry': TextEditingController(text: ''),
      'country': TextEditingController(text: ''),
      'city': TextEditingController(text: initial?.city ?? ''),
      'address': TextEditingController(text: initial?.address ?? ''),
      'poBox': TextEditingController(text: ''),
      'zipCode': TextEditingController(text: ''),
      'phone': TextEditingController(text: ''),
      'email': TextEditingController(text: ''),
      'website': TextEditingController(text: ''),
      'totalEmployees': TextEditingController(text: ''),
      'fiscalYearStart': TextEditingController(text: ''),
      'managerName': TextEditingController(text: initial?.managerName ?? ''),
      'managerEmail': TextEditingController(text: initial?.managerEmail ?? ''),
      'managerPhone': TextEditingController(text: initial?.managerPhone ?? ''),
      'location': TextEditingController(text: initial?.location ?? ''),
      'description': TextEditingController(text: initial?.description ?? ''),
    };

    _selectedParentId = initial?.parentOrgUnitId;

    // Pre-fetch parent org units when dialog opens (only if not COMPANY level)
    if (widget.levelCode.toUpperCase() != 'COMPANY') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          debugPrint(
            'AddOrgUnitDialog: Pre-fetching parent org units for structureId=${widget.structureId}, levelCode=${widget.levelCode}',
          );
          // Trigger the provider to fetch data by refreshing it
          final params = ParentOrgUnitsParams(
            structureId: widget.structureId,
            levelCode: widget.levelCode,
          );
          ref.invalidate(parentOrgUnitsProvider(params));

          // Watch the provider to get the parent name when data is loaded
          if (_selectedParentId != null) {
            ref.listen<
              AsyncValue<List<OrgStructureLevel>>
            >(parentOrgUnitsProvider(params), (previous, next) {
              if (mounted && next.hasValue && _selectedParentId != null) {
                try {
                  final parentUnit = next.value!.firstWhere(
                    (unit) => unit.orgUnitId == _selectedParentId,
                  );
                  setState(() {
                    _selectedParentName = parentUnit.orgUnitNameEn;
                  });
                } catch (e) {
                  // Parent not found in the list, keep parent ID but no name
                  debugPrint(
                    'Parent unit with ID $_selectedParentId not found in parent units list',
                  );
                }
              }
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectParent() async {
    // Don't allow parent selection for COMPANY level
    if (widget.levelCode.toUpperCase() == 'COMPANY') {
      return;
    }

    final selected = await ParentOrgUnitPickerDialog.show(
      context,
      structureId: widget.structureId,
      levelCode: widget.levelCode,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedParentId = selected.orgUnitId;
        _selectedParentName = selected.orgUnitNameEn;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isEdit = widget.initialValue != null;

      // Prepare data for API call
      final requestData = <String, dynamic>{
        'org_unit_code': _controllers['orgUnitCode']!.text.trim(),
        'org_unit_name_en': _controllers['nameEn']!.text.trim(),
        'org_unit_name_ar': _controllers['nameAr']!.text.trim(),
        // For COMPANY level, send null; for other levels, send the selected parent ID
        'parent_org_unit_id': widget.levelCode.toUpperCase() == 'COMPANY'
            ? null
            : _selectedParentId,
        'is_active': _selectedStatus == 'Active' ? 'Y' : 'N',
        'manager_name': _controllers['managerName']!.text.trim(),
        'manager_email': _controllers['managerEmail']!.text.trim(),
        'manager_phone': _controllers['managerPhone']!.text.trim(),
        'location': _controllers['location']!.text.trim(),
        'city': _controllers['city']!.text.trim(),
        'address': _controllers['address']!.text.trim(),
        'description': _controllers['description']!.text.trim(),
      };

      // Add level_code only for create, not for update
      if (!isEdit) {
        requestData['level_code'] = widget.levelCode;
      }

      // Add last_update_login for update
      if (isEdit) {
        requestData['last_update_login'] = 'SYSTEM';
      }

      debugPrint(
        'AddOrgUnitDialog: Submitting data (isEdit=$isEdit): $requestData',
      );

      if (isEdit) {
        // Call API to update org unit
        final updateUseCase = ref.read(updateOrgUnitUseCaseProvider);
        await updateUseCase.call(
          widget.structureId,
          widget.initialValue!.orgUnitId,
          requestData,
        );
      } else {
        // Call API to create org unit
        final createUseCase = ref.read(createOrgUnitUseCaseProvider);
        await createUseCase.call(widget.structureId, requestData);
      }

      if (mounted) {
        Navigator.of(context).pop();
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Org unit updated successfully'
                  : 'Org unit created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the org units list
        ref.read(orgUnitsProvider(widget.levelCode).notifier).refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create org unit: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
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
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        vertical: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 862.w,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(context, localizations, isDark, isMobile, isTablet),
              // Form content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Org Unit Code
                      _buildTextField(
                        context,
                        localizations,
                        isDark,
                        controller: _controllers['orgUnitCode']!,
                        label: 'Org Unit Code',
                        hint: 'Enter org unit code',
                        isRequired: true,
                        isMobile: isMobile,
                        isTablet: isTablet,
                        inputFormatters: [
                          AppInputFormatters.orgUnitCode,
                          AppInputFormatters.maxLen(30),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Name (English) and Name (Arabic) side by side
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              localizations,
                              isDark,
                              controller: _controllers['nameEn']!,
                              label: localizations.nameEnglish,
                              hint: 'Enter name in English',
                              isRequired: true,
                              isMobile: isMobile,
                              isTablet: isTablet,
                              inputFormatters: [
                                AppInputFormatters.nameEn,
                                AppInputFormatters.maxLen(120),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildTextField(
                              context,
                              localizations,
                              isDark,
                              controller: _controllers['nameAr']!,
                              label: localizations.nameArabic,
                              hint: 'Enter name in Arabic',
                              isRequired: true,
                              isMobile: isMobile,
                              isTablet: isTablet,
                              inputFormatters: [
                                AppInputFormatters.nameAr,
                                AppInputFormatters.maxLen(120),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Status
                      _buildStatusDropdown(
                        context,
                        localizations,
                        isDark,
                        isMobile,
                        isTablet,
                      ),
                      SizedBox(height: 24.h),
                      // Country and City
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              localizations,
                              isDark,
                              controller: _controllers['address']!,
                              label: localizations.address,
                              hint: 'Enter address',
                              isRequired: false,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildTextField(
                              context,
                              localizations,
                              isDark,
                              controller: _controllers['city']!,
                              label: localizations.city,
                              hint: 'Enter city',
                              isRequired: false,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                        ],
                      ),

                      // Address
                      SizedBox(height: 24.h),
                      // Currency and Fiscal Year Start

                      // Parent Org Unit (only show if not COMPANY level)
                      if (widget.levelCode.toUpperCase() != 'COMPANY') ...[
                        _buildParentField(
                          context,
                          localizations,
                          isDark,
                          isMobile,
                          isTablet,
                        ),
                        SizedBox(height: 24.h),
                      ],
                      // Manager Name
                      _buildTextField(
                        context,
                        localizations,
                        isDark,
                        controller: _controllers['managerName']!,
                        label: localizations.manager,
                        hint: 'Enter manager name',
                        isRequired: false,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: 24.h),
                      // Manager Email and Phone side by side
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              localizations,
                              isDark,
                              controller: _controllers['managerEmail']!,
                              label: 'Manager Email',
                              hint: 'Enter manager email',
                              isRequired: false,
                              keyboardType: TextInputType.emailAddress,
                              isMobile: isMobile,
                              isTablet: isTablet,
                              inputFormatters: [
                                AppInputFormatters.email,
                                AppInputFormatters.maxLen(150),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildTextField(
                              context,
                              localizations,
                              isDark,
                              controller: _controllers['managerPhone']!,
                              label: 'Manager Phone',
                              hint: 'Enter manager phone',
                              isRequired: false,
                              keyboardType: TextInputType.phone,
                              isMobile: isMobile,
                              isTablet: isTablet,
                              inputFormatters: [
                                AppInputFormatters.phone,
                                AppInputFormatters.maxLen(20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Location
                      _buildTextField(
                        context,
                        localizations,
                        isDark,
                        controller: _controllers['location']!,
                        label: localizations.location,
                        hint: 'Enter location',
                        isRequired: false,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: 24.h),
                      // Description
                      _buildTextField(
                        context,
                        localizations,
                        isDark,
                        controller: _controllers['description']!,
                        label: localizations.description,
                        hint: 'Enter description',
                        isRequired: false,
                        maxLines: 3,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              _buildFooter(context, localizations, isDark, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        end: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        top: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
        bottom: isMobile ? 16.h : (isTablet ? 20.h : 25.h),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.initialValue == null
                  ? 'Add New ${widget.levelCode.toTitleCase()}'
                  : 'Edit ${widget.levelCode.toTitleCase()}',
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 15.sp : 15.6.sp),
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgIconWidget(
              assetPath: 'assets/icons/close_icon_edit.svg',
              size: isMobile ? 20.sp : (isTablet ? 22.sp : 24.sp),
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isRequired,
    TextInputType? keyboardType,
    int maxLines = 1,
    required bool isMobile,
    required bool isTablet,
    List<TextInputFormatter>? inputFormatters, // ✅ add
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: TextStyle(
            fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.sp),
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 20 / 13,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: !_isLoading,
          inputFormatters: inputFormatters, // ✅ add
          style: TextStyle(
            fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textPlaceholderDark
                  : AppColors.textPlaceholder,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.cardBackgroundGreyDark
                : const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.cardBorderDark
                    : const Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.cardBorderDark
                    : const Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: isMobile ? 14.h : (isTablet ? 13.h : 12.h),
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildParentField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Parent',
          style: TextStyle(
            fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.sp),
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 20 / 13,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _isLoading ? null : _selectParent,
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: isMobile ? 14.h : (isTablet ? 13.h : 12.h),
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardBackgroundGreyDark
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark
                    ? AppColors.cardBorderDark
                    : const Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedParentName ?? 'Select parent org unit',
                    style: TextStyle(
                      fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
                      fontWeight: FontWeight.w400,
                      color: _selectedParentName != null
                          ? (isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF101828))
                          : (isDark
                                ? AppColors.textPlaceholderDark
                                : AppColors.textPlaceholder),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localizations.status} *',
          style: TextStyle(
            fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.sp),
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 20 / 13,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: isMobile ? 14.h : (isTablet ? 13.h : 12.h),
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cardBackgroundGreyDark
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark
                  ? AppColors.cardBorderDark
                  : const Color(0xFFD1D5DB),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              isDense: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
              ),
              style: TextStyle(
                fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
              ),
              items: _statusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _isLoading
                  ? null
                  : (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.all(24.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              localizations.cancel,
              style: TextStyle(
                fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    localizations.saveChanges,
                    style: TextStyle(
                      fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
