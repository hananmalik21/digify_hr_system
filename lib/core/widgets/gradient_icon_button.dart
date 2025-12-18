import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientIconButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double? shadowOpacity;
  final EdgeInsets? padding;
  final double? iconSize;
  final double? fontSize;

  const GradientIconButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    required this.backgroundColor,
    this.shadowOpacity,
    this.padding,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: shadowOpacity ?? 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIconWidget(
              assetPath: iconPath,
              size: iconSize ?? 20.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize ?? 15.1.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 24 / (fontSize ?? 15.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

