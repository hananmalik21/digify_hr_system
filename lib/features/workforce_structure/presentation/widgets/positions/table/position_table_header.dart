import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';

class PositionTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const PositionTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(context, localizations.positionCode, 117.53.w),
          _buildHeaderCell(context, localizations.title, 162.79.w),
          _buildHeaderCell(context, localizations.department, 151.96.w),
          _buildHeaderCell(context, localizations.jobFamily, 146.86.w),
          _buildHeaderCell(context, localizations.jobLevel, 141.12.w),
          _buildHeaderCell(context, localizations.gradeStep, 233.29.w),
          _buildHeaderCell(context, localizations.reportsTo, 140.07.w),
          _buildHeaderCell(context, localizations.headcount, 125.12.w),
          _buildHeaderCell(context, localizations.vacancy, 108.22.w),
          _buildHeaderCell(context, localizations.status, 107.02.w),
          _buildHeaderCell(context, localizations.actions, 130.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(text.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
