import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class AppDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final List<Widget>? actions;
  final Widget? icon;
  final double? width;
  final VoidCallback? onClose;

  const AppDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.actions,
    this.icon,
    this.width,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: width ?? 500.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 12)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: EdgeInsetsDirectional.all(24.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null) ...[icon!, SizedBox(width: 16.w)],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              subtitle!,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onClose ?? () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: DigifyAsset(
                            assetPath: Assets.icons.closeIcon.path,
                            width: 24,
                            height: 24,
                            color: AppColors.dialogCloseIcon,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(padding: EdgeInsets.all(24.w), child: content),
              ),

              // Footer
              if (actions != null)
                Container(
                  padding: EdgeInsetsDirectional.only(start: 24.w, end: 24.w, top: 20.h, bottom: 24.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                    ),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
