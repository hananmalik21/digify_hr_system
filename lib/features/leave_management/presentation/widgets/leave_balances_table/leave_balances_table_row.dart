import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_balances_table_config.dart';
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

  const LeaveBalancesTableRow({super.key, required this.employeeData});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.theme.brightness == Brightness.dark;
    final textStyle = _buildTextStyle(context, isDark);
    final secondaryTextStyle = _buildSecondaryTextStyle(context, isDark, textStyle);

    final rowCells = <Widget>[];

    if (LeaveBalancesTableConfig.showEmployee) {
      rowCells.add(_buildEmployeeCell(context, textStyle, secondaryTextStyle));
    }
    if (LeaveBalancesTableConfig.showDepartment) {
      rowCells.add(_buildDepartmentCell(context, textStyle));
    }
    if (LeaveBalancesTableConfig.showJoinDate) {
      rowCells.add(_buildJoinDateCell(context, textStyle));
    }
    if (LeaveBalancesTableConfig.showAnnualLeave) {
      rowCells.add(
        _buildLeaveBalanceCell(
          context,
          employeeData['annualLeave'] ?? 0,
          LeaveBadgeType.annualLeave,
          LeaveBalancesTableConfig.annualLeaveWidth.w,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showSickLeave) {
      rowCells.add(
        _buildLeaveBalanceCell(
          context,
          employeeData['sickLeave'] ?? 0,
          LeaveBadgeType.sickLeave,
          LeaveBalancesTableConfig.sickLeaveWidth.w,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showUnpaidLeave) {
      rowCells.add(
        _buildLeaveBalanceCell(
          context,
          employeeData['unpaidLeave'] ?? 0,
          LeaveBadgeType.unpaidLeave,
          LeaveBalancesTableConfig.unpaidLeaveWidth.w,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showTotalAvailable) {
      rowCells.add(
        _buildLeaveBalanceCell(
          context,
          employeeData['totalAvailable'] ?? 0,
          LeaveBadgeType.totalAvailable,
          LeaveBalancesTableConfig.totalAvailableWidth.w,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showActions) {
      rowCells.add(
        _buildDataCell(
          _buildActionsCell(context, localizations),
          LeaveBalancesTableConfig.actionsWidth.w,
          center: true,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(children: rowCells),
    );
  }

  TextStyle? _buildTextStyle(BuildContext context, bool isDark) {
    return context.textTheme.titleSmall?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
  }

  TextStyle? _buildSecondaryTextStyle(BuildContext context, bool isDark, TextStyle? baseStyle) {
    return baseStyle?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
  }

  Widget _buildEmployeeCell(BuildContext context, TextStyle? textStyle, TextStyle? secondaryTextStyle) {
    return _buildDataCell(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employeeData['name'] ?? '-', style: textStyle),
          Gap(2.h),
          Text(employeeData['id'] ?? '-', style: secondaryTextStyle),
        ],
      ),
      LeaveBalancesTableConfig.employeeWidth.w,
    );
  }

  Widget _buildDepartmentCell(BuildContext context, TextStyle? textStyle) {
    return _buildDataCell(
      Text(employeeData['department'] ?? '-', style: textStyle),
      LeaveBalancesTableConfig.departmentWidth.w,
    );
  }

  Widget _buildJoinDateCell(BuildContext context, TextStyle? textStyle) {
    return _buildDataCell(
      Text(_formatDate(employeeData['joinDate']), style: textStyle),
      LeaveBalancesTableConfig.joinDateWidth.w,
    );
  }

  Widget _buildLeaveBalanceCell(
    BuildContext context,
    dynamic balance,
    LeaveBadgeType type,
    double width, {
    bool center = false,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return _buildDataCell(
      LeaveBalanceBadge(text: '${balance ?? 0} ${localizations.days.toLowerCase()}', type: type),
      width,
      center: center,
    );
  }

  Widget _buildDataCell(Widget child, double width, {bool center = false}) {
    return Container(
      width: width,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      child: child,
    );
  }

  Widget _buildActionsCell(BuildContext context, AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.blueEyeIcon.path,
          onTap: () => _handleDetails(context),
          width: 20,
          height: 20,
        ),
        DigifyAssetButton(
          assetPath: Assets.icons.editIcon.path,
          onTap: () => _handleAdjust(context),
          width: 20,
          height: 20,
        ),
      ],
    );
  }

  void _handleAdjust(BuildContext context) {
    AdjustLeaveBalanceDialog.show(
      context,
      employeeName: employeeData['name'] ?? '',
      employeeId: employeeData['id'] ?? '',
      currentAnnualLeave: employeeData['annualLeave'] ?? 0,
      currentSickLeave: employeeData['sickLeave'] ?? 0,
      currentUnpaidLeave: employeeData['unpaidLeave'] ?? 0,
    );
  }

  void _handleDetails(BuildContext context) {
    LeaveDetailsDialog.show(context, employeeName: employeeData['name'] ?? '', employeeId: employeeData['id'] ?? '');
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
