import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';

class PositionTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const PositionTableHeader({
    super.key,
    required this.isDark,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark
        ? AppColors.cardBackgroundDark
        : const Color(0xFFF9FAFB);

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(localizations.positionCode, 117.53.w),
          _buildHeaderCell(localizations.title, 162.79.w),
          _buildHeaderCell(localizations.department, 151.96.w),
          _buildHeaderCell(localizations.jobFamily, 146.86.w),
          _buildHeaderCell(localizations.jobLevel, 141.12.w),
          _buildHeaderCell(localizations.gradeStep, 233.29.w),
          _buildHeaderCell(localizations.reportsTo, 140.07.w),
          _buildHeaderCell(localizations.headcount, 125.12.w),
          _buildHeaderCell(localizations.vacancy, 108.22.w),
          _buildHeaderCell(localizations.status, 107.02.w),
          _buildHeaderCell(localizations.actions, 112.03.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 12.h,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6A7282),
          height: 16 / 12,
        ),
      ),
    );
  }
}
