import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A reusable checkbox widget that follows the app's design system
/// Supports light/dark themes and can be used with or without a label
class DigifyCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final Color? activeColor;
  final Color? checkColor;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;

  const DigifyCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelWidget,
    this.activeColor,
    this.checkColor,
    this.enabled = true,
    this.padding,
    this.alignment = MainAxisAlignment.start,
  }) : assert(label == null || labelWidget == null, 'Cannot provide both label and labelWidget');

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveCheckColor = checkColor ?? Colors.white;

    final borderColor = enabled
        ? (value ? effectiveActiveColor : (isDark ? AppColors.borderGreyDark : AppColors.borderGrey))
        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    final backgroundColor = value ? effectiveActiveColor : (isDark ? AppColors.cardBackgroundDark : Colors.white);

    final checkbox = GestureDetector(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 15.w,
        height: 15.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor, width: value ? 0 : 1.5),
        ),
        child: value ? Icon(Icons.check_rounded, size: 14.sp, color: effectiveCheckColor) : null,
      ),
    );

    if (label == null && labelWidget == null) {
      return checkbox;
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          checkbox,
          if (label != null || labelWidget != null) ...[
            Gap(8.w),
            Flexible(
              child:
                  labelWidget ??
                  Text(
                    label!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: enabled
                          ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                          : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary),
                    ),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
