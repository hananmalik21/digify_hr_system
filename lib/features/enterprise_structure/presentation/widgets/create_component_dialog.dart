import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_form_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/location_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

/// Create/Edit Component Dialog
class CreateComponentDialog extends ConsumerStatefulWidget {
  final ComponentValue? initialValue;
  final ComponentType? defaultType;

  const CreateComponentDialog({super.key, this.initialValue, this.defaultType});

  static Future<void> show(BuildContext context, {ComponentValue? initialValue, ComponentType? defaultType}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        overrides: [
          componentFormProvider.overrideWith(
            (ref) => ComponentFormNotifier(initialValue: initialValue, defaultType: defaultType),
          ),
        ],
        child: CreateComponentDialog(initialValue: initialValue, defaultType: defaultType),
      ),
    );
  }

  @override
  ConsumerState<CreateComponentDialog> createState() => _CreateComponentDialogState();
}

class _CreateComponentDialogState extends ConsumerState<CreateComponentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _arabicNameController;
  late final TextEditingController _managerCodeController;
  late final TextEditingController _managerNameController;
  late final TextEditingController _costCenterController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;
    _codeController = TextEditingController(text: initial?.code ?? '');
    _nameController = TextEditingController(text: initial?.name ?? '');
    _arabicNameController = TextEditingController(text: initial?.arabicName ?? '');
    _managerCodeController = TextEditingController(text: 'EMP-001');
    _managerNameController = TextEditingController(text: 'Abdullah Al-Sabah');
    _costCenterController = TextEditingController(text: 'CC-0000');
    _locationController = TextEditingController(text: initial?.location ?? '');
    _descriptionController = TextEditingController(text: initial?.description ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _arabicNameController.dispose();
    _managerCodeController.dispose();
    _managerNameController.dispose();
    _costCenterController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(componentFormProvider);
    final notifier = ref.read(componentFormProvider.notifier);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Build title
    final title = widget.initialValue == null
        ? localizations.createComponent
        : '${localizations.editComponent} - ${state.name.isNotEmpty ? state.name : widget.initialValue?.name ?? ''}';

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
          vertical: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: 862.w, maxHeight: MediaQuery.of(context).size.height * 0.95),
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
                _buildHeader(context, localizations, isDark, isMobile, isTablet, title),
                // Form content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Component Type
                        _buildTypeDropdown(context, localizations, isDark, state, notifier, isMobile, isTablet),
                        SizedBox(height: 24.h),
                        // Component Code
                        _buildComponentCodeField(context, localizations, isDark, state, notifier, isMobile, isTablet),
                        SizedBox(height: 24.h),
                        // Name (English) and Name (Arabic) side by side
                        _buildNameFields(context, localizations, isDark, state, notifier, isMobile, isTablet),
                        SizedBox(height: 24.h),
                        // Parent Component
                        _buildParentDropdown(context, localizations, isDark, state, notifier, isMobile, isTablet),
                        SizedBox(height: 24.h),
                        // Manager (Code and Name side by side)
                        _buildManagerFields(context, localizations, isDark, isMobile, isTablet),
                        SizedBox(height: 24.h),
                        // Cost Center and Location side by side
                        _buildCostCenterLocationFields(
                          context,
                          localizations,
                          isDark,
                          state,
                          notifier,
                          isMobile,
                          isTablet,
                        ),
                        SizedBox(height: 24.h),
                        // Status radio buttons
                        _buildStatusRadioButtons(context, localizations, isDark, state, notifier, isMobile, isTablet),
                        SizedBox(height: 24.h),
                        // Description
                        _buildDescriptionField(context, localizations, isDark, state, notifier, isMobile, isTablet),
                      ],
                    ),
                  ),
                ),
                // Footer
                _buildFooter(context, localizations, isDark, state, notifier, isMobile, isTablet),
              ],
            ),
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
    String title,
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
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 15.sp : 15.6.sp),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: DigifyAsset(
              assetPath: Assets.icons.closeIconEdit.path,
              width: isMobile ? 20 : (isTablet ? 22 : 24),
              height: isMobile ? 20 : (isTablet ? 22 : 24),
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    final types = [
      ComponentType.company,
      ComponentType.division,
      ComponentType.businessUnit,
      ComponentType.department,
      ComponentType.section,
    ];

    String getTypeLabel(ComponentType type) {
      switch (type) {
        case ComponentType.company:
          return localizations.company;
        case ComponentType.division:
          return localizations.division;
        case ComponentType.businessUnit:
          return localizations.businessUnit;
        case ComponentType.department:
          return localizations.department;
        case ComponentType.section:
          return localizations.section;
      }
    }

    final isEditMode = widget.initialValue != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifySelectFieldWithLabel<ComponentType>(
          label: localizations.componentType,
          hint: localizations.selectComponentTypePlaceholder,
          value: state.type ?? widget.defaultType,
          items: types,
          itemLabelBuilder: getTypeLabel,
          onChanged: isEditMode
              ? null
              : (value) {
                  if (value != null) {
                    notifier.updateField('type', value);
                  }
                },
          isRequired: true,
        ),
        if (isEditMode) ...[
          SizedBox(height: 8.h),
          Text(
            'Component type cannot be changed after creation',
            style: TextStyle(
              fontSize: isMobile ? 11.sp : (isTablet ? 11.5.sp : 11.8.sp),
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
              height: 16 / 11.8,
              letterSpacing: 0,
            ),
          ),
        ],
        if (state.errors.containsKey('type'))
          Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(
              state.errors['type']!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
            ),
          ),
      ],
    );
  }

  Widget _buildParentDropdown(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    // TODO: Replace with actual parent components list when available
    final parentOptions = <String?>[null];
    
    return DigifySelectFieldWithLabel<String?>(
      label: localizations.parentComponent,
      hint: localizations.selectParentComponent,
      value: state.parentId,
      items: parentOptions,
      itemLabelBuilder: (item) => item == null ? 'No Parent (Root Level)' : item,
      onChanged: (value) {
        notifier.updateField('parentId', value);
      },
      isRequired: false,
    );
  }

  Widget _buildManagerFields(
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
          localizations.manager,
          style: TextStyle(
            fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.7.sp),
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 20 / 13.7,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : Colors.white,
                  border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _managerCodeController,
                  style: TextStyle(
                    fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.6.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                    height: 24 / 15.6,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : Colors.white,
                  border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _managerNameController,
                  style: TextStyle(
                    fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.4.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                    height: 24 / 15.4,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRadioButtons(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: localizations.status,
            style: TextStyle(
              fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.6.sp),
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: 20 / 13.6,
              letterSpacing: 0,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildRadioButton(
              context,
              localizations.active,
              true,
              state.status == true,
              () => notifier.updateField('status', true),
              isDark,
              isMobile,
              isTablet,
              localizations,
            ),
            SizedBox(width: 24.w),
            _buildRadioButton(
              context,
              localizations.inactive,
              false,
              state.status == false,
              () => notifier.updateField('status', false),
              isDark,
              isMobile,
              isTablet,
              localizations,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(
    BuildContext context,
    String label,
    bool value,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
    bool isMobile,
    bool isTablet,
    AppLocalizations localizations,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
            height: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0075FF)
                    : (isDark ? AppColors.inputBorderDark : const Color(0xFF767676)),
                width: 1,
              ),
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: isMobile ? 8.sp : (isTablet ? 8.5.sp : 9.6.sp),
                      height: isMobile ? 8.sp : (isTablet ? 8.5.sp : 9.6.sp),
                      decoration: BoxDecoration(color: const Color(0xFF0075FF), shape: BoxShape.circle),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : (label == localizations.active ? 13.5.sp : 13.6.sp)),
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: label == localizations.active ? (20 / 13.5) : (20 / 13.6),
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentCodeField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: localizations.componentCode,
            style: TextStyle(
              fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.6.sp),
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: 20 / 13.6,
              letterSpacing: 0,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : Colors.white,
            border: Border.all(
              color: state.errors.containsKey('code')
                  ? AppColors.error
                  : (isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC)),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextField(
            controller: _codeController,
            onChanged: (value) => notifier.updateField('code', value),
            style: TextStyle(
              fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.6.sp),
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
              height: 24 / 15.6,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: localizations.enterComponentCode,
              hintStyle: TextStyle(
                fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.6.sp),
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        if (state.errors.containsKey('code'))
          Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(
              state.errors['code']!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
            ),
          ),
      ],
    );
  }

  Widget _buildNameFields(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: localizations.nameEnglish,
                  style: TextStyle(
                    fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.8.sp),
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                    height: 20 / 13.8,
                    letterSpacing: 0,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : Colors.white,
                  border: Border.all(
                    color: state.errors.containsKey('name')
                        ? AppColors.error
                        : (isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC)),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _nameController,
                  onChanged: (value) => notifier.updateField('name', value),
                  style: TextStyle(
                    fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.3.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                    height: 24 / 15.3,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: localizations.enterComponentName,
                    hintStyle: TextStyle(
                      fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.3.sp),
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      height: 24 / 15.3,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: localizations.nameArabic,
                  style: TextStyle(
                    fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.7.sp),
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                    height: 20 / 13.7,
                    letterSpacing: 0,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : Colors.white,
                  border: Border.all(
                    color: state.errors.containsKey('arabicName')
                        ? AppColors.error
                        : (isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC)),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _arabicNameController,
                  onChanged: (value) => notifier.updateField('arabicName', value),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: isMobile ? 15.sp : (isTablet ? 15.5.sp : 16.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                    height: 24 / 16,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: localizations.enterArabicName,
                    hintStyle: TextStyle(
                      fontSize: isMobile ? 15.sp : (isTablet ? 15.5.sp : 16.sp),
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      height: 24 / 16,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostCenterLocationFields(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.costCenter,
                style: TextStyle(
                  fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.7.sp),
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 20 / 13.7,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : Colors.white,
                  border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _costCenterController,
                  style: TextStyle(
                    fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.5.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                    height: 24 / 15.5,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: localizations.costCenter,
                    hintStyle: TextStyle(
                      fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.5.sp),
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      height: 24 / 15.5,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.location,
                style: TextStyle(
                  fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.7.sp),
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 20 / 13.7,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : Colors.white,
                  border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _locationController,
                  readOnly: true,
                  onTap: () async {
                    final location = await LocationPickerDialog.show(
                      context,
                      departmentName: state.name,
                      location: _locationController.text,
                    );
                    if (location != null) {
                      _locationController.text = location;
                      notifier.updateField('location', location);
                    }
                  },
                  style: TextStyle(
                    fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.1.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                    height: 24 / 15.1,
                    letterSpacing: 0,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: localizations.enterLocation,
                    hintStyle: TextStyle(
                      fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.1.sp),
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      height: 24 / 15.1,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: isMobile ? 4.h : (isTablet ? 5.h : 6.h)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.description,
            style: TextStyle(
              fontSize: isMobile ? 12.5.sp : (isTablet ? 13.3.sp : 13.8.sp),
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsetsDirectional.only(
              start: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
              end: isMobile ? 12.w : (isTablet ? 15.w : 17.w),
              top: 9.h,
              bottom: isMobile ? 40.h : (isTablet ? 50.h : 57.h),
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : Colors.white,
              border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              controller: _descriptionController,
              onChanged: (value) => notifier.updateField('description', value),
              maxLines: null,
              style: TextStyle(
                fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.3.sp),
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                height: 24 / 15.3,
                letterSpacing: 0,
              ),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: localizations.enterDescription,
                hintStyle: TextStyle(
                  fontSize: isMobile ? 14.5.sp : (isTablet ? 15.sp : 15.3.sp),
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                  height: 24 / 15.3,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentFormState state,
    ComponentFormNotifier notifier,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        end: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        top: 17.h,
        bottom: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Cancel button
          Material(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 25.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  localizations.cancel,
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                    height: 24 / 15.3,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Save Changes button
          Material(
            color: const Color(0xFF155DFC),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: state.isLoading
                  ? null
                  : () async {
                      if (await notifier.submit()) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(color: const Color(0xFF155DFC), borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.isLoading)
                      SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: const AppLoadingIndicator(
                          type: LoadingType.fadingCircle,
                          size: 20,
                          color: Colors.white,
                        ),
                      )
                    else
                      DigifyAsset(assetPath: Assets.icons.saveIcon.path, width: 20, height: 20, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      localizations.saveChanges,
                      style: TextStyle(
                        fontSize: 15.1.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 24 / 15.1,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
