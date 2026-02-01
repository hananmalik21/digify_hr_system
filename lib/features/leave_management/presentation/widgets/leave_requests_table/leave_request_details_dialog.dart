import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/string_extensions.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// Leave Request Details dialog: header (title, request id, status badge center, close),
/// employee info, request submitted on, leave period details, reason, footer (Close; pending: Reject, Approve).
class LeaveRequestDetailsDialog {
  static Future<void> show(
    BuildContext context, {
    required TimeOffRequest request,
    String? department,
    String? position,
    VoidCallback? onApprove,
    VoidCallback? onReject,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _LeaveRequestDetailsDialogContent(
        request: request,
        department: department,
        position: position,
        onApprove: onApprove,
        onReject: onReject,
      ),
    );
  }
}

class _LeaveRequestDetailsDialogContent extends StatelessWidget {
  final TimeOffRequest request;
  final String? department;
  final String? position;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _LeaveRequestDetailsDialogContent({
    required this.request,
    this.department,
    this.position,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isPending = request.status == RequestStatus.pending;

    return AppDialog(
      title: 'Leave Request Details',
      subtitle: '${request.id}',
      width: 672.w,
      onClose: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: _buildStatusBadge(context, isDark)),
          Gap(20.h),
          _buildEmployeeInformationCard(context, isDark),
          Gap(16.h),
          _buildRequestSubmittedOnCard(context, isDark),
          Gap(16.h),
          _buildLeavePeriodDetailsCard(context, isDark),
          Gap(16.h),
          _buildReasonForLeaveCard(context, isDark),
        ],
      ),
      actions: _buildActions(context, isDark, isPending),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDark) {
    Color backgroundColor;
    Color textColor;
    String? iconPath;

    switch (request.status) {
      case RequestStatus.pending:
        backgroundColor = AppColors.pendingStatusBackground;
        textColor = AppColors.pendingStatucColor;
        iconPath = Assets.icons.clockIcon.path;
        break;
      case RequestStatus.approved:
        backgroundColor = AppColors.holidayIslamicPaidBg;
        textColor = AppColors.holidayIslamicPaidText;
        iconPath = Assets.icons.checkIconGreen.path;
        break;
      case RequestStatus.rejected:
        backgroundColor = AppColors.errorBg;
        textColor = AppColors.errorText;
        break;
      default:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
        break;
    }

    String label;
    switch (request.status) {
      case RequestStatus.pending:
        label = 'pending';
        break;
      case RequestStatus.approved:
        label = 'approved';
        break;
      case RequestStatus.rejected:
        label = 'rejected';
        break;
      case RequestStatus.draft:
        label = 'draft';
        break;
      case RequestStatus.cancelled:
        label = 'cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            DigifyAsset(assetPath: iconPath, width: 16.w, height: 16.h, color: textColor),
            Gap(8.w),
          ],
          Text(
            label.capitalizeFirst,
            style: context.textTheme.bodyMedium?.copyWith(color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInformationCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employee Information',
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: valueColor),
          ),
          Gap(16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Employee Name', labelColor),
                    Gap(4.h),
                    Text(
                      request.employeeName.isEmpty ? '-' : request.employeeName,
                      style: context.textTheme.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w500),
                    ),
                    Gap(12.h),
                    _buildLabel(context, 'Department', labelColor),
                    Gap(4.h),
                    Text(
                      department ?? '-',
                      style: context.textTheme.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Employee Number', labelColor),
                    Gap(4.h),
                    Text(
                      'EMP${request.employeeId.toString().padLeft(3, '0')}',
                      style: context.textTheme.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w500),
                    ),
                    Gap(12.h),
                    _buildLabel(context, 'Position', labelColor),
                    Gap(4.h),
                    Text(
                      position ?? '-',
                      style: context.textTheme.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text, Color color) {
    return Text(
      text,
      style: context.textTheme.labelSmall?.copyWith(color: color, fontSize: 12.sp),
    );
  }

  Widget _buildRequestSubmittedOnCard(BuildContext context, bool isDark) {
    final submittedAt = request.requestedAt;
    final dateStr = submittedAt != null ? DateFormat('EEEE, d MMMM yyyy').format(submittedAt) : '-';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                  context,
                  'Request Submitted On',
                  isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                Gap(4.h),
                InkWell(
                  onTap: submittedAt != null ? () {} : null,
                  borderRadius: BorderRadius.circular(4.r),
                  child: Text(
                    dateStr,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DigifyAsset(
            assetPath: Assets.icons.leaveManagementIcon.path,
            width: 20.w,
            height: 20.h,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLeavePeriodDetailsCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final leaveTypeLabel = LeaveTypeMapper.getShortLabel(request.type);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.leaveManagementIcon.path,
                width: 18.w,
                height: 18.h,
                color: valueColor,
              ),
              Gap(8.w),
              Text(
                'Leave Period Details',
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: valueColor),
              ),
            ],
          ),
          Gap(16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Leave Type', labelColor),
                    Gap(6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.infoBg,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.infoBorder, width: 1),
                      ),
                      child: Text(
                        leaveTypeLabel,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(12.h),
                    _buildLabel(context, 'Start Date', labelColor),
                    Gap(4.h),
                    Text(
                      DateFormat('EEE, d MMM yyyy').format(request.startDate),
                      style: context.textTheme.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Total Duration', labelColor),
                    Gap(4.h),
                    Text(
                      '${request.totalDays.toInt()} days',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: valueColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                    Gap(12.h),
                    _buildLabel(context, 'End Date', labelColor),
                    Gap(4.h),
                    Text(
                      DateFormat('EEE, d MMM yyyy').format(request.endDate),
                      style: context.textTheme.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonForLeaveCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, 'Reason for Leave', labelColor),
          Gap(10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder, width: 1),
            ),
            child: Text(
              request.reason.isEmpty ? '-' : request.reason,
              style: context.textTheme.bodyMedium?.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isDark, bool isPending) {
    final closeButton = _buildOutlinedButton(
      context: context,
      label: 'Close',
      isDark: isDark,
      onTap: () => Navigator.of(context).pop(),
    );

    if (!isPending) {
      return [closeButton];
    }

    return [
      closeButton,
      Gap(12.w),
      _buildFilledButton(
        context: context,
        label: 'Reject',
        backgroundColor: AppColors.error,
        onTap: () {
          Navigator.of(context).pop();
          onReject?.call();
        },
      ),
      Gap(12.w),
      _buildFilledButton(
        context: context,
        label: 'Approve',
        backgroundColor: AppColors.success,
        onTap: () {
          Navigator.of(context).pop();
          onApprove?.call();
        },
      ),
    ];
  }

  Widget _buildOutlinedButton({
    required BuildContext context,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          child: Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilledButton({
    required BuildContext context,
    required String label,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
          child: Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
