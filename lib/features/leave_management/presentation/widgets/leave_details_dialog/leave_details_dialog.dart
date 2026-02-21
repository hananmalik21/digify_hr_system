import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/api_leave_type.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_details_data_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'leave_details_dialog_styles.dart';
import 'leave_details_employee_section.dart';
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
          final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
          final selectedId = ref.watch(leaveDetailsSelectedLeaveTypeIdProvider(widget.employeeId));
          final selectedNotifier = ref.read(leaveDetailsSelectedLeaveTypeIdProvider(widget.employeeId).notifier);
          final leaveTypes = leaveTypesState.leaveTypes;
          final effectiveId = selectedId ?? leaveTypes.firstOrNull?.id;
          final selectedType = effectiveId != null ? leaveTypes.where((t) => t.id == effectiveId).firstOrNull : null;
          final summary = _summaryForLeaveType(data.summaryByLeaveType, selectedType);
          final transactionPage = ref.watch(leaveDetailsTransactionPageProvider(widget.employeeId));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              LeaveDetailsEmployeeSection(employeeData: data.employeeData, isDark: isDark),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsLeaveTypeSelector(
                leaveTypes: leaveTypes,
                selectedLeaveTypeId: effectiveId,
                onTypeChanged: (apiType) => selectedNotifier.state = apiType.id,
                isDark: isDark,
                isLoading: leaveTypesState.isLoading,
              ),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsSummarySection(summary: summary, isDark: isDark),
              Gap(leaveDetailsSectionGap.h),
              LeaveDetailsTransactionSection(
                transactions: transactionPage.transactions,
                isDark: isDark,
                paginationInfo: transactionPage.paginationInfo,
                currentPage: transactionPage.currentPage,
                pageSize: transactionPage.pageSize,
                onPrevious: transactionPage.movePrevious,
                onNext: transactionPage.moveNext,
                isLoading: transactionPage.isLoading,
                errorMessage: transactionPage.errorMessage,
              ),
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

  /// Resolves summary map for the selected API leave type.
  /// Tries keys: id (string), code (lowercase camel), code uppercase, then first entry.
  static Map<String, dynamic> _summaryForLeaveType(
    Map<String, Map<String, dynamic>> summaryByLeaveType,
    ApiLeaveType? selectedType,
  ) {
    if (summaryByLeaveType.isEmpty) {
      return <String, dynamic>{};
    }
    if (selectedType == null) {
      return summaryByLeaveType.values.first;
    }
    final byId = summaryByLeaveType[selectedType.id.toString()];
    if (byId != null) return byId;
    final codeLower = _codeToCamelKey(selectedType.code);
    final byCode = summaryByLeaveType[codeLower] ?? summaryByLeaveType[selectedType.code];
    if (byCode != null) return byCode;
    return summaryByLeaveType.values.first;
  }

  static String _codeToCamelKey(String code) {
    final lower = code.toLowerCase();
    if (lower.isEmpty) return lower;
    if (lower == 'annual') return 'annualLeave';
    if (lower == 'sick') return 'sickLeave';
    if (lower == 'unpaid') return 'unpaidLeave';
    return lower;
  }
}
