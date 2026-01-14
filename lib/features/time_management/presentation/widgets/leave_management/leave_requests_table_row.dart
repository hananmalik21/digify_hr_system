import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestRowData {
  final String? employee;
  final String type;
  final String startDate;
  final String endDate;
  final String days;
  final String reason;
  final String status;

  const LeaveRequestRowData({
    this.employee,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.reason,
    required this.status,
  });
}

class LeaveRequestsTableRow extends StatelessWidget {
  final LeaveRequestRowData data;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const LeaveRequestsTableRow({
    super.key,
    required this.data,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

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
            Text(
              data.employee ?? '',
              style: TextStyle(
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                height: 24 / 15.1,
              ),
            ),
            177.94.w,
          ),
          _buildDataCell(
            _buildTypeBadge(data.type, isDark),
            164.03.w,
          ),
          _buildDataCell(
            Text(
              data.startDate,
              style: TextStyle(
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                height: 24 / 15.1,
              ),
            ),
            188.68.w,
          ),
          _buildDataCell(
            Text(
              data.endDate,
              style: TextStyle(
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                height: 24 / 15.1,
              ),
            ),
            186.61.w,
          ),
          _buildDataCell(
            Text(
              data.days,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                height: 24 / 16,
              ),
            ),
            124.29.w,
          ),
          _buildDataCell(
            Text(
              data.reason,
              style: TextStyle(
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                height: 24 / 15.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            258.88.w,
          ),
          _buildDataCell(
            _buildStatusBadge(data.status, isDark),
            202.09.w,
          ),
          _buildActionCell(
            _buildActions(context, isDark),
            161.48.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 18.5.h),
      child: child,
    );
  }

  Widget _buildActionCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.only(start: 24.w, top: 17.h, bottom: 17.h),
      child: child,
    );
  }

  Widget _buildTypeBadge(String type, bool isDark) {
    // Font size from Figma: first row uses 15.4, second row uses 15.5
    // Using 15.4 as default, but could vary by row if needed
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        type.toLowerCase(),
        style: TextStyle(
          fontSize: 15.4.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
          height: 24 / 15.4,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = isDark ? const Color(0xFF78350F) : const Color(0xFFFEF9C2);
        textColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFF894B00);
        break;
      case 'approved':
        backgroundColor = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
        textColor = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF016630);
        break;
      case 'rejected':
        backgroundColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        textColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B);
        break;
      default:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg;
        textColor = isDark ? AppColors.textPrimaryDark : AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16777200.r),
      ),
      child: Text(
        status.toLowerCase(),
        style: TextStyle(
          // Font size from Figma: pending=15.4, approved=15.3
          fontSize: status.toLowerCase() == 'approved' ? 15.3.sp : 15.4.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: status.toLowerCase() == 'approved' ? 24 / 15.3 : 24 / 15.4,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    // Only show actions for pending requests
    if (data.status.toLowerCase() != 'pending') {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        InkWell(
          onTap: onApprove,
          borderRadius: BorderRadius.circular(4.r),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: DigifyAsset(
              assetPath: Assets.icons.checkIconGreen.path,
              width: 20,
              height: 20,
              color: AppColors.success,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onReject,
          borderRadius: BorderRadius.circular(4.r),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: DigifyAsset(
              assetPath: Assets.icons.closeIcon.path,
              width: 20,
              height: 20,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
