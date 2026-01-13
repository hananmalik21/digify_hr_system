import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedule_create_notifier.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/weekly_schedule_section.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_schedule_form_fields.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateWorkScheduleDialog extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateWorkScheduleDialog({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateWorkScheduleDialog(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateWorkScheduleDialog> createState() => _CreateWorkScheduleDialogState();
}

class _CreateWorkScheduleDialogState extends ConsumerState<CreateWorkScheduleDialog> {
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
        ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier).reset();
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
              onPrimary: AppColors.cardBackground,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;

      final notifier = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier);
      if (controller == _effectiveStartDateController) {
        notifier.setEffectiveStartDate(formattedDate);
      } else if (controller == _effectiveEndDateController) {
        notifier.setEffectiveEndDate(formattedDate);
      }
    }
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier);
    notifier.setScheduleCode(_scheduleCodeController.text);
    notifier.setScheduleNameEn(_scheduleNameEnController.text);
    notifier.setScheduleNameAr(_scheduleNameArController.text);

    final success = await notifier.create();

    if (mounted) {
      if (success) {
        context.pop();
        ToastService.success(context, 'Work schedule created successfully', title: 'Success');
      } else {
        final error = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId)).error;
        if (error != null) {
          ToastService.error(context, error, title: 'Error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final createState = ref.watch(workScheduleCreateNotifierProvider(widget.enterpriseId));

    final notifier = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier);

    return AppDialog(
      title: 'Create Work Schedule',
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
                selectedWorkPattern: createState.selectedWorkPattern,
                enterpriseId: widget.enterpriseId,
                selectedStatus: createState.selectedStatus,
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
                onStartDateTap: () => _selectDate(_effectiveStartDateController),
                onEndDateTap: () => _selectDate(_effectiveEndDateController),
              ),
              Gap(24.h),
              WeeklyScheduleSection(
                isDark: isDark,
                enterpriseId: widget.enterpriseId,
                shifts: const [],
                selectedWorkPattern: createState.selectedWorkPattern,
                assignmentMode: createState.assignmentMode,
                sameShiftForAllDays: createState.sameShiftForAllDays,
                dayShifts: createState.dayShifts,
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
          onPressed: createState.isCreating ? null : () => context.pop(),
        ),
        Gap(12.w),
        AppButton(
          label: 'Save Changes',
          width: 179.w,
          onPressed: createState.isCreating ? null : _handleCreate,
          isLoading: createState.isCreating,
          svgPath: Assets.icons.saveIcon.path,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
