import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/compact_digify_dropdown.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublicHolidaysActionBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedYear;
  final String selectedType;
  final List<String> availableYears;
  final List<String> availableTypes;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddHoliday;
  final VoidCallback onImport;
  final VoidCallback onExport;

  const PublicHolidaysActionBar({
    super.key,
    required this.searchController,
    required this.selectedYear,
    required this.selectedType,
    required this.availableYears,
    required this.availableTypes,
    required this.onYearChanged,
    required this.onTypeChanged,
    required this.onSearchChanged,
    required this.onAddHoliday,
    required this.onImport,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 4), blurRadius: 10)],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchField(context),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(child: _buildYearDropdown(context)),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildTypeDropdown(context)),
                  ],
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [_buildAddButton(context), _buildImportButton(context), _buildExportButton(context)],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: _buildSearchField(context)),
                SizedBox(width: 12.w),
                _buildYearDropdown(context),
                SizedBox(width: 12.w),
                _buildTypeDropdown(context),
                SizedBox(width: 12.w),
                _buildAddButton(context),
                SizedBox(width: 12.w),
                _buildImportButton(context),
                SizedBox(width: 12.w),
                _buildExportButton(context),
              ],
            ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return DigifyTextField.search(
      controller: searchController,
      hintText: 'Search holidays by name or Arabic name...',
      onChanged: onSearchChanged,
    );
  }

  Widget _buildYearDropdown(BuildContext context) {
    return CompactDigifyDropdown<String>(
      value: selectedYear,
      items: availableYears,
      itemLabelBuilder: (year) => year,
      hint: 'Year',
      onChanged: onYearChanged,
      height: 40.h,
      width: 120.w,
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return CompactDigifyDropdown<String>(
      value: selectedType,
      items: availableTypes,
      itemLabelBuilder: (type) => type,
      hint: 'Type',
      onChanged: onTypeChanged,
      height: 40.h,
      width: 120.w,
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return AppButton(
      onPressed: onAddHoliday,
      label: 'Add Holiday',
      icon: Icons.add,
      height: 40.h,
      width: null,
      borderRadius: BorderRadius.circular(10.r),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.buttonTextLight,
      fontSize: 15.1.sp,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  Widget _buildImportButton(BuildContext context) {
    return AppButton(
      onPressed: onImport,
      label: 'Import',
      svgPath: Assets.icons.bulkUploadIconFigma.path,
      height: 40.h,
      width: null,
      borderRadius: BorderRadius.circular(10.r),
      backgroundColor: AppColors.greenButton,
      foregroundColor: AppColors.buttonTextLight,
      fontSize: 15.4.sp,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return AppButton(
      onPressed: onExport,
      label: 'Export',
      svgPath: Assets.icons.downloadIcon.path,
      height: 40.h,
      width: null,
      borderRadius: BorderRadius.circular(10.r),
      backgroundColor: AppColors.textSecondary,
      foregroundColor: AppColors.buttonTextLight,
      fontSize: 15.1.sp,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}
