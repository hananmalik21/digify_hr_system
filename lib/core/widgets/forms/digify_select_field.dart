import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
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

  final Color? fillColor;

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
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveFillColor = fillColor ?? (isDark ? AppColors.inputBgDark : Colors.transparent);
    final effectiveBorderColor = isDark ? AppColors.inputBorderDark : AppColors.inputBorder;
    final effectiveTextColor = isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final effectiveHintColor = isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5);

    return SizedBox(
      height: 48.h,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Text(
            hint ?? 'Select an option',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveHintColor),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabelBuilder(item),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveTextColor),
                  ),
                ),
              )
              .toList(),
          value: value,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            height: 40.h,
            padding: EdgeInsets.only(left: 4.w, right: 12.w),
            decoration: BoxDecoration(
              color: effectiveFillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: effectiveBorderColor, width: 1.0.w),
            ),
          ),

          iconStyleData: IconStyleData(
            icon: DigifyAsset(
              assetPath: Assets.icons.workforce.chevronDown.path,
              height: 20,
              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
            iconSize: 24.sp,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              boxShadow: AppShadows.primaryShadow,
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
    );
  }
}
