import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalancesTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const LeaveBalancesTableHeader({
    super.key,
    required this.isDark,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(context, localizations.employee, 226.84.w),
          _buildHeaderCell(context, 'Department', 199.w),
          _buildHeaderCell(context, 'Join Date', 151.45.w),
          _buildHeaderCell(context, 'Annual Leave', 166.79.w, center: true),
          _buildHeaderCell(context, 'Sick Leave', 143.59.w, center: true),
          _buildHeaderCell(context, 'Unpaid Leave', 167.9.w, center: true),
          _buildHeaderCell(context, 'Total Available', 177.06.w, center: true),
          _buildHeaderCell(context, localizations.actions, 237.37.w, center: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {bool center = false}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }
}
