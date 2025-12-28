import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionFormHelpers {
  static Widget buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemLabelProvider,
    bool isRequired = true,
    String? hint,
  }) {
    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        hint: hint != null
            ? Text(
                hint,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              )
            : null,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabelProvider?.call(item) ?? item.toString(),
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
        ),
        validator: isRequired
            ? (value) => value == null ? '$label is required' : null
            : null,
      ),
    );
  }

  static Widget buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isRequired = true,
    TextDirection? textDirection,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: TextFormField(
        controller: controller,
        textDirection: textDirection,
        readOnly: readOnly,
        enabled: enabled,
        textAlign: textDirection == TextDirection.rtl
            ? TextAlign.right
            : TextAlign.left,
        style: TextStyle(
          color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : AppColors.background,
          hintText: hint ?? label,
          hintTextDirection: textDirection,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
        ),
        validator: isRequired
            ? (value) => (value ?? '').isEmpty ? '$label is required' : null
            : null,
      ),
    );
  }

  static Widget buildStatusSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    FontWeight? fontWeight,
  }) {
    return PositionLabeledField(
      label: label,
      fontWeight: fontWeight,
      child: Container(
        height: 48.h,
        alignment: Alignment.centerLeft,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.background,
          activeTrackColor: AppColors.success,
        ),
      ),
    );
  }
}
