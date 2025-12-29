import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/position_form_actions.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/position_form_sections.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionFormDialog extends ConsumerStatefulWidget {
  final Position initialPosition;
  final bool isEdit;

  const PositionFormDialog({
    super.key,
    required this.initialPosition,
    required this.isEdit,
  });

  static void show(
    BuildContext context, {
    required Position position,
    required bool isEdit,
  }) {
    showDialog(
      context: context,
      builder: (context) =>
          PositionFormDialog(initialPosition: position, isEdit: isEdit),
    );
  }

  @override
  ConsumerState<PositionFormDialog> createState() => _PositionFormDialogState();
}

class _PositionFormDialogState extends ConsumerState<PositionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final Map<String, TextEditingController> _formControllers;
  late final Map<String, int?> _selectedUnitIds;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final position = widget.initialPosition;

    _selectedUnitIds = Map<String, int?>.from(position.orgPathIds ?? {});
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
      'reportsTitle': TextEditingController(text: position.reportsTo ?? ''),
      'reportsCode': TextEditingController(text: position.reportsTo ?? ''),
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

  void _handleEnterpriseSelection(String levelCode, int? unitId) {
    setState(() {
      _selectedUnitIds[levelCode] = unitId;
    });
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formState = ref.read(positionFormNotifierProvider);
    final orgStructureState = ref.read(orgStructureNotifierProvider);

    if (formState.jobFamily == null ||
        formState.jobLevel == null ||
        formState.grade == null) {
      ToastService.error(
        context,
        'Please select Job Family, Level and Grade',
        title: 'Selection Required',
      );
      return;
    }

    // Get the deepest selected org unit
    int? lastUnitId;
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];
    for (final level in levels) {
      final id = _selectedUnitIds[level.levelCode];
      if (id != null) {
        lastUnitId = id;
      }
    }

    if (lastUnitId == null) {
      ToastService.error(
        context,
        'Please select at least one organizational unit',
        title: 'Structure Required',
      );
      return;
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
      "step_no":
          int.tryParse(formState.step?.replaceAll('Step ', '') ?? '') ?? 1,
      "number_of_positions":
          int.tryParse(_formControllers['positions']!.text) ?? 0,
      "filled_positions": int.tryParse(_formControllers['filled']!.text) ?? 0,
      "employment_type": formState.employmentType,
      "budgeted_min_kd":
          double.tryParse(_formControllers['budgetedMin']!.text) ?? 0.0,
      "budgeted_max_kd":
          double.tryParse(_formControllers['budgetedMax']!.text) ?? 0.0,
      "actual_avg_kd":
          double.tryParse(_formControllers['actualAverage']!.text) ?? 0.0,
      "last_update_login": "HR_ADMIN",
    };

    setState(() => _isSaving = true);

    try {
      if (widget.isEdit) {
        await ref
            .read(positionNotifierProvider.notifier)
            .updatePosition(widget.initialPosition.id, payload);
      } else {
        await ref
            .read(positionNotifierProvider.notifier)
            .createPosition(payload);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ToastService.success(
          context,
          widget.isEdit
              ? 'Position updated successfully'
              : 'Position created successfully',
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1050.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PositionDialogHeader(
                title: widget.isEdit
                    ? localizations.editPosition
                    : 'Add New Position',
                onClose: () => Navigator.of(context).pop(),
              ),
              const Divider(height: 1, color: Color(0xffD1D5DC)),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicInfoSection(
                        localizations: localizations,
                        codeController: _formControllers['code']!,
                        titleEnglishController:
                            _formControllers['titleEnglish']!,
                        titleArabicController: _formControllers['titleArabic']!,
                        isEdit: widget.isEdit,
                      ),
                      SizedBox(height: 24.h),
                      OrganizationalSection(
                        localizations: localizations,
                        selectedUnitIds: _selectedUnitIds,
                        onEnterpriseSelectionChanged:
                            _handleEnterpriseSelection,
                        costCenterController: _formControllers['costCenter']!,
                        locationController: _formControllers['location']!,
                        initialSelections: widget.initialPosition.orgPathRefs,
                      ),
                      SizedBox(height: 24.h),
                      JobClassificationSection(
                        localizations: localizations,
                        selectedStep: formState.step,
                        onStepChanged: (val) => ref
                            .read(positionFormNotifierProvider.notifier)
                            .setStep(val),
                      ),
                      SizedBox(height: 24.h),
                      HeadcountSection(
                        localizations: localizations,
                        positionsController: _formControllers['positions']!,
                        filledController: _formControllers['filled']!,
                        selectedEmploymentType: formState.employmentType,
                        onEmploymentTypeChanged: (val) => ref
                            .read(positionFormNotifierProvider.notifier)
                            .setEmploymentType(val),
                      ),
                      SizedBox(height: 24.h),
                      SalarySection(
                        localizations: localizations,
                        budgetedMinController: _formControllers['budgetedMin']!,
                        budgetedMaxController: _formControllers['budgetedMax']!,
                        actualAverageController:
                            _formControllers['actualAverage']!,
                      ),
                      SizedBox(height: 24.h),
                      ReportingSection(
                        localizations: localizations,
                        reportsTitleController:
                            _formControllers['reportsTitle']!,
                        reportsCodeController: _formControllers['reportsCode']!,
                      ),
                      SizedBox(height: 24.h),
                      StatusSection(
                        localizations: localizations,
                        isActive: formState.isActive,
                        onStatusChanged: (val) => ref
                            .read(positionFormNotifierProvider.notifier)
                            .setIsActive(val),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xffD1D5DC)),
              PositionFormActions(
                localizations: localizations,
                isEdit: widget.isEdit,
                isLoading: _isSaving,
                onCancel: () => Navigator.of(context).pop(),
                onSave: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
