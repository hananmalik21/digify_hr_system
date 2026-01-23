import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/date_selection_field.dart';
import 'package:digify_hr_system/core/widgets/forms/employee_search_field.dart';
import 'package:digify_hr_system/core/widgets/forms/leave_type_search_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_time_options_config.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/api_leave_type.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsStep extends ConsumerWidget {
  const LeaveDetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGuidelinesBox(context, localizations, isDark),
        Gap(24.h),
        _buildEmployeeField(context, localizations, isDark, state, notifier),
        Gap(24.h),
        _buildLeaveTypeField(context, localizations, isDark, state, notifier, ref),
        Gap(24.h),
        _buildDateFields(context, localizations, isDark, state, notifier),
      ],
    );
  }

  Widget _buildGuidelinesBox(BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        border: Border.all(color: AppColors.infoBorder),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
            child: Icon(Icons.info_outline, size: 20.sp, color: AppColors.infoText),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  localizations.leaveRequestGuidelines,
                  style: context.textTheme.titleSmall?.copyWith(color: AppColors.sidebarFooterTitle),
                ),
                Text(
                  localizations.submitRequests3DaysAdvance,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.infoTextSecondary, fontSize: 12.0.sp),
                ),
                Text(
                  localizations.sickLeaveRequiresCertificate,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.infoTextSecondary, fontSize: 12.0.sp),
                ),
                Text(
                  localizations.ensureWorkHandover,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.infoTextSecondary, fontSize: 12.0.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return EmployeeSearchField(
      label: localizations.employee,
      isRequired: true,
      enterpriseId: 1001,
      selectedEmployee: state.selectedEmployee,
      onEmployeeSelected: (employee) {
        notifier.updateEmployee(employee);
      },
    );
  }

  Widget _buildLeaveTypeField(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
    WidgetRef ref,
  ) {
    final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
    ApiLeaveType? selectedApiLeaveType;

    if (state.leaveTypeId != null && leaveTypesState.leaveTypes.isNotEmpty) {
      try {
        selectedApiLeaveType = leaveTypesState.leaveTypes.firstWhere((lt) => lt.id == state.leaveTypeId);
      } catch (_) {
        final leaveCode = _getLeaveCodeFromType(state.leaveType);
        if (leaveCode.isNotEmpty) {
          try {
            selectedApiLeaveType = leaveTypesState.leaveTypes.firstWhere(
              (lt) => lt.code.toUpperCase() == leaveCode.toUpperCase(),
            );
          } catch (_) {
            selectedApiLeaveType = null;
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeaveTypeSearchField(
          label: localizations.leaveTypeRequired,
          isRequired: true,
          selectedLeaveType: selectedApiLeaveType,
          onLeaveTypeSelected: (leaveType) {
            notifier.setLeaveTypeFromApi(leaveType.id, leaveType.code);
          },
        ),
        if (state.leaveType == TimeOffType.annualLeave || (selectedApiLeaveType?.code.toUpperCase() == 'ANNUAL')) ...[
          Gap(8.h),
          Container(
            padding: EdgeInsets.all(13.w),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              border: Border.all(color: AppColors.infoBorder),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Icon(Icons.info_outline, size: 16.sp, color: AppColors.infoText),
                ),
                Gap(8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.regularPaidVacationLeave,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.infoText,
                          fontSize: 15.4.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        selectedApiLeaveType?.maxDaysPerYear != null
                            ? 'Maximum ${selectedApiLeaveType!.maxDaysPerYear} days per year'
                            : localizations.maximum30DaysPerYear,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.infoTextSecondary,
                          fontSize: 15.3.sp,
                        ),
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

  String _getLeaveCodeFromType(TimeOffType? type) {
    if (type == null) return '';
    switch (type) {
      case TimeOffType.annualLeave:
        return 'ANNUAL';
      case TimeOffType.sickLeave:
        return 'SICK';
      case TimeOffType.personalLeave:
        return 'PERSONAL';
      case TimeOffType.emergencyLeave:
        return 'EMERGENCY';
      case TimeOffType.unpaidLeave:
        return 'UNPAID';
      case TimeOffType.other:
        return 'OTHER';
    }
  }

  Widget _buildDateFields(
    BuildContext context,
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
              DateSelectionField(
                label: localizations.startDate,
                isRequired: true,
                date: state.startDate,
                onDateSelected: notifier.setStartDate,
              ),
              Gap(24.h),
              DigifySelectFieldWithLabel<String>(
                label: localizations.startTime,
                hint: 'Select Time',
                value: LeaveTimeOptionsConfig.isValidTimeOption(state.startTime) ? state.startTime : null,
                items: LeaveTimeOptionsConfig.timeOptions,
                itemLabelBuilder: (time) => time,
                onChanged: (time) {
                  if (time != null) {
                    notifier.setStartTime(time);
                  }
                },
                isRequired: true,
              ),
            ],
          ),
        ),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSelectionField(
                label: localizations.endDate,
                isRequired: true,
                date: state.endDate,
                onDateSelected: notifier.setEndDate,
              ),
              Gap(24.h),
              DigifySelectFieldWithLabel<String>(
                label: localizations.endTime,
                hint: 'Select Time',
                value: LeaveTimeOptionsConfig.isValidTimeOption(state.endTime) ? state.endTime : null,
                items: LeaveTimeOptionsConfig.timeOptions,
                itemLabelBuilder: (time) => time,
                onChanged: (time) {
                  if (time != null) {
                    notifier.setEndTime(time);
                  }
                },
                isRequired: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
