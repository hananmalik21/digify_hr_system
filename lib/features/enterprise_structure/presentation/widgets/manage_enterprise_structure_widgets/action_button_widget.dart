import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActionButtonWidget extends StatelessWidget {
  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final String label;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool isLoading;

  const ActionButtonWidget({
    super.key,
    required this.context,
    required this.localizations,
    required this.isDark,
    required this.label,
    required this.icon,
    this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10.r);

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: borderRadius,
        child: Container(
          width: 130.w,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isLoading)
                SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: AppLoadingIndicator(type: LoadingType.circle, color: textColor, size: 16.r),
                )
              else
                DigifyAsset(assetPath: icon, width: 16, height: 16, color: iconColor ?? textColor),
              Gap(8.w),
              Flexible(
                child: Text(
                  label,
                  style: context.textTheme.bodyLarge?.copyWith(color: textColor),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
