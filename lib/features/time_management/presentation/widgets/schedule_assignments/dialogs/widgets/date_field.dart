import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const DateField({super.key, required this.label, required this.controller, required this.onTap, this.validator});

  @override
  Widget build(BuildContext context) {
    return DigifyTextField(
      labelText: label,
      isRequired: true,
      controller: controller,
      readOnly: true,
      onTap: onTap,
      suffixIcon: DigifyAsset(assetPath: Assets.icons.calendarIcon.path, width: 20, height: 20),
      validator: validator,
    );
  }
}
