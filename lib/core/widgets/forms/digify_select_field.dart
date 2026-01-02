import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifySelectField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final String? Function(T?)? validator;
  final double? height;
  final double? borderRadius;

  const DigifySelectField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    this.hint,
    this.value,
    this.onChanged,
    this.isRequired = false,
    this.validator,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveHeight = height ?? 40.h;
    final effectiveRadius = borderRadius ?? 10.r;

    // Colors matching DigifyTextField
    final effectiveFillColor = isDark ? AppColors.inputBgDark : AppColors.inputBg;
    final effectiveBorderColor = isDark ? AppColors.inputBorderDark : AppColors.inputBorder;
    final effectiveTextColor = isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final effectiveHintColor = isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5);

    final Widget labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 13.8,
            color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
          ),
        ),
        if (isRequired) ...[
          SizedBox(width: 4.w),
          Text(
            '*',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 13.8,
              color: AppColors.deleteIconRed,
            ),
          ),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        labelWidget,
        SizedBox(height: 8.h),
        SizedBox(
          height: effectiveHeight,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              hint: Text(
                hint ?? 'Select an option',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: effectiveHintColor,
                ),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        itemLabelBuilder(item),
                        style: TextStyle(fontFamily: 'Inter', fontSize: 15.sp, color: effectiveTextColor),
                      ),
                    ),
                  )
                  .toList(),
              value: value,
              onChanged: onChanged,
              buttonStyleData: ButtonStyleData(
                height: effectiveHeight,
                padding: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                  color: effectiveFillColor,
                  borderRadius: BorderRadius.circular(effectiveRadius),
                  border: Border.all(color: effectiveBorderColor),
                ),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                ),
                iconSize: 24.sp,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(10.r),
                  thickness: WidgetStateProperty.all(6),
                  thumbVisibility: WidgetStateProperty.all(true),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
