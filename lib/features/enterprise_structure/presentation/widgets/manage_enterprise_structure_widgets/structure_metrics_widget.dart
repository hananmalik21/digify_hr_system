import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Structure metrics widget
class StructureMetricsWidget extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final int components;
  final int employees;
  final String created;
  final String modified;

  const StructureMetricsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.components,
    required this.employees,
    required this.created,
    required this.modified,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localizations.components}: ${components.toString()}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${localizations.employees}: ${employees.toString()}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.7,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${localizations.created}: $created',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${localizations.modified}: $modified',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            '${localizations.components}: ${components.toString()}',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.employees}: ${employees.toString()}',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.7.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.7,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.created}: $created',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '${localizations.modified}: $modified',
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF6A7282),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

