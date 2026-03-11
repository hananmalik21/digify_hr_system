import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/work_schedule_selection_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/schedule_assignment_enterprise_structure_fields.dart';
import 'package:digify_hr_system/core/widgets/forms/employee_search_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/employee.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/active_org_structure_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/domain/models/assignment_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateScheduleAssignmentDialog extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateScheduleAssignmentDialog({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateScheduleAssignmentDialog(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateScheduleAssignmentDialog> createState() => _CreateScheduleAssignmentDialogState();
}

class _CreateScheduleAssignmentDialogState extends ConsumerState<CreateScheduleAssignmentDialog> {
  AssignmentLevel? _selectedLevel;
  WorkSchedule? _selectedWorkSchedule;
  String? _selectedStatus;
  final Map<String, String?> _selectedUnitIds = {};
  DateTime? _effectiveStartDate;
  DateTime? _effectiveEndDate;
  Employee? _selectedEmployee;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLevel = AssignmentLevel.department;
    _selectedStatus = 'Active';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier);
      notifier.setEnterpriseId(widget.enterpriseId);
    });
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
    final orgStructureState = ref.read(scheduleAssignmentActiveOrgStructureProvider(widget.enterpriseId));
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
    final orgUnitId = _selectedLevel == AssignmentLevel.department ? _getLastSelectedOrgUnitId() : null;
    final employeeId = _selectedLevel == AssignmentLevel.employee ? _selectedEmployee?.id : null;
    final notifier = ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier);
    final errorMessage = await notifier.submitCreateAssignment(
      assignmentLevel: _selectedLevel,
      orgUnitId: orgUnitId,
      employeeId: employeeId,
      workSchedule: _selectedWorkSchedule,
      startDate: _effectiveStartDate,
      endDate: _effectiveEndDate,
      status: _selectedStatus,
      notes: _notesController.text,
    );

    if (!mounted) return;

    if (errorMessage != null) {
      ToastService.error(context, errorMessage, title: 'Error');
      return;
    }

    if (!mounted) return;

    ToastService.success(context, 'Schedule assignment created successfully', title: 'Success');
    if (!mounted) return;
    context.pop();

    await ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final scheduleAssignmentsState = ref.watch(scheduleAssignmentsNotifierProvider(widget.enterpriseId));
    final isCreating = scheduleAssignmentsState.isCreating;

    return AppDialog(
      title: 'Assign Schedule',
      width: 768.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AssignmentLevelSelector(
            selectedLevel: _selectedLevel,
            onLevelChanged: (level) {
              setState(() {
                _selectedLevel = level;
                if (level == AssignmentLevel.employee) {
                  _selectedUnitIds.clear();
                } else {
                  _selectedEmployee = null;
                }
              });
            },
          ),
          Gap(24.h),
          if (_selectedLevel == AssignmentLevel.employee)
            Builder(
              builder: (context) {
                return EmployeeSearchField(
                  label: 'Employee',
                  isRequired: true,
                  enterpriseId: widget.enterpriseId,
                  selectedEmployee: _selectedEmployee,
                  onEmployeeSelected: (employee) {
                    setState(() {
                      _selectedEmployee = employee;
                    });
                  },
                );
              },
            )
          else
            ScheduleAssignmentEnterpriseStructureFields(
              localizations: localizations,
              enterpriseId: widget.enterpriseId,
              selectedUnitIds: _selectedUnitIds,
              onSelectionChanged: _handleEnterpriseSelection,
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
      actions: [
        AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Assign Schedule',
          type: AppButtonType.primary,
          onPressed: isCreating ? null : _handleAssign,
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
        DigifyDateField(
          label: 'Effective Start Date',
          hintText: 'e.g. 01/01/2025',
          isRequired: true,
          initialDate: _effectiveStartDate,
          onDateSelected: (date) {
            setState(() {
              _effectiveStartDate = date;
              if (_effectiveEndDate != null && _effectiveEndDate!.isBefore(date)) {
                _effectiveEndDate = null;
              }
            });
          },
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
        Gap(24.h),
        DigifyDateField(
          label: 'Effective End Date',
          hintText: 'e.g. 31/12/2025',
          isRequired: true,
          initialDate: _effectiveEndDate,
          onDateSelected: (date) {
            setState(() {
              _effectiveEndDate = date;
            });
          },
          firstDate: _effectiveStartDate ?? DateTime(2000),
          lastDate: DateTime(2100),
          readOnly: _effectiveStartDate == null,
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      isRequired: true,
      hint: 'Select Status',
      items: const ['Active', 'Inactive'],
      itemLabelBuilder: (item) => item,
      value: _selectedStatus,
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
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
