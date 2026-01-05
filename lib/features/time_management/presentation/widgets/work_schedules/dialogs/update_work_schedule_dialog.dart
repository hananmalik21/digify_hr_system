import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedule_update_notifier.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/weekly_schedule_section.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_schedule_form_fields.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UpdateWorkScheduleDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final WorkSchedule schedule;

  const UpdateWorkScheduleDialog({super.key, required this.enterpriseId, required this.schedule});

  static Future<void> show(BuildContext context, int enterpriseId, WorkSchedule schedule) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateWorkScheduleDialog(enterpriseId: enterpriseId, schedule: schedule),
    );
  }

  @override
  ConsumerState<UpdateWorkScheduleDialog> createState() => _UpdateWorkScheduleDialogState();
}

class _UpdateWorkScheduleDialogState extends ConsumerState<UpdateWorkScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _scheduleCodeController = TextEditingController();
  final _scheduleNameEnController = TextEditingController();
  final _scheduleNameArController = TextEditingController();
  final _effectiveStartDateController = TextEditingController();
  final _effectiveEndDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final shiftsState = ref.read(shiftsNotifierProvider(widget.enterpriseId));
        final workPatternsState = ref.read(workPatternsNotifierProvider(widget.enterpriseId));
        final notifier = ref.read(
          workScheduleUpdateNotifierProvider((
            enterpriseId: widget.enterpriseId,
            scheduleId: widget.schedule.workScheduleId,
          )).notifier,
        );
        notifier.initializeFromSchedule(widget.schedule, shiftsState.items, workPatternsState.items);
        _scheduleCodeController.text = widget.schedule.scheduleCode;
        _scheduleNameEnController.text = widget.schedule.scheduleNameEn;
        _scheduleNameArController.text = widget.schedule.scheduleNameAr;
        _effectiveStartDateController.text = widget.schedule.formattedStartDate;
        _effectiveEndDateController.text = widget.schedule.formattedEndDate;
      }
    });
  }

  @override
  void dispose() {
    _scheduleCodeController.dispose();
    _scheduleNameEnController.dispose();
    _scheduleNameArController.dispose();
    _effectiveStartDateController.dispose();
    _effectiveEndDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller, {DateTime? initialDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
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

      final notifier = ref.read(
        workScheduleUpdateNotifierProvider((
          enterpriseId: widget.enterpriseId,
          scheduleId: widget.schedule.workScheduleId,
        )).notifier,
      );
      if (controller == _effectiveStartDateController) {
        notifier.setEffectiveStartDate(formattedDate);
      } else if (controller == _effectiveEndDateController) {
        notifier.setEffectiveEndDate(formattedDate);
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(
      workScheduleUpdateNotifierProvider((
        enterpriseId: widget.enterpriseId,
        scheduleId: widget.schedule.workScheduleId,
      )).notifier,
    );
    notifier.setScheduleCode(_scheduleCodeController.text);
    notifier.setScheduleNameEn(_scheduleNameEnController.text);
    notifier.setScheduleNameAr(_scheduleNameArController.text);

    final success = await notifier.update();

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ToastService.success(context, 'Work schedule updated successfully', title: 'Success');
      } else {
        final error = ref
            .read(
              workScheduleUpdateNotifierProvider((
                enterpriseId: widget.enterpriseId,
                scheduleId: widget.schedule.workScheduleId,
              )),
            )
            .error;
        if (error != null) {
          ToastService.error(context, error, title: 'Error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final updateState = ref.watch(
      workScheduleUpdateNotifierProvider((
        enterpriseId: widget.enterpriseId,
        scheduleId: widget.schedule.workScheduleId,
      )),
    );

    final notifier = ref.read(
      workScheduleUpdateNotifierProvider((
        enterpriseId: widget.enterpriseId,
        scheduleId: widget.schedule.workScheduleId,
      )).notifier,
    );

    return AppDialog(
      title: 'Update Work Schedule',
      width: 1024.w,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkScheduleFormFields(
                scheduleCodeController: _scheduleCodeController,
                scheduleNameEnController: _scheduleNameEnController,
                scheduleNameArController: _scheduleNameArController,
                effectiveStartDateController: _effectiveStartDateController,
                effectiveEndDateController: _effectiveEndDateController,
                selectedWorkPattern: updateState.selectedWorkPattern,
                enterpriseId: widget.enterpriseId,
                selectedStatus: updateState.selectedStatus,
                isScheduleCodeDisabled: true,
                onScheduleCodeChanged: (value) {
                  notifier.setScheduleCode(value);
                },
                onScheduleNameEnChanged: (value) {
                  notifier.setScheduleNameEn(value);
                },
                onScheduleNameArChanged: (value) {
                  notifier.setScheduleNameAr(value);
                },
                onWorkPatternChanged: (value) {
                  notifier.setSelectedWorkPattern(value);
                },
                onStatusChanged: (value) {
                  notifier.setSelectedStatus(value);
                },
                onStartDateTap: () =>
                    _selectDate(_effectiveStartDateController, initialDate: widget.schedule.effectiveStartDate),
                onEndDateTap: () =>
                    _selectDate(_effectiveEndDateController, initialDate: widget.schedule.effectiveEndDate),
              ),
              SizedBox(height: 24.h),
              WeeklyScheduleSection(
                isDark: isDark,
                enterpriseId: widget.enterpriseId,
                shifts: const [],
                selectedWorkPattern: updateState.selectedWorkPattern,
                assignmentMode: updateState.assignmentMode,
                sameShiftForAllDays: updateState.sameShiftForAllDays,
                dayShifts: updateState.dayShifts,
                onAssignmentModeChanged: (value) {
                  notifier.setAssignmentMode(value);
                },
                onSameShiftChanged: (value) {
                  notifier.setSameShiftForAllDays(value);
                },
                onDayShiftChanged: (dayOfWeek, shift) {
                  notifier.setDayShift(dayOfWeek, shift);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton.outline(
          label: 'Cancel',
          width: 100.w,
          onPressed: updateState.isUpdating ? null : () => Navigator.of(context).pop(),
        ),
        SizedBox(width: 12.w),
        AppButton(
          label: 'Save Changes',
          width: 179.w,
          onPressed: updateState.isUpdating ? null : _handleUpdate,
          isLoading: updateState.isUpdating,
          svgPath: Assets.icons.saveIcon.path,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
