import 'dart:ui' as ui;
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_policies_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddLeavePolicyDialog extends ConsumerStatefulWidget {
  const AddLeavePolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const AddLeavePolicyDialog(),
    );
  }

  @override
  ConsumerState<AddLeavePolicyDialog> createState() => _AddLeavePolicyDialogState();
}

class _AddLeavePolicyDialogState extends ConsumerState<AddLeavePolicyDialog> {
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _entitlementController;
  late final TextEditingController _minServiceController;
  late final TextEditingController _advanceNoticeController;
  late final TextEditingController _maxConsecutiveDaysController;

  String? _selectedPolicyType;
  String? _selectedAccrualType;
  String? _selectedGender;
  String? _selectedNationality;
  bool _allowCarryover = false;
  bool _requiresManagerApproval = true;
  bool _isPaidLeave = true;
  bool _requiresAttachment = false;
  bool _isKuwaitLawCompliant = false;
  bool _isSubmitting = false;

  final List<String> _policyTypes = ['Kuwait Law', 'Custom'];
  final List<String> _accrualTypes = ['Yearly Allocation', 'Monthly Allocation', 'None'];
  final List<String> _genderOptions = ['All', 'Male', 'Female'];
  final List<String> _nationalityOptions = ['All', 'Kuwaiti', 'Non-Kuwaiti'];

  static const List<String> _accrualCodes = ['YEARLY', 'MONTHLY', 'NONE'];

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController();
    _nameArController = TextEditingController();
    _descriptionController = TextEditingController();
    _entitlementController = TextEditingController(text: '0');
    _minServiceController = TextEditingController(text: '0');
    _advanceNoticeController = TextEditingController(text: '0');
    _maxConsecutiveDaysController = TextEditingController(text: 'No limit');
    _selectedPolicyType = 'Custom';
    _selectedAccrualType = 'Yearly Allocation';
    _selectedGender = 'All';
    _selectedNationality = 'All';
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _entitlementController.dispose();
    _minServiceController.dispose();
    _advanceNoticeController.dispose();
    _maxConsecutiveDaysController.dispose();
    super.dispose();
  }

  String _accrualCodeFromType(String type) {
    final i = _accrualTypes.indexOf(type);
    return i >= 0 ? _accrualCodes[i] : 'NONE';
  }

  Future<void> _submit() async {
    final leaveTypeEn = _nameEnController.text.trim();
    if (leaveTypeEn.isEmpty) {
      ToastService.warning(context, 'Policy Name (English) is required');
      return;
    }
    final leaveTypeAr = _nameArController.text.trim();
    if (leaveTypeAr.isEmpty) {
      ToastService.warning(context, 'Policy Name (Arabic) is required');
      return;
    }
    final entitlementDays = int.tryParse(_entitlementController.text.trim());
    if (entitlementDays == null || entitlementDays < 0) {
      ToastService.warning(context, 'Enter a valid Entitlement (days)');
      return;
    }

    final tenantId = ref.read(leaveManagementEnterpriseIdProvider);
    if (tenantId == null) {
      ToastService.warning(context, 'Select an enterprise first');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final params = CreateLeavePolicyParams(
        tenantId: tenantId,
        leaveTypeId: 0,
        leaveTypeEn: leaveTypeEn,
        leaveTypeAr: leaveTypeAr,
        entitlementDays: entitlementDays,
        accrualMethodCode: _accrualCodeFromType(_selectedAccrualType ?? 'Yearly Allocation'),
        status: 'ACTIVE',
        kuwaitLaborCompliant: _selectedPolicyType == 'Kuwait Law' ? 'Y' : 'N',
      );
      await ref.read(leavePoliciesNotifierProvider.notifier).createLeavePolicy(params);
      if (!mounted) return;
      ToastService.success(context, 'Leave policy created successfully');
      context.pop();
    } on Exception catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;

    return AppDialog(
      title: 'Add Leave Policy',
      width: 900.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBasicInformationSection(context, isDark, isMobile),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildAccrualSettingsSection(context, isDark),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildCarryoverRulesSection(context, isDark),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildEligibilityCriteriaSection(context, isDark, isMobile),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildRequestSettingsSection(context, isDark, isMobile),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: _isSubmitting ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: 'Save Policy',
          svgPath: Assets.icons.saveIcon.path,
          onPressed: _isSubmitting ? null : _submit,
          isLoading: _isSubmitting,
        ),
      ],
    );
  }

  Widget _buildBasicInformationSection(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      spacing: 14.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        if (isMobile)
          Column(
            spacing: 14.h,
            children: [
              DigifyTextField(
                labelText: 'Policy Name (English)',
                hintText: 'e.g., Annual Leave',
                controller: _nameEnController,
                isRequired: true,
              ),
              DigifyTextField(
                labelText: 'Policy Name (Arabic)',
                hintText: 'مثال: إجازة سنوية',
                controller: _nameArController,
                isRequired: true,
                textDirection: ui.TextDirection.rtl,
                inputFormatters: [AppInputFormatters.nameAr],
              ),
            ],
          )
        else
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Policy Name (English)',
                  hintText: 'e.g., Annual Leave',
                  controller: _nameEnController,
                  isRequired: true,
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  labelText: 'Policy Name (Arabic)',
                  hintText: 'مثال: إجازة سنوية',
                  controller: _nameArController,
                  isRequired: true,
                  textDirection: ui.TextDirection.rtl,
                  inputFormatters: [AppInputFormatters.nameAr],
                ),
              ),
            ],
          ),
        DigifyTextArea(
          labelText: 'Description',
          hintText: 'Enter a brief description of the leave policy',
          controller: _descriptionController,
          maxLines: 3,
        ),
        if (isMobile)
          Column(
            children: [
              DigifySelectFieldWithLabel<String>(
                label: 'Policy Type',
                items: _policyTypes,
                itemLabelBuilder: (item) => item,
                value: _selectedPolicyType,
                onChanged: (value) => setState(() => _selectedPolicyType = value),
                isRequired: true,
              ),
              Gap(16.h),
              DigifyTextField.number(
                controller: _entitlementController,
                labelText: 'Entitlement (days)',
                hintText: 'e.g., 30',
                isRequired: true,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Policy Type',
                  items: _policyTypes,
                  itemLabelBuilder: (item) => item,
                  value: _selectedPolicyType,
                  onChanged: (value) => setState(() => _selectedPolicyType = value),
                  isRequired: true,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField.number(
                  controller: _entitlementController,
                  labelText: 'Entitlement (days)',
                  hintText: 'e.g., 30',
                  isRequired: true,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAccrualSettingsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accrual Settings',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        Gap(16.h),
        DigifySelectFieldWithLabel<String>(
          label: 'Accrual Type',
          items: _accrualTypes,
          itemLabelBuilder: (item) => item,
          value: _selectedAccrualType,
          onChanged: (value) => setState(() => _selectedAccrualType = value),
        ),
      ],
    );
  }

  Widget _buildCarryoverRulesSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Carryover Rules',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        Gap(16.h),
        DigifyCheckbox(
          value: _allowCarryover,
          onChanged: (value) => setState(() => _allowCarryover = value ?? false),
          label: 'Allow carryover to next year',
        ),
      ],
    );
  }

  Widget _buildEligibilityCriteriaSection(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eligibility Criteria',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        Gap(16.h),
        if (isMobile)
          Column(
            children: [
              DigifySelectFieldWithLabel<String>(
                label: 'Gender',
                items: _genderOptions,
                itemLabelBuilder: (item) => item,
                value: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              Gap(16.h),
              DigifySelectFieldWithLabel<String>(
                label: 'Nationality',
                items: _nationalityOptions,
                itemLabelBuilder: (item) => item,
                value: _selectedNationality,
                onChanged: (value) => setState(() => _selectedNationality = value),
              ),
              Gap(16.h),
              DigifyTextField.number(
                controller: _minServiceController,
                labelText: 'Min Service (months)',
                hintText: 'e.g., 6',
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Gender',
                  items: _genderOptions,
                  itemLabelBuilder: (item) => item,
                  value: _selectedGender,
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Nationality',
                  items: _nationalityOptions,
                  itemLabelBuilder: (item) => item,
                  value: _selectedNationality,
                  onChanged: (value) => setState(() => _selectedNationality = value),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField.number(
                  controller: _minServiceController,
                  labelText: 'Min Service (months)',
                  hintText: 'e.g., 6',
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRequestSettingsSection(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Request Settings',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        Gap(16.h),
        if (isMobile)
          Column(
            children: [
              DigifyTextField.number(
                controller: _advanceNoticeController,
                labelText: 'Advance Notice (days)',
                hintText: 'e.g., 7',
              ),
              Gap(16.h),
              DigifyTextField(
                labelText: 'Max Consecutive Days',
                hintText: 'e.g., 14 or No limit',
                controller: _maxConsecutiveDaysController,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: DigifyTextField.number(
                  controller: _advanceNoticeController,
                  labelText: 'Advance Notice (days)',
                  hintText: 'e.g., 7',
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  labelText: 'Max Consecutive Days',
                  hintText: 'e.g., 14 or No limit',
                  controller: _maxConsecutiveDaysController,
                ),
              ),
            ],
          ),
        Gap(16.h),
        DigifyCheckbox(
          value: _requiresManagerApproval,
          onChanged: (value) => setState(() => _requiresManagerApproval = value ?? false),
          label: 'Requires manager approval',
        ),
        Gap(8.h),
        DigifyCheckbox(
          value: _isPaidLeave,
          onChanged: (value) => setState(() => _isPaidLeave = value ?? false),
          label: 'Paid leave',
        ),
        Gap(8.h),
        DigifyCheckbox(
          value: _requiresAttachment,
          onChanged: (value) => setState(() => _requiresAttachment = value ?? false),
          label: 'Attachment/document required',
        ),
        Gap(8.h),
        DigifyCheckbox(
          value: _isKuwaitLawCompliant,
          onChanged: (value) => setState(() => _isKuwaitLawCompliant = value ?? false),
          label: 'Kuwait Labor Law compliant',
          activeColor: AppColors.success,
        ),
      ],
    );
  }
}
