import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/employee_search_field.dart';
import 'package:digify_hr_system/core/widgets/forms/leave_type_search_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/api_leave_type.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
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
    final enterpriseId = ref.watch(leaveManagementEnterpriseIdProvider) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        _buildGuidelinesBox(context, localizations, isDark),
        _buildEmployeeField(context, localizations, isDark, state, notifier, enterpriseId),
        _buildLeaveTypeField(context, localizations, isDark, state, notifier, ref),
        _buildDateFields(context, localizations, isDark, state, notifier, ref),
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
    int enterpriseId,
  ) {
    return EmployeeSearchField(
      label: localizations.employee,
      isRequired: true,
      enterpriseId: enterpriseId,
      selectedEmployee: state.selectedEmployee,
      onEmployeeSelected: (employee) {
        notifier.updateEmployee(employee);
      },
      fillColor: AppColors.cardBackground,
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
          fillColor: AppColors.cardBackground,
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
    WidgetRef ref,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastSelectable = today.add(const Duration(days: 365));

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyDateField(
                key: ValueKey<String>(state.startDate?.toIso8601String() ?? 'start'),
                label: localizations.startDate,
                hintText: localizations.hintSelectDate,
                isRequired: true,
                initialDate: state.startDate,
                firstDate: today,
                lastDate: lastSelectable,
                onDateSelected: notifier.setStartDate,
                fillColor: AppColors.cardBackground,
              ),
              Gap(24.h),
              Builder(
                builder: (context) {
                  final List<AbsLookupValue> shiftOptions = ref.watch(
                    absLookupValuesForCodeProvider(AbsLookupCode.shiftTime),
                  );

                  AbsLookupValue? selectedStart;
                  if (state.startTime != null) {
                    for (final v in shiftOptions) {
                      if (v.lookupValueCode == state.startTime) {
                        selectedStart = v;
                        break;
                      }
                    }
                  }

                  return DigifySelectFieldWithLabel<AbsLookupValue>(
                    label: localizations.startTime,
                    hint: 'Select Time',
                    value: selectedStart,
                    items: shiftOptions,
                    itemLabelBuilder: (v) => v.lookupValueName,
                    onChanged: (v) {
                      if (v != null) {
                        notifier.setStartTime(v.lookupValueCode);
                      }
                    },
                    isRequired: true,
                    fillColor: AppColors.cardBackground,
                  );
                },
              ),
            ],
          ),
        ),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyDateField(
                key: ValueKey<String>(state.endDate?.toIso8601String() ?? 'end'),
                label: localizations.endDate,
                hintText: localizations.hintSelectDate,
                isRequired: true,
                initialDate: state.endDate,
                firstDate: today,
                lastDate: lastSelectable,
                onDateSelected: notifier.setEndDate,
                fillColor: AppColors.cardBackground,
              ),
              Gap(24.h),
              Builder(
                builder: (context) {
                  final List<AbsLookupValue> shiftOptions = ref.watch(
                    absLookupValuesForCodeProvider(AbsLookupCode.shiftTime),
                  );

                  AbsLookupValue? selectedEnd;
                  if (state.endTime != null) {
                    for (final v in shiftOptions) {
                      if (v.lookupValueCode == state.endTime) {
                        selectedEnd = v;
                        break;
                      }
                    }
                  }

                  return DigifySelectFieldWithLabel<AbsLookupValue>(
                    label: localizations.endTime,
                    hint: 'Select Time',
                    value: selectedEnd,
                    items: shiftOptions,
                    itemLabelBuilder: (v) => v.lookupValueName,
                    onChanged: (v) {
                      if (v != null) {
                        notifier.setEndTime(v.lookupValueCode);
                      }
                    },
                    isRequired: true,
                    fillColor: AppColors.cardBackground,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
