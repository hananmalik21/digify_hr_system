import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_text_theme.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:intl/intl.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_time_picker_dialog.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';
import 'package:digify_hr_system/features/attendance/presentation/providers/mark_attendance_form_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceDialog extends ConsumerStatefulWidget {
  final Attendance? attendance;

  const MarkAttendanceDialog({super.key, this.attendance});

  static Future<void> show(BuildContext context, {Attendance? attendance}) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MarkAttendanceDialog(attendance: attendance),
    );
  }

  bool get isEditMode => attendance != null;

  @override
  ConsumerState<MarkAttendanceDialog> createState() => _MarkAttendanceDialogState();
}

class _MarkAttendanceDialogState extends ConsumerState<MarkAttendanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _employeeSearchController = TextEditingController();
  final _durationController = TextEditingController();
  final _overtimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.attendance != null) {
        ref.read(markAttendanceFormProvider.notifier).initializeFromAttendance(widget.attendance!);
      }
      _syncControllersWithState();
    });
  }

  void _syncControllersWithState() {
    final state = ref.read(markAttendanceFormProvider);
    if (_employeeSearchController.text != (state.employeeName ?? '')) {
      _employeeSearchController.text = state.employeeName ?? '';
    }
    if (_durationController.text != (state.scheduleDuration?.toString() ?? '8')) {
      _durationController.text = state.scheduleDuration?.toString() ?? '8';
    }
    if (_overtimeController.text != (state.overtimeHours?.toString() ?? '0')) {
      _overtimeController.text = state.overtimeHours?.toString() ?? '0';
    }
    if (_locationController.text != (state.location ?? 'Kuwait City HQ')) {
      _locationController.text = state.location ?? 'Kuwait City HQ';
    }
    if (_notesController.text != (state.notes ?? '')) {
      _notesController.text = state.notes ?? '';
    }
  }

  @override
  void dispose() {
    _employeeSearchController.dispose();
    _durationController.dispose();
    _overtimeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(markAttendanceFormProvider);
    final notifier = ref.read(markAttendanceFormProvider.notifier);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.w, maxHeight: MediaQuery.of(context).size.height * 0.9),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 12))],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEmployeeField(context, isDark, state, notifier),
                        Gap(14.h),
                        _buildDateField(context, isDark, state, notifier),
                        Gap(14.h),
                        context.isMobile
                            ? Column(children: [_buildScheduleStartTimeField(context, isDark, state, notifier), Gap(14.h), _buildScheduleDurationField(context, isDark, state, notifier)])
                            : Row(
                                children: [
                                  Expanded(child: _buildScheduleStartTimeField(context, isDark, state, notifier)),
                                  Gap(16.w),
                                  Expanded(child: _buildScheduleDurationField(context, isDark, state, notifier)),
                                ],
                              ),
                        Gap(14.h),
                        _buildStatusField(context, isDark, state, notifier),
                        Gap(14.h),
                        context.isMobile
                            ? Column(children: [_buildCheckInTimeField(context, isDark, state, notifier), Gap(14.h), _buildCheckOutTimeField(context, isDark, state, notifier)])
                            : Row(
                                children: [
                                  Expanded(child: _buildCheckInTimeField(context, isDark, state, notifier)),
                                  Gap(16.w),
                                  Expanded(child: _buildCheckOutTimeField(context, isDark, state, notifier)),
                                ],
                              ),
                        Gap(14.h),
                        _buildOvertimeHoursField(context, isDark, state, notifier),
                        Gap(14.h),
                        _buildLocationField(context, isDark, state, notifier),
                        Gap(14.h),
                        // if (state.checkInTime != null && state.checkOutTime != null) ...[
                        if (!widget.isEditMode) ...[_buildHoursWorkedCard(context, isDark, state), Gap(14.h)],
                        _buildNotesField(context, isDark, state, notifier),
                      ],
                    ),
                  ),
                ),
                _buildFooter(context, isDark, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final title = widget.isEditMode ? 'Edit Attendance' : 'Mark Attendance';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Row(
        children: [
          DigifyAsset(assetPath: Assets.icons.sidebar.scheduleAssignments.path, width: 18.w, height: 18.h, color: Colors.white),
          Gap(4.w),
          Expanded(
            child: Text(
              title,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(Icons.cancel_outlined, size: 20.r, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Select Employee',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Gap(7.h),
        DigifyTextField(
          controller: _employeeSearchController,
          hintText: 'Type to search employees...',
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: 3.w, top: 9.h, bottom: 9.h, left: 14.w),
            child: DigifyAsset(assetPath: Assets.icons.searchIcon.path, width: 18.w, height: 18.h, color: AppColors.dialogCloseIcon),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: DigifyAsset(assetPath: Assets.icons.workforce.chevronDown.path, width: 10.w, height: 10.h, color: AppColors.textSecondary),
          ),
          fillColor: AppColors.cardBackground,
          filled: true,
          readOnly: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Date',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Gap(7.h),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: state.date ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (picked != null) {
              notifier.setDate(picked);
            }
          },
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.date != null ? DateFormat('dd/MM/yyyy').format(state.date!) : 'Select Date',
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: state.date != null ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary) : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleStartTimeField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Start Time',
          style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
        ),
        Gap(7.h),
        InkWell(
          onTap: () async {
            final picked = await DigifyTimePickerDialog.show(context, initialTime: state.scheduleStartTime ?? const TimeOfDay(hour: 8, minute: 0));
            if (picked != null) {
              notifier.setScheduleStartTime(picked);
            }
          },
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.scheduleStartTime != null ? _formatTimeOfDay(state.scheduleStartTime!) : '08:00 AM',
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.blackTextColor),
                  ),
                ),
                Icon(Icons.access_time, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleDurationField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Duration (hours)',
          style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
        ),
        Gap(6.h),
        DigifyTextField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          fillColor: AppColors.cardBackground,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
          filled: true,
          onChanged: (value) {
            final duration = int.tryParse(value);
            notifier.setScheduleDuration(duration);
          },
        ),
      ],
    );
  }

  Widget _buildStatusField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    final statusOptions = [
      AttendanceStatus.present,
      AttendanceStatus.late,
      AttendanceStatus.absent,
      AttendanceStatus.early,
      AttendanceStatus.onLeave,
      AttendanceStatus.halfDay,
      AttendanceStatus.officialWork,
      AttendanceStatus.businessTrip,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Status',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Gap(6.h),
        DigifySelectField<AttendanceStatus>(
          label: '',
          value: state.status,
          items: statusOptions,
          itemLabelBuilder: (status) => _statusToString(status),
          onChanged: notifier.setStatus,
          color: AppColors.cardBackground,
        ),
      ],
    );
  }

  Widget _buildCheckInTimeField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Check In Time',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: () async {
            final picked = await DigifyTimePickerDialog.show(context, initialTime: state.checkInTime ?? const TimeOfDay(hour: 8, minute: 0));
            if (picked != null) {
              notifier.setCheckInTime(picked);
            }
          },
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.checkInTime != null ? _formatTimeOfDay(state.checkInTime!) : '-- : --',
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: state.checkInTime != null ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary) : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Icon(Icons.access_time, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckOutTimeField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Check Out Time',
          style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w500),
        ),
        Gap(6.h),
        InkWell(
          onTap: () async {
            final picked = await DigifyTimePickerDialog.show(context, initialTime: state.checkOutTime ?? const TimeOfDay(hour: 17, minute: 0));
            if (picked != null) {
              notifier.setCheckOutTime(picked);
            }
          },
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.checkOutTime != null ? _formatTimeOfDay(state.checkOutTime!) : '-- : --',
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: state.checkOutTime != null ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary) : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Icon(Icons.access_time, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOvertimeHoursField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overtime Hours',
          style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
        ),
        Gap(7.h),
        DigifyTextField(
          controller: _overtimeController,
          keyboardType: TextInputType.number,
          fillColor: AppColors.cardBackground,
          filled: true,
          // contentPadding: EdgeInsets.symmetric(horizontal: 14.w,vertical: 7.h),
          onChanged: (value) {
            final hours = int.tryParse(value);
            notifier.setOvertimeHours(hours);
          },
        ),
        Gap(4.h),
        Text(
          'Kuwait Labor Law: Max 2 hours/day',
          style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(fontSize: 12.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText),
        ),
      ],
    );
  }

  Widget _buildLocationField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Location',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Gap(7.h),
        DigifyTextField(controller: _locationController, fillColor: AppColors.cardBackground, filled: true, onChanged: notifier.setLocation),
      ],
    );
  }

  Widget _buildHoursWorkedCard(BuildContext context, bool isDark, MarkAttendanceFormState state) {
    // if (state.checkInTime == null || state.checkOutTime == null) {
    //   return const SizedBox.shrink();
    // }
    //
    // // Calculate hours worked
    // final checkInDateTime = DateTime(
    //   state.date?.year ?? DateTime.now().year,
    //   state.date?.month ?? DateTime.now().month,
    //   state.date?.day ?? DateTime.now().day,
    //   state.checkInTime!.hour,
    //   state.checkInTime!.minute,
    // );
    // final checkOutDateTime = DateTime(
    //   state.date?.year ?? DateTime.now().year,
    //   state.date?.month ?? DateTime.now().month,
    //   state.date?.day ?? DateTime.now().day,
    //   state.checkOutTime!.hour,
    //   state.checkOutTime!.minute,
    // );

    // Handle case where check-out is next day
    // final checkOut = checkOutDateTime.isBefore(checkInDateTime)
    //     ? checkOutDateTime.add(const Duration(days: 1))
    //     : checkOutDateTime;
    //
    // final duration = checkOut.difference(checkInDateTime);
    // final totalMinutes = duration.inMinutes;
    // final hours = totalMinutes ~/ 60;
    // final minutes = totalMinutes % 60;
    // final hoursWorkedText = '${hours}h ${minutes}m';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(assetPath: Assets.icons.priceUpItem.path, width: 18.w, height: 18.h, color: AppColors.infoText),
          Gap(8.w),
          Text(
            'Hours Worked: 8h 15m',
            // 'Hours Worked: $hoursWorkedText',
            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.infoText, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField(BuildContext context, bool isDark, MarkAttendanceFormState state, MarkAttendanceFormNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel, fontWeight: FontWeight.w400),
        ),
        Gap(7.h),
        DigifyTextField(
          controller: _notesController,
          hintText: 'Additional notes about attendance...',
          maxLines: 4,
          minLines: 4,
          fillColor: AppColors.cardBackground,
          filled: true,
          onChanged: notifier.setNotes,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, MarkAttendanceFormNotifier notifier) {
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!context.isMobile) AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: () => Navigator.of(context).pop(), height: 40.h),
          Gap(12.w),
          AppButton(
            label: 'Save Attendance',
            type: AppButtonType.primary,
            svgPath: Assets.icons.activeDepartmentsIcon.path,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Implement save logic
                Navigator.of(context).pop();
              }
            },
            height: 40.h,
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _statusToString(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.early:
        return 'Early';
      case AttendanceStatus.onLeave:
        return 'On Leave';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.officialWork:
        return 'Official Work';
      case AttendanceStatus.businessTrip:
        return 'Business Trip';
    }
  }
}
