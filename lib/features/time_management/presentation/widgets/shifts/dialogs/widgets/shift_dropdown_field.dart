import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isDark;
  final bool isRequired;

  const ShiftDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDark,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4.w),
              Text(
                '*',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.error),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
          ),
          dropdownColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
          icon: Icon(Icons.keyboard_arrow_down, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
        ),
      ],
    );
  }
}
