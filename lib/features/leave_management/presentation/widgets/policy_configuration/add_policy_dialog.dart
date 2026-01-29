import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/abs_policies_dto.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/api_leave_type.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_detail.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/advanced_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/carry_forward_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_criteria_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/encashment_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/forfeit_rules_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/grade_based_entitlements_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

const String _kCreatedBy = 'ADMIN';

class AddPolicyDialog extends ConsumerStatefulWidget {
  const AddPolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const AddPolicyDialog(),
    );
  }

  @override
  ConsumerState<AddPolicyDialog> createState() => _AddPolicyDialogState();
}

class _AddPolicyDialogState extends ConsumerState<AddPolicyDialog> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(policyDraftProvider.notifier).setDraft(PolicyDetail.empty());
      ref.read(leaveTypesNotifierProvider.notifier).loadLeaveTypes();
    });
  }

  @override
  void dispose() {
    ref.read(policyDraftProvider.notifier).clear();
    super.dispose();
  }

  Future<void> _onCreate() async {
    final tenantId = ref.read(leaveManagementEnterpriseIdProvider);
    final draft = ref.read(policyDraftProvider);

    if (tenantId == null) {
      ToastService.warning(context, 'Select an enterprise first');
      return;
    }
    if (draft == null) {
      ToastService.error(context, 'Form data is missing');
      return;
    }
    final policyName = (draft.policyName ?? draft.leaveTypeEn).trim();
    if (policyName.isEmpty) {
      ToastService.warning(context, 'Enter policy name');
      return;
    }
    if (draft.leaveTypeId == 0) {
      ToastService.warning(context, 'Select a leave type');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(absPoliciesRepositoryProvider);
      final request = CreatePolicyRequestDto.fromDetail(draft, tenantId: tenantId, createdBy: _kCreatedBy);
      final created = await repo.createPolicy(request);
      if (!mounted) return;
      if (created != null) {
        ref.read(absPoliciesNotifierProvider.notifier).addPolicy(created);
        ref.read(selectedPolicyGuidProvider.notifier).setSelectedPolicyGuid(created.policyGuid);
        ToastService.success(context, 'Policy created successfully');
        Navigator.of(context).pop();
      } else {
        ToastService.error(context, 'Failed to create policy');
      }
    } catch (_) {
      if (mounted) ToastService.error(context, 'Failed to create policy');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AppDialog(
      title: localizations.addNewPolicy,
      subtitle: localizations.policyConfigurationDescription,
      width: 850.w,
      content: const _AddPolicyDialogContent(),
      onClose: () => Navigator.of(context).pop(),
      actions: [
        AppButton.outline(
          label: localizations.cancel,
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
        ),
        Gap(12.w),
        AppButton.primary(
          label: localizations.createNewPolicy,
          onPressed: _isSubmitting ? null : _onCreate,
          isLoading: _isSubmitting,
        ),
      ],
    );
  }
}

class _AddPolicyDialogContent extends ConsumerWidget {
  const _AddPolicyDialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final draft = ref.watch(policyDraftProvider);
    final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    if (draft == null) {
      return const SizedBox.shrink();
    }

    final leaveTypes = leaveTypesState.leaveTypes;
    final selectedLeaveType = draft.leaveTypeId > 0
        ? leaveTypes.where((t) => t.id == draft.leaveTypeId).firstOrNull
        : null;

    final config = draft.toConfiguration();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        _BasicInfoSection(
          policyName: draft.policyName ?? '',
          selectedLeaveType: selectedLeaveType,
          leaveTypes: leaveTypes,
          onPolicyNameChanged: draftNotifier.updatePolicyName,
          onLeaveTypeChanged: (t) {
            if (t != null) draftNotifier.updateLeaveType(t.id, t.nameEn, t.nameAr);
          },
        ),
        EligibilityCriteriaSection(isDark: isDark, eligibility: config.eligibilityCriteria, isEditing: true),
        GradeBasedEntitlementsSection(
          isDark: isDark,
          gradeRows: draft.gradeRows,
          effectiveDate: draft.formattedCreatedDate,
          enableProRata: draft.enableProRata,
          accrualMethodCode: draft.accrualMethod.code,
          isEditing: true,
        ),
        AdvancedRulesSection(isDark: isDark, advanced: config.advancedRules, isEditing: true),
        CarryForwardRulesSection(isDark: isDark, carryForward: config.carryForwardRules, isEditing: true),
        ForfeitRulesSection(
          isDark: isDark,
          forfeit: config.forfeitRules,
          carryForwardLimit: config.carryForwardRules.carryForwardLimit,
          gracePeriod: config.carryForwardRules.gracePeriod,
          isEditing: true,
        ),
        EncashmentRulesSection(isDark: isDark, encashment: config.encashmentRules, isEditing: true),
      ],
    );
  }
}

class _BasicInfoSection extends StatelessWidget {
  final String policyName;
  final ApiLeaveType? selectedLeaveType;
  final List<ApiLeaveType> leaveTypes;
  final ValueChanged<String?> onPolicyNameChanged;
  final ValueChanged<ApiLeaveType?> onLeaveTypeChanged;

  const _BasicInfoSection({
    required this.policyName,
    required this.selectedLeaveType,
    required this.leaveTypes,
    required this.onPolicyNameChanged,
    required this.onLeaveTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.h,
      children: [
        DigifyTextField(
          labelText: 'Policy name',
          initialValue: policyName,
          hintText: 'Enter policy name',
          onChanged: (v) => onPolicyNameChanged(v.isEmpty ? null : v),
        ),
        DigifySelectFieldWithLabel<ApiLeaveType>(
          label: 'Leave type',
          hint: 'Select leave type',
          items: leaveTypes,
          value: selectedLeaveType,
          itemLabelBuilder: (t) => t.nameEn,
          onChanged: onLeaveTypeChanged,
          isRequired: true,
        ),
      ],
    );
  }
}
