import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.borderGreyDark : const Color(0xFFEAECF0),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: DigifyTextField.search(
              controller: searchController,
              hintText: 'Search shifts...',
              height: 40.h,
              borderRadius: 10.r,
              fillColor: isDark ? AppColors.inputBgDark : Colors.white,
              borderColor: isDark
                  ? AppColors.inputBorderDark
                  : const Color(0xFFD0D5DD),
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
          SizedBox(width: 16.w),

          // Action Buttons
          AppButton(
            onPressed: onCreateShift,
            label: 'Create Shift',
            icon: Icons.add,
            height: 40.h,
            width: null,
            borderRadius: BorderRadius.circular(10.r),
            backgroundColor: AppColors.shiftCreateButton,
            foregroundColor: Colors.white,
            fontSize: 14.sp,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          SizedBox(width: 16.w),

          AppButton(
            onPressed: onUpload,
            label: 'Upload',
            svgPath: 'assets/icons/bulk_upload_icon_figma.svg',
            height: 40.h,
            width: null,
            borderRadius: BorderRadius.circular(10.r),
            backgroundColor: AppColors.shiftUploadButton,
            foregroundColor: Colors.white,
            fontSize: 14.sp,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          SizedBox(width: 16.w),

          AppButton(
            onPressed: onExport,
            label: 'Export',
            svgPath: 'assets/icons/download_icon.svg',
            height: 40.h,
            width: null,
            borderRadius: BorderRadius.circular(10.r),
            backgroundColor: AppColors.shiftExportButton,
            foregroundColor: Colors.white,
            fontSize: 14.sp,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        ],
      ),
    );
  }
}
