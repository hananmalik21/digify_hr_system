import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:flutter/material.dart';

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
    return DigifySelectFieldWithLabel<String>(
      label: label,
      hint: hintText,
      value: (value != null && items.contains(value)) ? value : null,
      items: items,
      itemLabelBuilder: (item) => item,
      onChanged: onChanged,
      isRequired: isRequired,
    );
  }
}
