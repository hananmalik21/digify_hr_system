import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseStructureDropdown extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? hintText;

  const EnterpriseStructureDropdown({
    super.key,
    required this.label,
    this.isRequired = false,
    this.value,
    required this.items,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 15.1.sp, // Matches Figma
              fontWeight: FontWeight.w400,
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
        SizedBox(
          height: 42.h, // Match text field height exactly (9*2 vertical padding + 24 text height)
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 17.w, // Match text field padding
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: (value != null && items.contains(value)) ? value : null,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF0A0A0A),
                  size: 20.sp,
                ),
                iconSize: 20.sp,
                style: TextStyle(
                  fontSize: 15.6.sp, // Match text field font size
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF0A0A0A),
                  height: 24 / 15.6, // Match text field line height
                  letterSpacing: 0,
                ),
                dropdownColor: isDark
                    ? AppColors.inputBgDark
                    : Colors.white, // Exact Figma fill color
                hint: hintText != null
                    ? Text(
                        hintText!,
                        style: TextStyle(
                          fontSize: 15.6.sp, // Match text field hint font size
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textPlaceholderDark
                              : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          height: 24 / 15.6, // Match text field hint line height
                          letterSpacing: 0,
                        ),
                      )
                    : null,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

