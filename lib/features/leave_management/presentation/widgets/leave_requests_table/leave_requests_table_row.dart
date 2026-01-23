import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/string_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_requests_table_config.dart';
import 'package:digify_hr_system/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveRequestsTableRow extends StatelessWidget {
  final TimeOffRequest request;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isApproveLoading;
  final bool isRejectLoading;
  final bool isDeleteLoading;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const LeaveRequestsTableRow({
    super.key,
    required this.request,
    required this.localizations,
    required this.isDark,
    this.isApproveLoading = false,
    this.isRejectLoading = false,
    this.isDeleteLoading = false,
    this.onApprove,
    this.onReject,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (LeaveRequestsTableConfig.showEmployee)
            _buildDataCell(
              Text(request.employeeName.isEmpty ? '-' : request.employeeName, style: textStyle),
              LeaveRequestsTableConfig.employeeWidth.w,
            ),
          if (LeaveRequestsTableConfig.showLeaveType)
            _buildDataCell(_buildTypeCell(context), LeaveRequestsTableConfig.leaveTypeWidth.w),
          if (LeaveRequestsTableConfig.showStartDate)
            _buildDataCell(
              Text(DateFormat('MM/dd/yyyy').format(request.startDate), style: textStyle),
              LeaveRequestsTableConfig.startDateWidth.w,
            ),
          if (LeaveRequestsTableConfig.showEndDate)
            _buildDataCell(
              Text(DateFormat('MM/dd/yyyy').format(request.endDate), style: textStyle),
              LeaveRequestsTableConfig.endDateWidth.w,
            ),
          if (LeaveRequestsTableConfig.showDays)
            _buildDataCell(
              Text(
                request.totalDays.toInt().toString(),
                style: textStyle?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              LeaveRequestsTableConfig.daysWidth.w,
            ),
          if (LeaveRequestsTableConfig.showReason)
            _buildDataCell(Text(request.reason, style: textStyle), LeaveRequestsTableConfig.reasonWidth.w),
          if (LeaveRequestsTableConfig.showStatus)
            _buildDataCell(_buildStatusCell(context), LeaveRequestsTableConfig.statusWidth.w),
          if (LeaveRequestsTableConfig.showActions)
            _buildDataCell(_buildActionsCell(), LeaveRequestsTableConfig.actionsWidth.w),
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

  Widget _buildTypeCell(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        LeaveTypeMapper.getShortLabel(request.type),
        style: context.textTheme.bodyLarge?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.lightDark),
      ),
    );
  }

  Widget _buildStatusCell(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (request.status) {
      case RequestStatus.pending:
        backgroundColor = AppColors.pendingStatusBackground;
        textColor = AppColors.pendingStatucColor;
        label = localizations.leaveFilterPending;
        break;
      case RequestStatus.draft:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
        label = localizations.leaveFilterDraft;
        break;
      case RequestStatus.approved:
        backgroundColor = AppColors.holidayIslamicPaidBg;
        textColor = AppColors.holidayIslamicPaidText;
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(100.r)),
      child: Text(label.capitalizeFirst, style: context.textTheme.bodyLarge?.copyWith(color: textColor)),
    );
  }

  Widget _buildActionsCell() {
    if (request.status == RequestStatus.pending) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAssetButton(
            assetPath: Assets.icons.checkIconGreen.path,
            onTap: onApprove,
            width: 20,
            height: 20,
            color: AppColors.success,
            padding: 4.w,
            isLoading: isApproveLoading,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.closeIcon.path,
            onTap: onReject,
            width: 20,
            height: 20,
            color: AppColors.error,
            padding: 4.w,
            isLoading: isRejectLoading,
          ),
        ],
      );
    }

    if (request.status == RequestStatus.draft) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAssetButton(
            assetPath: Assets.icons.editIconGreen.path,
            onTap: onUpdate,
            width: 20,
            height: 20,
            color: AppColors.primary,
            padding: 4.w,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.deleteIconRed.path,
            onTap: onDelete,
            width: 20,
            height: 20,
            color: AppColors.error,
            padding: 4.w,
            isLoading: isDeleteLoading,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
