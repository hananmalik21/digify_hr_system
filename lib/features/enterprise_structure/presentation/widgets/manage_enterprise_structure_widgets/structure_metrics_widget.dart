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

    // Mobile: stacked (no ellipsis needed typically, but safe)
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRichText(
            label: localizations.components,
            value: components.toString(),
            isDark: isDark,
            isTablet: false,
            maxLines: 1,
          ),
          SizedBox(height: 4.h),
          InfoRichText(
            label: localizations.employees,
            value: employees.toString(),
            isDark: isDark,
            isTablet: false,
            maxLines: 1,
          ),
          SizedBox(height: 4.h),
          InfoRichText(
            label: localizations.created,
            value: created,
            isDark: isDark,
            isTablet: false,
            maxLines: 1,
          ),
          SizedBox(height: 4.h),
          InfoRichText(
            label: localizations.modified,
            value: modified,
            isDark: isDark,
            isTablet: false,
            maxLines: 1,
          ),
        ],
      );
    }

    // Tablet/Desktop: row with Expanded + ellipsis
    final labelSize = isTablet ? 12.8.sp : 14.sp;
    final valueSize = isTablet ? 12.5.sp : 13.7.sp;

    return Row(
      children: [
        Expanded(
          child: InfoRichText(
            label: localizations.components,
            value: components.toString(),
            isDark: isDark,
            isTablet: isTablet,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: InfoRichText(
            label: localizations.employees,
            value: employees.toString(),
            isDark: isDark,
            isTablet: isTablet,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: InfoRichText(
            label: localizations.created,
            value: created,
            isDark: isDark,
            isTablet: isTablet,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: InfoRichText(
            label: localizations.modified,
            value: modified,
            isDark: isDark,
            isTablet: isTablet,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}



class InfoRichText extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isTablet;
  final TextAlign textAlign;
  final int maxLines;

  const InfoRichText({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    required this.isTablet,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          /// Label / Heading
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontSize: isTablet ? 12.8.sp : 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4B5563),
              height: 20 / 14,
            ),
          ),

          /// Value / Info
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: isTablet ? 12.5.sp : 13.7.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : const Color(0xFF101828),
              height: 20 / 13.7,
            ),
          ),
        ],
      ),
    );
  }
}
