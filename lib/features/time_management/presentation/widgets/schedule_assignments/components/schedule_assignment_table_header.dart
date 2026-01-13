import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ScheduleAssignmentTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(context, 'Assigned To', 274.86.w),
          _buildHeaderCell(context, 'Schedule', 297.46.w),
          _buildHeaderCell(context, 'Start Date', 139.55.w),
          _buildHeaderCell(context, 'End Date', 136.6.w),
          _buildHeaderCell(context, localizations.status, 117.47.w),
          _buildHeaderCell(context, 'Assigned By', 197.22.w),
          _buildHeaderCell(context, localizations.actions, 135.w),
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
