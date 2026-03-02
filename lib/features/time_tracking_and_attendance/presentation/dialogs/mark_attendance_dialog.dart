import 'package:digify_hr_system/core/services/location_provider.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/dialogs/mark_attendance_dialog_widgets/mark_attendance_dialog_widgets.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MarkAttendanceDialog extends ConsumerStatefulWidget {
  final AttendanceRecord? attendanceRecord;

  const MarkAttendanceDialog({super.key, this.attendanceRecord});

  static Future<void> show(BuildContext context, {AttendanceRecord? attendanceRecord}) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MarkAttendanceDialog(attendanceRecord: attendanceRecord),
    );
  }

  bool get isEditMode => attendanceRecord != null;

  @override
  ConsumerState<MarkAttendanceDialog> createState() => _MarkAttendanceDialogState();
}

class _MarkAttendanceDialogState extends ConsumerState<MarkAttendanceDialog> {
  final _employeeNameController = TextEditingController();
  final _durationController = TextEditingController();
  final _statusController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.attendanceRecord != null) {
        ref.read(markAttendanceFormProvider.notifier).initializeFromAttendanceRecord(widget.attendanceRecord!);
        _syncControllersWithState();
      } else {
        ref.read(markAttendanceFormProvider.notifier).reset();
      }
    });
  }

  void _syncControllersWithState() {
    final state = ref.read(markAttendanceFormProvider);
    _employeeNameController.text = state.employeeName ?? '';
    _durationController.text = state.scheduleDuration?.toString() ?? '';
    _statusController.text = state.status != null ? Attendance.statusToString(state.status!) : '';
    _locationController.text = state.location ?? '';
    _notesController.text = state.notes ?? '';
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _durationController.dispose();
    _statusController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(markAttendanceFormProvider);
    final notifier = ref.read(markAttendanceFormProvider.notifier);
    final enterpriseId = ref.watch(attendanceEnterpriseIdProvider);

    return AppDialog(
      title: widget.isEditMode ? 'Edit Attendance' : 'Mark Attendance',
      width: 800.w,
      onClose: () => context.pop(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (enterpriseId != null)
            MarkAttendanceEmployeeField(
              enterpriseId: enterpriseId,
              state: state,
              notifier: notifier,
              readOnly: widget.isEditMode,
              employeeNameController: widget.isEditMode ? _employeeNameController : null,
            )
          else
            MarkAttendanceEmployeeFieldPlaceholder(),
          Gap(14.h),
          MarkAttendanceDateField(
            initialDate: state.date,
            enabled: state.employeeId != null,
            readOnly: widget.isEditMode,
            onDateSelected: widget.isEditMode
                ? null
                : (state.employeeId != null
                      ? (date) {
                          notifier.setDate(date);
                          final employeeId = state.employeeId;
                          final repo = ref.read(attendanceRepositoryProvider);
                          if (employeeId != null && enterpriseId != null) {
                            notifier
                                .fetchAndPrefillForDate(
                                  context,
                                  date: date,
                                  repository: repo,
                                  enterpriseId: enterpriseId,
                                  employeeId: employeeId,
                                )
                                .then((_) {
                                  if (mounted) _syncControllersWithState();
                                });
                          }
                        }
                      : null),
          ),
          Gap(14.h),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: state.isFetchingByDate ? 0.5 : 1,
                child: IgnorePointer(
                  ignoring: state.isFetchingByDate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MarkAttendanceScheduleSection(
                        state: state,
                        notifier: notifier,
                        durationController: _durationController,
                        fieldsEnabled: state.date != null && state.dateFetchSucceeded,
                        prefilledKeys: state.prefilledFieldKeys,
                      ),
                      Gap(14.h),
                      MarkAttendanceStatusField(
                        state: state,
                        notifier: notifier,
                        controller: _statusController,
                        enabled: state.date != null && state.dateFetchSucceeded,
                        isStatusPrefilled: state.isFieldPrefilled(PrefilledFieldKey.status),
                      ),
                      Gap(14.h),
                      MarkAttendanceCheckInOutSection(
                        state: state,
                        notifier: notifier,
                        enabled: state.date != null && state.dateFetchSucceeded,
                        prefilledKeys: state.prefilledFieldKeys,
                      ),
                      Gap(14.h),
                      MarkAttendanceLocationField(
                        controller: _locationController,
                        onChanged: notifier.setLocation,
                        readOnly: state.isFieldPrefilled(PrefilledFieldKey.location),
                      ),
                      Gap(14.h),
                      MarkAttendanceHoursWorkedCard(state: state),
                      Gap(14.h),
                      MarkAttendanceNotesField(
                        controller: _notesController,
                        onChanged: notifier.setNotes,
                        readOnly: state.isFieldPrefilled(PrefilledFieldKey.notes),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.isFetchingByDate)
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppLoadingIndicator(type: LoadingType.circle),
                          Gap(12.h),
                          Text('Loading attendance...', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        if (!context.isMobile)
          AppButton(
            label: 'Cancel',
            type: AppButtonType.outline,
            onPressed: state.isLoading ? null : () => context.pop(),
          ),
        if (!context.isMobile) Gap(12.w),
        AppButton(
          label: 'Save Attendance',
          type: AppButtonType.primary,
          svgPath: Assets.icons.saveDivisionIcon.path,
          isLoading: state.isLoading,
          onPressed: state.isLoading
              ? null
              : () async {
                  final repo = ref.read(attendanceRepositoryProvider);
                  final enterpriseId = ref.read(attendanceEnterpriseIdProvider);
                  final userLocation = ref.read(locationProvider).valueOrNull;
                  await notifier.submit(
                    context,
                    repository: repo,
                    enterpriseId: enterpriseId,
                    userLocation: userLocation,
                    onSuccess: () => ref.read(attendanceNotifierProvider.notifier).refresh(),
                  );
                },
        ),
      ],
    );
  }
}
