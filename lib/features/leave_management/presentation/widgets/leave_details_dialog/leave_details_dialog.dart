import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_details_data_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'leave_details_dialog_models.dart';
import 'leave_details_dialog_styles.dart';
import 'leave_details_employee_section.dart';
import 'leave_details_labor_law_section.dart';
import 'leave_details_leave_type_selector.dart';
import 'leave_details_summary_section.dart';
import 'leave_details_transaction_section.dart';

class LeaveDetailsDialog extends ConsumerStatefulWidget {
  const LeaveDetailsDialog({super.key, required this.employeeName, required this.employeeId});

  final String employeeName;
  final String employeeId;

  static Future<void> show(BuildContext context, {required String employeeName, required String employeeId}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LeaveDetailsDialog(employeeName: employeeName, employeeId: employeeId),
    );
  }

  @override
  ConsumerState<LeaveDetailsDialog> createState() => _LeaveDetailsDialogState();
}

class _LeaveDetailsDialogState extends ConsumerState<LeaveDetailsDialog> {
  LeaveType _selectedLeaveType = LeaveType.annualLeave;

  static Map<LeaveType, Map<String, dynamic>> _summaryMapFromData(
    Map<String, Map<String, dynamic>> summaryByLeaveType,
  ) {
    return {
      LeaveType.annualLeave: summaryByLeaveType['annualLeave']!,
      LeaveType.sickLeave: summaryByLeaveType['sickLeave']!,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final asyncData = ref.watch(leaveDetailsDataProvider(widget.employeeId));

    return AppDialog(
      title: 'Leave Balance Details',
      subtitle: '${widget.employeeName} • ${widget.employeeId}',
      width: 896.w,
      content: asyncData.when(
        loading: () => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: const AppLoadingIndicator(type: LoadingType.circle),
          ),
        ),
        error: (_, __) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: Text(
              'Failed to load details',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        data: (data) {
          final summaryMap = _summaryMapFromData(data.summaryByLeaveType);
          final summary = summaryMap[_selectedLeaveType]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              LeaveDetailsEmployeeSection(employeeData: data.employeeData, isDark: isDark),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsLeaveTypeSelector(
                selectedLeaveType: _selectedLeaveType,
                onTypeChanged: (type) => setState(() => _selectedLeaveType = type),
                isDark: isDark,
              ),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsSummarySection(summary: summary, isDark: isDark),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsTransactionSection(transactions: data.transactions, isDark: isDark),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsLaborLawSection(isDark: isDark),
            ],
          );
        },
      ),
      actions: [
        Text(
          'Last updated: ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        AppButton(label: 'Close', type: AppButtonType.outline, onPressed: () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Export Report',
          type: AppButtonType.primary,
          onPressed: () {},
          svgPath: Assets.icons.downloadIcon.path,
        ),
      ],
    );
  }
}
