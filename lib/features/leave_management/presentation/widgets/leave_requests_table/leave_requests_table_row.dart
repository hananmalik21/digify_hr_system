import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LeaveRequestsTableRow extends StatelessWidget {
  final TimeOffRequest request;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const LeaveRequestsTableRow({
    super.key,
    required this.request,
    required this.localizations,
    required this.isDark,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 14.sp,
      color: AppColors.dialogTitle,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Text(request.employeeName.isEmpty ? '-' : request.employeeName, style: textStyle),
            177.94.w,
          ),
          _buildDataCell(_buildTypeCell(), 164.03.w),
          _buildDataCell(
            Text(DateFormat('MM/dd/yyyy').format(request.startDate), style: textStyle),
            188.68.w,
          ),
          _buildDataCell(
            Text(DateFormat('MM/dd/yyyy').format(request.endDate), style: textStyle),
            186.61.w,
          ),
          _buildDataCell(
            Text(
              request.totalDays.toInt().toString(),
              style: textStyle?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            124.29.w,
          ),
          _buildDataCell(
            Text(request.reason, style: textStyle),
            258.88.w,
          ),
          _buildDataCell(_buildStatusCell(), 202.09.w),
          _buildDataCell(_buildActionsCell(), 161.48.w),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: child,
    );
  }

  Widget _buildTypeCell() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        _getLeaveTypeLabel().toLowerCase(),
        style: TextStyle(
          fontSize: 15.4.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
          height: 24 / 15.4,
        ),
      ),
    );
  }

  Widget _buildStatusCell() {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (request.status) {
      case RequestStatus.pending:
        backgroundColor = AppColors.warningBg;
        textColor = const Color(0xFF894B00);
        label = localizations.leaveFilterPending;
        break;
      case RequestStatus.approved:
        backgroundColor = AppColors.successBg;
        textColor = AppColors.successText;
        label = localizations.leaveFilterApproved;
        break;
      case RequestStatus.rejected:
        backgroundColor = AppColors.errorBg;
        textColor = AppColors.errorText;
        label = localizations.rejected;
        break;
      case RequestStatus.cancelled:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(1000.r),
      ),
      child: Text(
        label.toLowerCase(),
        style: TextStyle(
          fontSize: 15.4.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 24 / 15.4,
        ),
      ),
    );
  }

  Widget _buildActionsCell() {
    if (request.status != RequestStatus.pending) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onApprove,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.check,
              size: 20.sp,
              color: AppColors.success,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: onReject,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  String _getLeaveTypeLabel() {
    switch (request.type) {
      case TimeOffType.annualLeave:
        return localizations.annualLeave;
      case TimeOffType.sickLeave:
        return localizations.sickLeave;
      case TimeOffType.personalLeave:
        return localizations.emergencyLeave;
      case TimeOffType.emergencyLeave:
        return localizations.emergencyLeave;
      case TimeOffType.unpaidLeave:
        return 'Unpaid Leave';
      case TimeOffType.other:
        return 'Other';
    }
  }
}
