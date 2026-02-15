import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/features/leave_management/data/config/leave_balances_table_config.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balance_badge.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

typedef OnAdjustRequested = void Function(BuildContext context, LeaveBalanceSummaryItem item);

class LeaveBalancesTableRow extends StatelessWidget {
  final LeaveBalanceSummaryItem item;
  final OnAdjustRequested? onAdjustRequested;

  const LeaveBalancesTableRow({super.key, required this.item, this.onAdjustRequested});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = _buildTextStyle(context, isDark);

    final rowCells = <Widget>[];

    if (LeaveBalancesTableConfig.showEmployee) {
      rowCells.add(_buildEmployeeNameCell(context, textStyle));
    }
    if (LeaveBalancesTableConfig.showEmployeeNumber) {
      rowCells.add(_buildEmployeeNumberCell(context, textStyle));
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
          item.annualLeave,
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
          item.sickLeave,
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
          0,
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
          item.totalAvailable,
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

  Widget _buildEmployeeNameCell(BuildContext context, TextStyle? textStyle) {
    final name = item.employeeName.trim().isEmpty ? '-' : item.employeeName;
    return _buildDataCell(Text(name, style: textStyle), LeaveBalancesTableConfig.employeeWidth.w);
  }

  Widget _buildEmployeeNumberCell(BuildContext context, TextStyle? textStyle) {
    return _buildDataCell(
      Text(item.employeeNumber.isEmpty ? '-' : item.employeeNumber, style: textStyle),
      LeaveBalancesTableConfig.employeeNumberWidth.w,
    );
  }

  Widget _buildDepartmentCell(BuildContext context, TextStyle? textStyle) {
    return _buildDataCell(
      Text(item.department.isEmpty ? '-' : item.department, style: textStyle),
      LeaveBalancesTableConfig.departmentWidth.w,
    );
  }

  Widget _buildJoinDateCell(BuildContext context, TextStyle? textStyle) {
    final text = item.joinDate != null ? DateFormat('yyyy-MM-dd').format(item.joinDate!) : '-';
    return _buildDataCell(Text(text, style: textStyle), LeaveBalancesTableConfig.joinDateWidth.w);
  }

  Widget _buildLeaveBalanceCell(
    BuildContext context,
    double value,
    LeaveBadgeType type,
    double width, {
    bool center = false,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return _buildDataCell(
      LeaveBalanceBadge(text: '$value ${localizations.days.toLowerCase()}', type: type),
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
        DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: () => _handleDetails(context)),
        DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: () => _handleAdjust(context)),
      ],
    );
  }

  void _handleAdjust(BuildContext context) {
    onAdjustRequested?.call(context, item);
  }

  void _handleDetails(BuildContext context) {
    LeaveDetailsDialog.show(context, employeeName: item.employeeName, employeeId: item.employeeNumber);
  }
}
