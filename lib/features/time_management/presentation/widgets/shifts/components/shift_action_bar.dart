import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/buttons/export_button.dart';
import 'package:digify_hr_system/core/widgets/buttons/import_button.dart';
import 'package:digify_hr_system/core/widgets/forms/custom_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/filter_pill_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftActionBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onCreateShift;
  final VoidCallback onUpload;
  final VoidCallback onExport;

  const ShiftActionBar({
    super.key,
    required this.searchController,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onCreateShift,
    required this.onUpload,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        // Search Field
        Expanded(
          flex: 3,
          child: CustomTextField.search(
            controller: searchController,
            hintText: 'Search shifts...',
          ),
        ),
        SizedBox(width: 16.w),

        // Status Filter
        FilterPillDropdown(
          value: selectedStatus,
          items: const ['All Status', 'Active', 'Inactive'],
          onChanged: onStatusChanged,
          isDark: isDark,
        ),
        const Spacer(),

        // Action Buttons
        AppButton.primary(
          onPressed: onCreateShift,
          label: 'Create Shift',
          icon: Icons.add,
        ),
        SizedBox(width: 12.w),
        ImportButton(onTap: onUpload, customLabel: 'Upload'),
        SizedBox(width: 12.w),
        ExportButton(onTap: onExport, customLabel: 'Export'),
      ],
    );
  }
}
