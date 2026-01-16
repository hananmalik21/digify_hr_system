import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveDetailsStep extends ConsumerStatefulWidget {
  const LeaveDetailsStep({super.key});

  @override
  ConsumerState<LeaveDetailsStep> createState() => _LeaveDetailsStepState();
}

class _LeaveDetailsStepState extends ConsumerState<LeaveDetailsStep> {
  final _employeeController = TextEditingController();
  final _leaveTypeController = TextEditingController();

  @override
  void dispose() {
    _employeeController.dispose();
    _leaveTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    if (state.selectedEmployeeName != null) {
      _employeeController.text = state.selectedEmployeeName!;
    }
    if (state.leaveType != null) {
      _leaveTypeController.text = _getLeaveTypeLabel(state.leaveType!, localizations);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGuidelinesBox(localizations, isDark),
        Gap(24.h),
        _buildEmployeeField(localizations, isDark, notifier),
        Gap(24.h),
        _buildLeaveTypeField(localizations, isDark, state, notifier),
        Gap(24.h),
        _buildDateFields(localizations, isDark, state, notifier),
      ],
    );
  }

  Widget _buildGuidelinesBox(AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
        ),
        border: Border.all(color: const Color(0xFFBEDBFF)),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10.r)),
            child: Icon(Icons.info_outline, size: 20.sp, color: const Color(0xFF1C398E)),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.leaveRequestGuidelines,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF1C398E),
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(4.h),
                Text(
                  localizations.submitRequests3DaysAdvance,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: const Color(0xFF1447E6), fontSize: 11.8.sp),
                ),
                Text(
                  localizations.sickLeaveRequiresCertificate,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: const Color(0xFF1447E6), fontSize: 11.8.sp),
                ),
                Text(
                  localizations.ensureWorkHandover,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: const Color(0xFF1447E6), fontSize: 11.8.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeField(AppLocalizations localizations, bool isDark, NewLeaveRequestNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localizations.employee} *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _employeeController,
          hintText: localizations.typeToSearchEmployees,
          filled: true,
          fillColor: Colors.white,
          borderColor: const Color(0xFFD1D5DC),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 17.w, end: 8.w),
            child: DigifyAsset(
              assetPath: Assets.icons.searchIcon.path,
              width: 18,
              height: 18,
              color: AppColors.textMuted,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsetsDirectional.only(end: 17.w),
            child: DigifyAsset(
              assetPath: Assets.icons.dropdownArrowIcon.path,
              width: 18,
              height: 18,
              color: AppColors.textMuted,
            ),
          ),
          readOnly: true,
          onTap: () {
            // For now, set a mock employee
            notifier.setEmployee(1, 'John Doe');
            _employeeController.text = 'John Doe';
          },
        ),
      ],
    );
  }

  Widget _buildLeaveTypeField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    final leaveTypes = [
      TimeOffType.annualLeave,
      TimeOffType.sickLeave,
      TimeOffType.emergencyLeave,
      TimeOffType.personalLeave,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifySelectFieldWithLabel<TimeOffType>(
          label: localizations.leaveTypeRequired,
          hint: localizations.leaveTypeRequired,
          value: state.leaveType,
          items: leaveTypes,
          itemLabelBuilder: (type) => _getLeaveTypeLabel(type, localizations),
          onChanged: (type) {
            if (type != null) {
              notifier.setLeaveType(type);
            }
          },
          isRequired: true,
        ),
        if (state.leaveType == TimeOffType.annualLeave) ...[
          Gap(8.h),
          Container(
            padding: EdgeInsets.all(13.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBEDBFF)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Icon(Icons.info_outline, size: 16.sp, color: const Color(0xFF193CB8)),
                ),
                Gap(8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.regularPaidVacationLeave,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF193CB8),
                          fontSize: 15.4.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        localizations.maximum30DaysPerYear,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: const Color(0xFF1447E6), fontSize: 15.3.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateFields(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${localizations.startDate} *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF364153),
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(8.h),
              GestureDetector(
                onTap: () => _selectDate(context, notifier.setStartDate, state.startDate),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DC)),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.startDate != null ? DateFormat('dd/MM/yyyy').format(state.startDate!) : 'dd/mm/yyyy',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: state.startDate != null
                                ? const Color(0xFF0A0A0A)
                                : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                            fontSize: 15.4.sp,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today, size: 20.sp, color: const Color(0xFF0A0A0A)),
                    ],
                  ),
                ),
              ),
              Gap(8.h),
              DigifySelectFieldWithLabel<String>(
                label: localizations.startTime,
                hint: localizations.fullDay,
                value: state.startTime,
                items: [localizations.fullDay],
                itemLabelBuilder: (time) => time,
                onChanged: (time) {
                  if (time != null) {
                    notifier.setStartTime(time);
                  }
                },
                isRequired: false,
              ),
            ],
          ),
        ),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${localizations.endDate} *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF364153),
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(8.h),
              GestureDetector(
                onTap: () => _selectDate(context, notifier.setEndDate, state.endDate),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DC)),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.endDate != null ? DateFormat('dd/MM/yyyy').format(state.endDate!) : 'dd/mm/yyyy',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: state.endDate != null
                                ? const Color(0xFF0A0A0A)
                                : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                            fontSize: 15.4.sp,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today, size: 20.sp, color: const Color(0xFF0A0A0A)),
                    ],
                  ),
                ),
              ),
              Gap(8.h),
              DigifySelectFieldWithLabel<String>(
                label: localizations.endTime,
                hint: localizations.fullDay,
                value: state.endTime,
                items: [localizations.fullDay],
                itemLabelBuilder: (time) => time,
                onChanged: (time) {
                  if (time != null) {
                    notifier.setEndTime(time);
                  }
                },
                isRequired: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected, DateTime? initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _getLeaveTypeLabel(TimeOffType type, AppLocalizations localizations) {
    switch (type) {
      case TimeOffType.annualLeave:
        return localizations.annualLeave;
      case TimeOffType.sickLeave:
        return localizations.sickLeave;
      case TimeOffType.emergencyLeave:
        return localizations.emergencyLeave;
      case TimeOffType.personalLeave:
        return localizations.emergencyLeave;
      default:
        return localizations.annualLeave;
    }
  }
}
