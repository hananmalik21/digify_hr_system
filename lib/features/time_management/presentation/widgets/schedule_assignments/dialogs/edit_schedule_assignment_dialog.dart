import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/date_selection_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/work_schedule_selection_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:digify_hr_system/features/time_management/domain/models/schedule_assignment.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/schedule_assignment_enterprise_structure_fields_edit.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditScheduleAssignmentDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final ScheduleAssignment assignment;

  const EditScheduleAssignmentDialog({super.key, required this.enterpriseId, required this.assignment});

  static Future<void> show(BuildContext context, int enterpriseId, ScheduleAssignment assignment) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditScheduleAssignmentDialog(enterpriseId: enterpriseId, assignment: assignment),
    );
  }

  @override
  ConsumerState<EditScheduleAssignmentDialog> createState() => _EditScheduleAssignmentDialogState();
}

class _EditScheduleAssignmentDialogState extends ConsumerState<EditScheduleAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late AssignmentLevel _selectedLevel;
  WorkSchedule? _selectedWorkSchedule;
  late String _selectedStatus;
  final Map<String, String?> _selectedUnitIds = {};
  Map<String, OrgUnit>? _initialSelections;
  DateTime? _effectiveStartDate;
  DateTime? _effectiveEndDate;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier);
      notifier.setEnterpriseId(widget.enterpriseId);

      _initializeEnterpriseStructure();
      _initializeWorkSchedule();
    });
  }

  void _initializeFormFields() {
    final assignment = widget.assignment;

    _selectedLevel = assignment.assignmentLevel.toUpperCase() == 'DEPARTMENT'
        ? AssignmentLevel.department
        : AssignmentLevel.employee;

    _effectiveStartDate = assignment.effectiveStartDate;
    _effectiveEndDate = assignment.effectiveEndDate;

    _selectedStatus = _convertStatusToDropdownFormat(assignment.status);

    _notesController = TextEditingController(text: assignment.notes ?? '');
  }

  void _initializeWorkSchedule() {
    final assignment = widget.assignment;
    final workSchedulesState = ref.read(workSchedulesNotifierProvider(widget.enterpriseId));
    try {
      final workSchedule = workSchedulesState.items.firstWhere(
        (schedule) => schedule.workScheduleId == assignment.workScheduleId,
      );
      if (mounted) {
        setState(() {
          _selectedWorkSchedule = workSchedule;
        });
      }
    } catch (e) {
      // Work schedule not found in current list, will remain null
      // User can select it from the field
    }
  }

  void _initializeEnterpriseStructure() {
    final assignment = widget.assignment;
    if (assignment.orgPath == null || assignment.orgPath!.isEmpty || assignment.orgUnit == null) {
      final enterpriseNotifier = ref.read(enterpriseOrgStructureNotifierProvider(widget.enterpriseId).notifier);
      enterpriseNotifier.reset();
      enterpriseNotifier.fetchOrgStructureByEnterpriseId(widget.enterpriseId);
      return;
    }

    final structureId = assignment.orgStructure?.id ?? assignment.orgUnit!.orgStructureId;
    final structureName = assignment.orgStructure?.name ?? assignment.enterprise?.name ?? '';
    final structureCode = assignment.orgStructure?.code ?? structureId;

    final enterpriseNotifier = ref.read(enterpriseOrgStructureNotifierProvider(widget.enterpriseId).notifier);
    enterpriseNotifier.reset();

    final levels = assignment.orgPath!.asMap().entries.map((entry) {
      final index = entry.key;
      final pathItem = entry.value;
      return OrgStructureLevel(
        levelId: index,
        structureId: structureId,
        levelNumber: index + 1,
        levelCode: pathItem.levelCode,
        levelName: pathItem.levelCode,
        isMandatory: false,
        isActive: true,
        displayOrder: index + 1,
      );
    }).toList();

    final enterpriseName = assignment.enterprise?.name ?? '';
    final orgStructure = OrgStructure(
      structureId: structureId,
      enterpriseId: widget.enterpriseId,
      enterpriseName: enterpriseName,
      structureCode: structureCode,
      structureName: structureName.isNotEmpty ? structureName : 'Organization Structure',
      structureType: 'ENTERPRISE',
      description: null,
      isActive: true,
      levels: levels,
    );

    enterpriseNotifier.setStructureDirectly(orgStructure);

    final initialSelections = <String, OrgUnit>{};
    for (int i = 0; i < assignment.orgPath!.length; i++) {
      final pathItem = assignment.orgPath![i];
      _selectedUnitIds[pathItem.levelCode] = pathItem.orgUnitId;

      final parentId = i > 0 ? assignment.orgPath![i - 1].orgUnitId : null;

      final orgUnit = OrgUnit(
        orgUnitId: pathItem.orgUnitId,
        orgStructureId: structureId,
        enterpriseId: widget.enterpriseId,
        levelCode: pathItem.levelCode,
        orgUnitCode: pathItem.orgUnitId,
        orgUnitNameEn: pathItem.nameEn,
        orgUnitNameAr: pathItem.nameAr,
        parentOrgUnitId: parentId,
        isActive: true,
      );
      initialSelections[pathItem.levelCode] = orgUnit;
    }

    if (initialSelections.isNotEmpty) {
      _initialSelections = initialSelections;
      if (mounted) setState(() {});
    }
  }

  String _convertStatusToDropdownFormat(String status) {
    final upperStatus = status.toUpperCase();
    switch (upperStatus) {
      case 'ACTIVE':
        return 'Active';
      case 'PENDING':
        return 'Pending';
      case 'INACTIVE':
        return 'Inactive';
      default:
        return status;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleEnterpriseSelection(String levelCode, String? unitId) {
    setState(() {
      _selectedUnitIds[levelCode] = unitId;
    });
  }

  String? _getLastSelectedOrgUnitId() {
    final orgStructureState = ref.read(enterpriseOrgStructureNotifierProvider(widget.enterpriseId));
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];

    String? lastUnitId;
    for (final level in levels) {
      final id = _selectedUnitIds[level.levelCode];
      if (id != null) {
        lastUnitId = id;
      }
    }
    return lastUnitId;
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final orgUnitId = _getLastSelectedOrgUnitId();
    if (orgUnitId == null) {
      ToastService.error(context, 'Please select an organizational unit', title: 'Selection Required');
      return;
    }

    if (_effectiveStartDate == null) {
      ToastService.error(context, 'Please select an effective start date', title: 'Selection Required');
      return;
    }

    if (_effectiveEndDate == null) {
      ToastService.error(context, 'Please select an effective end date', title: 'Selection Required');
      return;
    }

    if (_selectedWorkSchedule == null) {
      ToastService.error(context, 'Please select a work schedule', title: 'Selection Required');
      return;
    }

    if (_selectedStatus.isEmpty) {
      ToastService.error(context, 'Please select a status', title: 'Selection Required');
      return;
    }

    final assignmentData = <String, dynamic>{
      'tenant_id': widget.enterpriseId,
      'assignment_level': _selectedLevel == AssignmentLevel.department ? 'DEPARTMENT' : 'EMPLOYEE',
      'org_unit_id': orgUnitId,
      'work_schedule_id': _selectedWorkSchedule!.workScheduleId,
      'effective_start_date': DateFormat('yyyy-MM-dd').format(_effectiveStartDate!),
      'effective_end_date': DateFormat('yyyy-MM-dd').format(_effectiveEndDate!),
      'status': _selectedStatus.toUpperCase(),
      if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
    };

    try {
      await ref
          .read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier)
          .updateScheduleAssignment(widget.assignment.scheduleAssignmentId, assignmentData);

      if (mounted) {
        ToastService.success(context, 'Schedule assignment updated successfully', title: 'Success');
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Failed to update schedule assignment: ${e.toString()}', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final scheduleAssignmentsState = ref.watch(scheduleAssignmentsNotifierProvider(widget.enterpriseId));
    final isUpdating = scheduleAssignmentsState.isCreating;

    return AppDialog(
      title: 'Edit Schedule Assignment',
      width: 768.w,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AssignmentLevelSelector(
              selectedLevel: _selectedLevel,
              onLevelChanged: (level) {
                setState(() {
                  _selectedLevel = level;
                });
              },
            ),
            Gap(24.h),
            ScheduleAssignmentEnterpriseStructureFieldsEdit(
              localizations: localizations,
              enterpriseId: widget.enterpriseId,
              selectedUnitIds: _selectedUnitIds,
              initialSelections: _initialSelections,
              onSelectionChanged: _handleEnterpriseSelection,
              initialStructureName: widget.assignment.orgStructure?.name ?? widget.assignment.enterprise?.name,
              initialStructureId: widget.assignment.orgStructure?.id ?? widget.assignment.orgUnit?.orgStructureId,
            ),
            Gap(24.h),
            WorkScheduleSelectionField(
              label: 'Work Schedule',
              isRequired: true,
              enterpriseId: widget.enterpriseId,
              selectedWorkSchedule: _selectedWorkSchedule,
              onChanged: (schedule) {
                setState(() {
                  _selectedWorkSchedule = schedule;
                });
              },
            ),
            Gap(24.h),
            _buildDateFields(),
            Gap(24.h),
            _buildStatusField(),
            Gap(24.h),
            _buildNotesField(),
            Gap(24.h),
            const AssignmentInfoBox(),
          ],
        ),
      ),
      actions: [
        AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: isUpdating ? null : () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Update Schedule',
          type: AppButtonType.primary,
          onPressed: isUpdating ? null : _handleUpdate,
          width: null,
          svgPath: Assets.icons.saveIcon.path,
          isLoading: isUpdating,
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DateSelectionField(
          label: 'Effective Start Date',
          isRequired: true,
          date: _effectiveStartDate,
          onDateSelected: (date) {
            setState(() {
              _effectiveStartDate = date;
            });
          },
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
        Gap(24.h),
        DateSelectionField(
          label: 'Effective End Date',
          isRequired: true,
          date: _effectiveEndDate,
          onDateSelected: (date) {
            setState(() {
              _effectiveEndDate = date;
            });
          },
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      isRequired: true,
      hint: 'Select Status',
      items: const ['Pending', 'Active', 'Inactive'],
      itemLabelBuilder: (item) => item,
      value: _selectedStatus,
      onChanged: (value) {
        setState(() {
          _selectedStatus = value ?? '';
        });
      },
    );
  }

  Widget _buildNotesField() {
    return DigifyTextField(
      labelText: 'Notes (Optional)',
      controller: _notesController,
      hintText: 'Add any additional notes or comments...',
      maxLines: 4,
      minLines: 4,
    );
  }
}
