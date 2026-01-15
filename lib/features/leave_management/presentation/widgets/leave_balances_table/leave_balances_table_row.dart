import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/adjust_leave_balance_dialog.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_badge.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveBalancesTableRow extends StatelessWidget {
  final Map<String, dynamic> employeeData;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onAdjust;
  final VoidCallback? onDetails;

  const LeaveBalancesTableRow({
    super.key,
    required this.employeeData,
    required this.localizations,
    required this.isDark,
    this.onAdjust,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 13.7.sp,
      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
    );

    final secondaryTextStyle = textStyle?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          _buildEmployeeCell(employeeData, textStyle, secondaryTextStyle),
          _buildDataCell(Text(employeeData['department'] ?? '-', style: textStyle), 199.w),
          _buildDataCell(Text(_formatDate(employeeData['joinDate']), style: textStyle), 151.45.w),
          _buildDataCell(
            Center(
              child: LeaveBalanceBadge(
                text: '${employeeData['annualLeave'] ?? 0} days',
                type: LeaveBadgeType.annualLeave,
              ),
            ),
            166.79.w,
          ),
          _buildDataCell(
            Center(
              child: LeaveBalanceBadge(text: '${employeeData['sickLeave'] ?? 0} days', type: LeaveBadgeType.sickLeave),
            ),
            143.59.w,
          ),
          _buildDataCell(
            Center(
              child: LeaveBalanceBadge(
                text: '${employeeData['unpaidLeave'] ?? 0} days',
                type: LeaveBadgeType.unpaidLeave,
              ),
            ),
            167.9.w,
          ),
          _buildDataCell(
            Center(
              child: LeaveBalanceBadge(
                text: '${employeeData['totalAvailable'] ?? 0} days',
                type: LeaveBadgeType.totalAvailable,
              ),
            ),
            177.06.w,
          ),
          _buildDataCell(_buildActionsCell(context), 237.37.w),
        ],
      ),
    );
  }

  Widget _buildEmployeeCell(Map<String, dynamic> employeeData, TextStyle? textStyle, TextStyle? secondaryTextStyle) {
    return Container(
      width: 226.84.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employeeData['name'] ?? '-', style: textStyle),
          Gap(2.h),
          Text(employeeData['id'] ?? '-', style: secondaryTextStyle),
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

  Widget _buildActionsCell(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          label: 'Adjust',
          iconPath: Assets.icons.editIcon.path,
          color: AppColors.primary,
          onPressed: () {
            AdjustLeaveBalanceDialog.show(
              context,
              employeeName: employeeData['name'] ?? '',
              employeeId: employeeData['id'] ?? '',
              currentAnnualLeave: employeeData['annualLeave'] ?? 0,
              currentSickLeave: employeeData['sickLeave'] ?? 0,
              currentUnpaidLeave: employeeData['unpaidLeave'] ?? 0,
            );
          },
        ),
        Gap(7.w),
        _buildActionButton(
          label: 'Details',
          iconPath: Assets.icons.blueEyeIcon.path,
          color: AppColors.greenButton,
          onPressed: () {
            LeaveDetailsDialog.show(
              context,
              employeeName: employeeData['name'] ?? '',
              employeeId: employeeData['id'] ?? '',
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required String iconPath,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(3.5.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: iconPath, width: 14, height: 14, color: color),
              Gap(3.5.w),
              Text(
                label,
                style: TextStyle(fontSize: 12.1.sp, fontWeight: FontWeight.w500, color: color, height: 17.5 / 12.1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
