import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
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
          _buildHeaderCell(context, localizations.code, 166.5.w),
          _buildHeaderCell(context, 'NAME', 268.42.w),
          _buildHeaderCell(context, 'TYPE', 153.8.w),
          _buildHeaderCell(context, 'WORKING DAYS', 192.6.w),
          _buildHeaderCell(context, 'REST DAYS', 207.2.w),
          _buildHeaderCell(context, 'HOURS/WEEK', 176.52.w),
          _buildHeaderCell(context, localizations.status, 146.07.w),
          _buildHeaderCell(context, localizations.actions, 152.9.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(text, style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
