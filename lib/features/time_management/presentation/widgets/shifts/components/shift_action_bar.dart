import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/filter_pill_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../gen/assets.gen.dart';

class ShiftActionBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onCreateShift;
  final VoidCallback onUpload;
  final VoidCallback onExport;

  const ShiftActionBar({
    super.key,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onCreateShift,
    required this.onUpload,
    required this.onExport,
  });

  @override
  State<ShiftActionBar> createState() => _ShiftActionBarState();
}

class _ShiftActionBarState extends State<ShiftActionBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsiveWidth(context, mobile: 16, tablet: 20, web: 20),
        vertical: ResponsiveHelper.getResponsiveHeight(context, mobile: 12, tablet: 17, web: 17),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.borderGreyDark : const Color(0xFFEAECF0)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DigifyTextField.search(
                  controller: _searchController,
                  hintText: 'Search shifts...',
                  height: 44.h,
                  borderRadius: 10.r,
                  fillColor: isDark ? AppColors.inputBgDark : Colors.white,
                  borderColor: isDark ? AppColors.inputBorderDark : const Color(0xFFD0D5DD),
                  onChanged: widget.onSearchChanged,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: FilterPillDropdown(
                        value: widget.selectedStatus,
                        items: const ['All Status', 'Active', 'Inactive'],
                        onChanged: widget.onStatusChanged,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildActionButton(context, onPressed: widget.onCreateShift, label: 'Create', icon: Icons.add),
                    _buildActionButton(
                      context,
                      onPressed: widget.onUpload,
                      label: 'Upload',
                      svgPath: 'assets/icons/bulk_upload_icon_figma.svg',
                    ),
                    _buildActionButton(
                      context,
                      onPressed: widget.onExport,
                      label: 'Export',
                      svgPath: 'assets/icons/download_icon.svg',
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: DigifyTextField.search(
                    controller: _searchController,
                    hintText: 'Search shifts...',
                    height: 40.h,
                    borderRadius: 10.r,
                    fillColor: isDark ? AppColors.inputBgDark : Colors.white,
                    borderColor: isDark ? AppColors.inputBorderDark : const Color(0xFFD0D5DD),
                    onChanged: widget.onSearchChanged,
                  ),
                ),
                SizedBox(width: 16.w),
                FilterPillDropdown(
                  value: widget.selectedStatus,
                  items: const ['All Status', 'Active', 'Inactive'],
                  onChanged: widget.onStatusChanged,
                  isDark: isDark,
                ),
                SizedBox(width: 16.w),
                AppButton(
                  onPressed: widget.onCreateShift,
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
                  onPressed: widget.onUpload,
                  label: 'Upload',
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
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
                  onPressed: widget.onExport,
                  label: 'Export',
                  svgPath: Assets.icons.downloadIcon.path,
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

  Widget _buildActionButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required String label,
    IconData? icon,
    String? svgPath,
  }) {
    return AppButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      svgPath: svgPath,
      height: 36.h,
      width: null,
      borderRadius: BorderRadius.circular(8.r),
      backgroundColor: label == 'Create'
          ? AppColors.shiftCreateButton
          : (label == 'Upload' ? AppColors.shiftUploadButton : AppColors.shiftExportButton),
      foregroundColor: Colors.white,
      fontSize: 12.sp,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }
}
