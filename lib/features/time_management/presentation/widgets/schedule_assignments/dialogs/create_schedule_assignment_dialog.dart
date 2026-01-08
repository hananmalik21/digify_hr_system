import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/schedule_assignment.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/date_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/work_schedule_field.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/enterprise_structure_fields.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreateScheduleAssignmentDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final ScheduleAssignment? initialAssignment;

  const CreateScheduleAssignmentDialog({super.key, required this.enterpriseId, this.initialAssignment});

  static Future<void> show(BuildContext context, int enterpriseId, {ScheduleAssignment? initialAssignment}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          CreateScheduleAssignmentDialog(enterpriseId: enterpriseId, initialAssignment: initialAssignment),
    );
  }

  @override
  ConsumerState<CreateScheduleAssignmentDialog> createState() => _CreateScheduleAssignmentDialogState();
}

class _CreateScheduleAssignmentDialogState extends ConsumerState<CreateScheduleAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  AssignmentLevel? _selectedLevel;
  int? _selectedWorkScheduleId;
  String? _selectedWorkScheduleName;
  String? _selectedStatus;
  final Map<String, String?> _selectedUnitIds = {};
  final _effectiveStartDateController = TextEditingController();
  final _effectiveEndDateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier);
      notifier.setEnterpriseId(widget.enterpriseId);

      if (widget.initialAssignment != null) {
        _initializeFields(widget.initialAssignment!);
      }
    });
  }

  void _initializeFields(ScheduleAssignment assignment) {
    _selectedLevel = assignment.assignmentLevel.toUpperCase() == 'DEPARTMENT'
        ? AssignmentLevel.department
        : AssignmentLevel.employee;

    if (assignment.orgUnit != null) {
      final orgUnit = assignment.orgUnit!;
      _selectedUnitIds[orgUnit.levelCode] = orgUnit.orgUnitId.toString();
    } else if (assignment.orgUnitId != null) {
      final orgStructureState = ref.read(orgStructureNotifierProvider);
      final levels = orgStructureState.orgStructure?.activeLevels ?? [];
      for (final level in levels) {
        _selectedUnitIds[level.levelCode] = assignment.orgUnitId.toString();
      }
    }

    _selectedWorkScheduleId = assignment.workScheduleId;
    _selectedWorkScheduleName = assignment.workSchedule.scheduleNameEn;

    _effectiveStartDateController.text = DateFormat('yyyy-MM-dd').format(assignment.effectiveStartDate);
    if (assignment.effectiveEndDate != null) {
      _effectiveEndDateController.text = DateFormat('yyyy-MM-dd').format(assignment.effectiveEndDate!);
    }

    _selectedStatus = assignment.status;

    if (assignment.notes != null && assignment.notes!.isNotEmpty) {
      _notesController.text = assignment.notes!;
    }
  }

  @override
  void dispose() {
    _effectiveStartDateController.dispose();
    _effectiveEndDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }

  void _handleEnterpriseSelection(String levelCode, String? unitId) {
    setState(() {
      _selectedUnitIds[levelCode] = unitId;
    });
  }

  String? _getLastSelectedOrgUnitId() {
    final orgStructureState = ref.read(orgStructureNotifierProvider);
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

  Future<void> _handleAssign() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLevel == null) {
      ToastService.error(context, 'Please select an assignment level', title: 'Selection Required');
      return;
    }

    final orgUnitId = _getLastSelectedOrgUnitId();
    if (orgUnitId == null) {
      ToastService.error(context, 'Please select an organizational unit', title: 'Selection Required');
      return;
    }

    if (_selectedWorkScheduleId == null) {
      ToastService.error(context, 'Please select a work schedule', title: 'Selection Required');
      return;
    }

    if (_effectiveStartDateController.text.isEmpty) {
      ToastService.error(context, 'Please select an effective start date', title: 'Selection Required');
      return;
    }

    if (_effectiveEndDateController.text.isEmpty) {
      ToastService.error(context, 'Please select an effective end date', title: 'Selection Required');
      return;
    }

    if (_selectedStatus == null || _selectedStatus!.isEmpty) {
      ToastService.error(context, 'Please select a status', title: 'Selection Required');
      return;
    }

    final assignmentData = <String, dynamic>{
      'tenant_id': widget.enterpriseId,
      'assignment_level': _selectedLevel == AssignmentLevel.department ? 'DEPARTMENT' : 'EMPLOYEE',
      'org_unit_id': orgUnitId,
      'work_schedule_id': _selectedWorkScheduleId!,
      'effective_start_date': _effectiveStartDateController.text.trim(),
      'effective_end_date': _effectiveEndDateController.text.trim(),
      'status': _selectedStatus!.toUpperCase(),
      if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
    };

    try {
      if (widget.initialAssignment != null) {
        await ref
            .read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier)
            .updateScheduleAssignment(widget.initialAssignment!.scheduleAssignmentId, assignmentData);

        if (mounted) {
          ToastService.success(context, 'Schedule assignment updated successfully', title: 'Success');
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } else {
        await ref
            .read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier)
            .createScheduleAssignment(assignmentData);

        if (mounted) {
          ToastService.success(context, 'Schedule assignment created successfully', title: 'Success');
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        final action = widget.initialAssignment != null ? 'update' : 'create';
        ToastService.error(context, 'Failed to $action schedule assignment: ${e.toString()}', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final scheduleAssignmentsState = ref.watch(scheduleAssignmentsNotifierProvider(widget.enterpriseId));
    final isCreating = scheduleAssignmentsState.isCreating;

    final isEdit = widget.initialAssignment != null;

    return AppDialog(
      title: isEdit ? 'Edit Schedule Assignment' : 'Assign Schedule',
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
            SizedBox(height: 24.h),
            EnterpriseStructureFields(
              localizations: localizations,
              selectedUnitIds: _selectedUnitIds,
              onSelectionChanged: _handleEnterpriseSelection,
            ),
            SizedBox(height: 24.h),
            WorkScheduleField(
              selectedWorkScheduleId: _selectedWorkScheduleId,
              selectedWorkScheduleName: _selectedWorkScheduleName,
              enterpriseId: widget.enterpriseId,
              onChanged: (schedule) {
                setState(() {
                  if (schedule != null) {
                    _selectedWorkScheduleId = schedule.workScheduleId;
                    _selectedWorkScheduleName = schedule.scheduleNameEn;
                  } else {
                    _selectedWorkScheduleId = null;
                    _selectedWorkScheduleName = null;
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a work schedule';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            _buildDateFields(),
            SizedBox(height: 24.h),
            _buildStatusField(),
            SizedBox(height: 24.h),
            _buildNotesField(),
            SizedBox(height: 24.h),
            const AssignmentInfoBox(),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          type: AppButtonType.outline,
          onPressed: isCreating ? null : () => Navigator.of(context).pop(),
        ),
        SizedBox(width: 12.w),
        AppButton(
          label: isEdit ? 'Update Schedule' : 'Assign Schedule',
          type: AppButtonType.primary,
          onPressed: isCreating ? null : _handleAssign,
          width: null,
          svgPath: Assets.icons.saveIcon.path,
          isLoading: isCreating,
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DateField(
          label: 'Effective Start Date',
          controller: _effectiveStartDateController,
          onTap: () => _selectDate(_effectiveStartDateController),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a start date';
            }
            return null;
          },
        ),
        SizedBox(height: 24.h),
        DateField(
          label: 'Effective End Date',
          controller: _effectiveEndDateController,
          onTap: () => _selectDate(_effectiveEndDateController),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an end date';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return DigifySelectField<String>(
      label: 'Status',
      isRequired: true,
      hint: 'Select Status',
      items: const ['Pending', 'Active', 'Inactive'],
      itemLabelBuilder: (item) => item,
      value: _selectedStatus,
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a status';
        }
        return null;
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
