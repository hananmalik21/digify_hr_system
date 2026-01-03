import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const WorkPatternTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(localizations.code, 166.5.w),
          _buildHeaderCell('NAME', 268.42.w),
          _buildHeaderCell('TYPE', 153.8.w),
          _buildHeaderCell('WORKING DAYS', 192.6.w),
          _buildHeaderCell('REST DAYS', 207.2.w),
          _buildHeaderCell('HOURS/WEEK', 176.52.w),
          _buildHeaderCell(localizations.status, 146.07.w),
          _buildHeaderCell(localizations.actions, 152.9.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.tableHeaderText,
          height: 16 / 12,
        ),
      ),
    );
  }
}
