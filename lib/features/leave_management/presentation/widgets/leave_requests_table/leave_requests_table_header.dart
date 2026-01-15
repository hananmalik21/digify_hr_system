import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const LeaveRequestsTableHeader({
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
          _buildHeaderCell(context, localizations.employee, 177.94.w),
          _buildHeaderCell(context, localizations.leaveType, 164.03.w),
          _buildHeaderCell(context, localizations.startDate, 188.68.w),
          _buildHeaderCell(context, localizations.endDate, 186.61.w),
          _buildHeaderCell(context, localizations.days, 124.29.w),
          _buildHeaderCell(context, localizations.reason, 258.88.w),
          _buildHeaderCell(context, localizations.status, 202.09.w),
          _buildHeaderCell(context, localizations.actions, 161.48.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }
}
