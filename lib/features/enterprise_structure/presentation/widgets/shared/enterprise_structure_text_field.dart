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

  const EnterpriseStructureTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.value,
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveController = controller ?? (value != null ? TextEditingController(text: value) : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF364153),
              height: 20 / 13.8,
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
                      : AppColors.inputBg,
                  border: Border.all(
                    color: isDark
                        ? AppColors.inputBorderDark
                        : AppColors.inputBorder,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  value ?? '',
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF0A0A0A),
                    height: 24 / 15.3,
                    letterSpacing: 0,
                  ),
                ),
              )
            : TextField(
                controller: effectiveController,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF0A0A0A),
                  height: 24 / 15.3,
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? AppColors.inputBgDark
                      : AppColors.inputBg,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textPlaceholderDark
                        : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                    height: 24 / 15.3,
                    letterSpacing: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.inputBorderDark
                          : AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.inputBorderDark
                          : AppColors.inputBorder,
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
                    horizontal: 17.w,
                    vertical: 9.h,
                  ),
                ),
              ),
      ],
    );
  }
}

