import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseStructureTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final TextEditingController? controller;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ui.TextDirection? textDirection;

  const EnterpriseStructureTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.value,
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveController = controller ?? (value != null ? TextEditingController(text: value) : null);

    // Determine label font size based on Figma design
    // Most labels are 15.1px or 15.3px, some are 15.4px or 15.5px
    // Using 15.1px as base, but can be customized per field if needed
    final labelFontSize = 15.1.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w400, // Regular, not Medium (matches Figma)
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF364153),
              height: 24 / 15.1,
              letterSpacing: 0,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.errorTextDark
                            : const Color(0xFFFB2C36),
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 8.h),
        readOnly || effectiveController == null
            ? Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 17.w,
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.inputBgDark
                      : Colors.white, // Exact Figma fill color
                  border: Border.all(
                    color: isDark
                        ? AppColors.inputBorderDark
                        : const Color(0xFFD1D5DC), // Exact Figma border color
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  value ?? '',
                  style: TextStyle(
                    fontSize: 15.6.sp, // Matches Figma text size
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF0A0A0A),
                    height: 24 / 15.6,
                    letterSpacing: 0,
                  ),
                  textDirection: textDirection,
                ),
              )
            : TextField(
                controller: effectiveController,
                onChanged: onChanged,
                keyboardType: keyboardType,
                maxLines: maxLines,
                textDirection: textDirection,
                style: TextStyle(
                  fontSize: 15.6.sp, // Matches Figma text size
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF0A0A0A),
                  height: 24 / 15.6,
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? AppColors.inputBgDark
                      : Colors.white, // Exact Figma fill color
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 15.6.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textPlaceholderDark
                        : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                    height: 24 / 15.6,
                    letterSpacing: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.inputBorderDark
                          : const Color(0xFFD1D5DC), // Exact Figma border color
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.inputBorderDark
                          : const Color(0xFFD1D5DC), // Exact Figma border color
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  contentPadding: EdgeInsetsDirectional.symmetric(
                    horizontal: 17.w, // Exact Figma padding
                    vertical: 9.h, // Exact Figma padding
                  ),
                ),
              ),
      ],
    );
  }
}

