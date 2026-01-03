import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Action button widget
class ActionButtonWidget extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final String label;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;
  final bool isLoading;

  const ActionButtonWidget({
    super.key,
    required this.context,
    required this.localizations,
    required this.isDark,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Calculate padding based on button type to match Figma exactly
    final isActivate = label == localizations.activate;
    final isView = label == localizations.view;
    final isEdit = label == localizations.edit;
    final isDuplicate = label == localizations.duplicate;
    final isDelete = label == localizations.delete;

    double startPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);
    double endPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);

    if (!isMobile) {
      if (isActivate) {
        endPadding = isTablet ? 22.w : 25.82.w;
      } else if (isView) {
        endPadding = isTablet ? 42.w : 49.51.w;
      } else if (isEdit) {
        endPadding = isTablet ? 48.w : 56.65.w;
      } else if (isDuplicate) {
        startPadding = isTablet ? 14.w : 16.w;
        endPadding = isTablet ? 14.w : 16.w;
      } else if (isDelete) {
        endPadding = isTablet ? 32.w : 37.62.w;
      }
    }

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: startPadding,
          end: endPadding,
          top: isMobile ? 10.h : 8.h,
          bottom: isMobile ? 10.h : 8.h,
        ),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            if (isLoading)
              SizedBox(
                width: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
                height: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(textColor)),
              )
            else
              DigifyAsset(
                assetPath: icon,
                width: isMobile ? 14 : (isTablet ? 15 : 16),
                height: isMobile ? 14 : (isTablet ? 15 : 16),
                color: textColor,
              ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isMobile
                      ? 13.sp
                      : (isActivate || isView
                            ? (isTablet ? 14.sp : 15.1.sp)
                            : (isDelete ? (isTablet ? 14.5.sp : 15.3.sp) : (isTablet ? 14.5.sp : 15.4.sp))),
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 24 / 15.1,
                  letterSpacing: 0,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
