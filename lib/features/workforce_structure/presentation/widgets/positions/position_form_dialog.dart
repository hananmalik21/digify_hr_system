import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/employee.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/position_form_sections.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionFormDialog extends ConsumerStatefulWidget {
  final Position initialPosition;
  final bool isEdit;

  const PositionFormDialog({super.key, required this.initialPosition, required this.isEdit});

  static void show(BuildContext context, {required Position position, required bool isEdit}) {
    showDialog(
      context: context,
      builder: (context) => PositionFormDialog(initialPosition: position, isEdit: isEdit),
    );
  }

  @override
  ConsumerState<PositionFormDialog> createState() => _PositionFormDialogState();
}

class _PositionFormDialogState extends ConsumerState<PositionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final Map<String, TextEditingController> _formControllers;
  late final Map<String, String?> _selectedUnitIds;
  bool _isSaving = false;
  Employee? _selectedReportsToEmployee;

  @override
  void initState() {
    super.initState();
    final position = widget.initialPosition;

    _selectedUnitIds = Map<String, String?>.from(position.orgPathIds ?? {});
    _formControllers = {
      'code': TextEditingController(text: position.code),
      'titleEnglish': TextEditingController(text: position.titleEnglish),
      'titleArabic': TextEditingController(text: position.titleArabic),
      'costCenter': TextEditingController(text: position.costCenter),
      'location': TextEditingController(text: position.location),
      'positions': TextEditingController(text: position.headcount.toString()),
      'filled': TextEditingController(text: position.filled.toString()),
      'budgetedMin': TextEditingController(text: position.budgetedMin),
      'budgetedMax': TextEditingController(text: position.budgetedMax),
      'actualAverage': TextEditingController(text: position.actualAverage),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(positionFormNotifierProvider.notifier)
          .initialize(
            employmentType: 'FULL_TIME',
            isActive: position.isActive,
            step: position.step.isEmpty ? null : position.step,
            jobFamily: position.jobFamilyRef,
            jobLevel: position.jobLevelRef,
            grade: position.gradeRef,
          );
    });
  }

  @override
  void dispose() {
    for (var controller in _formControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleEnterpriseSelection(String levelCode, String? unitId) {
    setState(() {
      _selectedUnitIds[levelCode] = unitId;
    });
  }

  bool _hasOrgUnitSelected() {
    final orgStructureState = ref.read(orgStructureNotifierProvider);
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];
    for (final level in levels) {
      if (_selectedUnitIds[level.levelCode] != null) return true;
    }
    return false;
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final localizations = AppLocalizations.of(context)!;
    final validationError = ref
        .read(positionFormNotifierProvider.notifier)
        .validateForm(
          positionCode: _formControllers['code']!.text,
          titleEnglish: _formControllers['titleEnglish']!.text,
          titleArabic: _formControllers['titleArabic']!.text,
          costCenter: _formControllers['costCenter']!.text,
          location: _formControllers['location']!.text,
          numberOfPositionsStr: _formControllers['positions']!.text,
          filledPositionsStr: _formControllers['filled']!.text,
          budgetedMinStr: _formControllers['budgetedMin']!.text,
          budgetedMaxStr: _formControllers['budgetedMax']!.text,
          actualAverageStr: _formControllers['actualAverage']!.text,
          hasOrgUnitSelected: _hasOrgUnitSelected(),
          hasReportsToEmployeeSelected: _selectedReportsToEmployee != null,
          isEdit: widget.isEdit,
          l: localizations,
        );
    if (validationError != null) {
      ToastService.error(context, validationError, title: localizations.fieldRequired);
      return;
    }

    final formState = ref.read(positionFormNotifierProvider);
    final orgStructureState = ref.read(orgStructureNotifierProvider);

    // Get the deepest selected org unit
    String? lastUnitId;
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];
    for (final level in levels) {
      final id = _selectedUnitIds[level.levelCode];
      if (id != null) {
        lastUnitId = id;
      }
    }

    final payload = {
      if (!widget.isEdit) "position_code": _formControllers['code']!.text,
      "position_title_en": _formControllers['titleEnglish']!.text,
      "position_title_ar": _formControllers['titleArabic']!.text,
      "status": formState.isActive ? "ACTIVE" : "INACTIVE",
      "org_structure_id": orgStructureState.orgStructure?.structureId,
      "org_unit_id": lastUnitId,
      "cost_center": _formControllers['costCenter']!.text,
      "location": _formControllers['location']!.text,
      "job_family_id": formState.jobFamily!.id,
      "job_level_id": formState.jobLevel!.id,
      "grade_id": formState.grade!.id,
      "number_of_positions": int.tryParse(_formControllers['positions']!.text) ?? 0,
      "filled_positions": int.tryParse(_formControllers['filled']!.text) ?? 0,
      "employment_type": formState.employmentType,
      "budgeted_min_kd": double.tryParse(_formControllers['budgetedMin']!.text) ?? 0.0,
      "budgeted_max_kd": double.tryParse(_formControllers['budgetedMax']!.text) ?? 0.0,
      "actual_avg_kd": double.tryParse(_formControllers['actualAverage']!.text) ?? 0.0,
      "last_update_login": "HR_ADMIN",
      if (_selectedReportsToEmployee != null) "reports_to_user_guid": _selectedReportsToEmployee!.guid,
    };

    setState(() => _isSaving = true);

    try {
      if (widget.isEdit) {
        await ref.read(positionNotifierProvider.notifier).updatePosition(widget.initialPosition.id, payload);
      } else {
        await ref.read(positionNotifierProvider.notifier).createPosition(payload);
      }

      if (mounted) {
        context.pop();
        ToastService.success(
          context,
          widget.isEdit ? 'Position updated successfully' : 'Position created successfully',
          title: 'Success',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(
          context,
          'Failed to ${widget.isEdit ? 'update' : 'create'} position: ${e.toString()}',
          title: 'Error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(positionFormNotifierProvider);

    return AppDialog(
      title: widget.isEdit ? localizations.editPosition : 'Add New Position',
      width: 1050.w,
      onClose: () => context.pop(),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicInfoSection(
              localizations: localizations,
              codeController: _formControllers['code']!,
              titleEnglishController: _formControllers['titleEnglish']!,
              titleArabicController: _formControllers['titleArabic']!,
              isEdit: widget.isEdit,
              isActive: formState.isActive,
              onStatusChanged: (val) => ref.read(positionFormNotifierProvider.notifier).setIsActive(val ?? true),
            ),
            Gap(24.h),
            OrganizationalSection(
              localizations: localizations,
              selectedUnitIds: _selectedUnitIds,
              onEnterpriseSelectionChanged: _handleEnterpriseSelection,
              costCenterController: _formControllers['costCenter']!,
              locationController: _formControllers['location']!,
              initialSelections: widget.initialPosition.orgPathRefs,
            ),
            Gap(24.h),
            JobClassificationSection(localizations: localizations),
            Gap(24.h),
            HeadcountSection(
              localizations: localizations,
              positionsController: _formControllers['positions']!,
              filledController: _formControllers['filled']!,
              selectedEmploymentType: formState.employmentType,
              onEmploymentTypeChanged: (val) => ref.read(positionFormNotifierProvider.notifier).setEmploymentType(val),
            ),
            Gap(24.h),
            SalarySection(
              localizations: localizations,
              budgetedMinController: _formControllers['budgetedMin']!,
              budgetedMaxController: _formControllers['budgetedMax']!,
              actualAverageController: _formControllers['actualAverage']!,
            ),
            Gap(24.h),
            ReportingSection(
              localizations: localizations,
              enterpriseId: ref.watch(activeEnterpriseIdProvider) ?? 0,
              selectedReportsToEmployee: _selectedReportsToEmployee,
              onReportsToEmployeeSelected: (employee) {
                setState(() => _selectedReportsToEmployee = employee);
              },
            ),
          ],
        ),
      ),
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: _isSaving ? null : () => context.pop(), width: 100.w),
        Gap(12.w),
        AppButton.primary(
          label: widget.isEdit ? localizations.saveUpdates : localizations.saveChanges,
          svgPath: _isSaving ? null : Assets.icons.saveIcon.path,
          isLoading: _isSaving,
          onPressed: _isSaving ? null : _handleSave,
          width: 180.w,
        ),
      ],
    );
  }
}
