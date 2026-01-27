import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_policies_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditLeavePolicyDialog extends ConsumerStatefulWidget {
  final LeavePolicy policy;

  const EditLeavePolicyDialog({super.key, required this.policy});

  static Future<void> show(BuildContext context, LeavePolicy policy) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => EditLeavePolicyDialog(policy: policy),
    );
  }

  @override
  ConsumerState<EditLeavePolicyDialog> createState() => _EditLeavePolicyDialogState();
}

class _EditLeavePolicyDialogState extends ConsumerState<EditLeavePolicyDialog> {
  late final TextEditingController _leaveTypeEnController;
  late final TextEditingController _entitlementController;

  late String? _selectedAccrualType;
  late String? _selectedStatus;
  late bool _isKuwaitLawCompliant;
  bool _isSubmitting = false;

  static const List<String> _accrualTypes = ['Yearly Allocation', 'Monthly Allocation', 'None'];
  static const List<String> _accrualCodes = ['YEARLY', 'MONTHLY', 'NONE'];
  static const List<String> _statusOptions = ['ACTIVE', 'INACTIVE'];

  @override
  void initState() {
    super.initState();
    final p = widget.policy;
    _leaveTypeEnController = TextEditingController(text: p.nameEn);
    _entitlementController = TextEditingController(
      text: '${p.entitlementDays ?? _parseEntitlementDays(p.entitlement)}',
    );
    _selectedAccrualType = _accrualTypeFromCode(p.accrualMethodCode) ?? 'Yearly Allocation';
    _selectedStatus = p.status ?? 'ACTIVE';
    _isKuwaitLawCompliant = (p.kuwaitLaborCompliant ?? (p.isKuwaitLaw ? 'Y' : 'N')).toUpperCase() == 'Y';
  }

  int _parseEntitlementDays(String s) {
    final m = RegExp(r'\d+').firstMatch(s);
    return m != null ? int.tryParse(m.group(0) ?? '0') ?? 0 : 0;
  }

  String? _accrualTypeFromCode(String? code) {
    if (code == null) return null;
    final i = _accrualCodes.indexOf(code.toUpperCase());
    return i >= 0 ? _accrualTypes[i] : null;
  }

  String _accrualCodeFromType(String type) {
    final i = _accrualTypes.indexOf(type);
    return i >= 0 ? _accrualCodes[i] : 'NONE';
  }

  @override
  void dispose() {
    _leaveTypeEnController.dispose();
    _entitlementController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final guid = widget.policy.policyGuid;
    if (guid == null || guid.isEmpty) return;

    final leaveTypeEn = _leaveTypeEnController.text.trim();
    if (leaveTypeEn.isEmpty) {
      ToastService.warning(context, 'Leave type (English) is required');
      return;
    }

    final entitlementDays = int.tryParse(_entitlementController.text.trim());
    if (entitlementDays == null || entitlementDays < 0) {
      ToastService.warning(context, 'Enter a valid entitlement (days)');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final notifier = ref.read(leavePoliciesNotifierProvider.notifier);
      await notifier.updateLeavePolicy(
        guid,
        UpdateLeavePolicyParams(
          leaveTypeEn: leaveTypeEn,
          entitlementDays: entitlementDays,
          accrualMethodCode: _accrualCodeFromType(_selectedAccrualType!),
          status: _selectedStatus!,
          kuwaitLaborCompliant: _isKuwaitLawCompliant ? 'Y' : 'N',
        ),
      );
      if (!mounted) return;
      ToastService.success(context, 'Leave policy updated successfully');
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
      title: 'Edit Leave Policy',
      width: 900.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBasicInformationSection(context, isDark, isMobile),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildAccrualSettingsSection(context, isDark),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildStatusAndComplianceSection(context, isDark),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: _isSubmitting ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: 'Save Changes',
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
                labelText: 'Leave type (English)',
                hintText: 'e.g., Annual Leave',
                controller: _leaveTypeEnController,
                isRequired: true,
              ),
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
            spacing: 16.w,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Leave type (English)',
                  hintText: 'e.g., Annual Leave',
                  controller: _leaveTypeEnController,
                  isRequired: true,
                ),
              ),
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

  Widget _buildStatusAndComplianceSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status & compliance',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        Gap(16.h),
        DigifySelectFieldWithLabel<String>(
          label: 'Status',
          items: _statusOptions,
          itemLabelBuilder: (item) => item == 'ACTIVE' ? 'Active' : 'Inactive',
          value: _selectedStatus,
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
        Gap(16.h),
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
