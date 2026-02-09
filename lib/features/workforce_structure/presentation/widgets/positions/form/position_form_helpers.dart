import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionFormHelpers {
  static Widget buildDropdownField<T>({
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemLabelProvider,
    String? hint,
  }) {
    return DigifySelectField<T>(
      label: '',
      value: value,
      items: items,
      onChanged: onChanged,
      itemLabelBuilder: (item) => itemLabelProvider?.call(item) ?? item.toString(),
      hint: hint,
    );
  }

  static Widget buildFormField({
    required TextEditingController controller,
    String? hint,
    TextDirection? textDirection,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return DigifyTextField.normal(
      controller: controller,
      hintText: hint,
      textDirection: textDirection,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      textAlign: textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
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
