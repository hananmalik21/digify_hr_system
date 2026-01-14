import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTableHeader extends StatelessWidget {
  const LeaveRequestsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(localizations.employee, 177.94.w, 15.6),
          _buildHeaderCell(localizations.type, 164.03.w, 15.9),
          _buildHeaderCell(localizations.startDate, 188.68.w, 15.9),
          _buildHeaderCell(localizations.endDate, 186.61.w, 15.8),
          _buildHeaderCell(localizations.days, 124.29.w, 15.6),
          _buildHeaderCell(localizations.reason, 258.88.w, 15.8),
          _buildHeaderCell(localizations.status, 202.09.w, 15.9),
          _buildHeaderCell(localizations.actions, 161.48.w, 15.6),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width, double fontSize) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          height: 24 / fontSize, // Line height calculation
        ),
      ),
    );
  }
}
