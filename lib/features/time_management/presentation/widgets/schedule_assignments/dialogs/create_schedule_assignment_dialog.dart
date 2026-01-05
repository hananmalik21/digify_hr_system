import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/date_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/department_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/work_schedule_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreateScheduleAssignmentDialog extends StatefulWidget {
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
  State<CreateScheduleAssignmentDialog> createState() => _CreateScheduleAssignmentDialogState();
}

class _CreateScheduleAssignmentDialogState extends State<CreateScheduleAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  AssignmentLevel? _selectedLevel;
  String? _selectedWorkSchedule;
  String? _selectedStatus;
  final _departmentController = TextEditingController();
  final _effectiveStartDateController = TextEditingController();
  final _effectiveEndDateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _departmentController.dispose();
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

  void _handleAssign() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Assign Schedule',
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
            DepartmentField(
              controller: _departmentController,
              selectedLevel: _selectedLevel,
              validator: (value) {
                if (_selectedLevel == AssignmentLevel.department && (value == null || value.isEmpty)) {
                  return 'Please select a department';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            WorkScheduleField(
              selectedWorkSchedule: _selectedWorkSchedule,
              workSchedules: const [],
              onChanged: (value) {
                setState(() {
                  _selectedWorkSchedule = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
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
        AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: () => Navigator.of(context).pop()),
        SizedBox(width: 12.w),
        AppButton(
          label: 'Assign Schedule',
          type: AppButtonType.primary,
          onPressed: _handleAssign,
          width: null,
          svgPath: Assets.icons.saveIcon.path,
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
