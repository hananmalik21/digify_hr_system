import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveTrackColor;
  final Color? inactiveThumbColor;
  final double? width;
  final double? height;

  const DigifySwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeTrackColor,
    this.activeThumbColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final enabled = onChanged != null;
    final activeTrack = activeTrackColor ?? AppColors.success;
    final activeThumb = activeThumbColor ?? AppColors.buttonTextLight;
    final inactiveTrack = inactiveTrackColor ?? (isDark ? AppColors.cardBorderDark : AppColors.inputBorder);
    final inactiveThumb = inactiveThumbColor ?? AppColors.buttonTextLight;
    final w = width ?? 44.w;
    final h = height ?? 24.h;

    return SizedBox(
      width: w,
      height: h,
      child: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeTrackColor: activeTrack,
        activeThumbColor: activeThumb,
        inactiveThumbColor: inactiveThumb,
        inactiveTrackColor: inactiveTrack,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
