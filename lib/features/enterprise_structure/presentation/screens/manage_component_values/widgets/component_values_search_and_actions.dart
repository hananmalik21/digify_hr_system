import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesSearchAndActions extends StatelessWidget {
  const ComponentValuesSearchAndActions({
    super.key,
    required this.isDark,
    required this.searchHint,
    required this.searchValue,
    required this.onSearchChanged,
    required this.addNewLabel,
    required this.bulkUploadLabel,
    required this.exportLabel,
    required this.onAddNew,
    required this.onBulkUpload,
    required this.onExport,
  });

  final bool isDark;
  final String searchHint;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final String addNewLabel;
  final String bulkUploadLabel;
  final String exportLabel;
  final VoidCallback onAddNew;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ComponentValuesSearchFieldControlled(
            isDark: isDark,
            hint: searchHint,
            value: searchValue,
            onChanged: onSearchChanged,
          ),
          Gap(12.h),
          _ActionButtons(
            isDark: isDark,
            addNewLabel: addNewLabel,
            bulkUploadLabel: bulkUploadLabel,
            exportLabel: exportLabel,
            onAddNew: onAddNew,
            onBulkUpload: onBulkUpload,
            onExport: onExport,
            isMobile: true,
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ComponentValuesSearchFieldControlled(
            isDark: isDark,
            hint: searchHint,
            value: searchValue,
            onChanged: onSearchChanged,
          ),
        ),
        Gap(16.w),
        _ActionButtons(
          isDark: isDark,
          addNewLabel: addNewLabel,
          bulkUploadLabel: bulkUploadLabel,
          exportLabel: exportLabel,
          onAddNew: onAddNew,
          onBulkUpload: onBulkUpload,
          onExport: onExport,
          isMobile: false,
        ),
      ],
    );
  }
}

class ComponentValuesSearchFieldControlled extends StatefulWidget {
  const ComponentValuesSearchFieldControlled({
    super.key,
    required this.isDark,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  final bool isDark;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<ComponentValuesSearchFieldControlled> createState() => _ComponentValuesSearchFieldControlledState();
}

class _ComponentValuesSearchFieldControlledState extends State<ComponentValuesSearchFieldControlled> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(ComponentValuesSearchFieldControlled oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final fieldHeight = isMobile ? 44.h : (isTablet ? 42.h : 40.h);
    final fontSize = isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp);
    final iconSize = isMobile ? 18.sp : (isTablet ? 17.sp : 16.sp);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 14.w : 16.w);
    final iconPadding = isMobile ? 10.w : (isTablet ? 11.w : 12.w);

    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: widget.isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.all(iconPadding),
            child: DigifyAsset(
              assetPath: Assets.icons.searchIcon.path,
              width: iconSize,
              height: iconSize,
              color: widget.isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsetsDirectional.symmetric(
            horizontal: horizontalPadding,
            vertical: isMobile ? 14.h : (isTablet ? 13.h : 12.h),
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isDark,
    required this.addNewLabel,
    required this.bulkUploadLabel,
    required this.exportLabel,
    required this.onAddNew,
    required this.onBulkUpload,
    required this.onExport,
    required this.isMobile,
  });

  final bool isDark;
  final String addNewLabel;
  final String bulkUploadLabel;
  final String exportLabel;
  final VoidCallback onAddNew;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ActionButton(
            label: addNewLabel,
            icon: 'assets/icons/add_new_icon_figma.svg',
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            onTap: onAddNew,
          ),
          Gap(8.h),
          _ActionButton(
            label: bulkUploadLabel,
            icon: 'assets/icons/bulk_upload_icon_figma.svg',
            backgroundColor: const Color(0xFF00A63E),
            textColor: Colors.white,
            onTap: onBulkUpload,
          ),
          Gap(8.h),
          _ActionButton(
            label: exportLabel,
            icon: 'assets/icons/download_icon.svg',
            backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFF4A5565),
            textColor: Colors.white,
            onTap: onExport,
          ),
        ],
      );
    }
    return Row(
      children: [
        _ActionButton(
          label: addNewLabel,
          icon: 'assets/icons/add_new_icon_figma.svg',
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          onTap: onAddNew,
        ),
        Gap(12.w),
        _ActionButton(
          label: bulkUploadLabel,
          icon: 'assets/icons/bulk_upload_icon_figma.svg',
          backgroundColor: const Color(0xFF00A63E),
          textColor: Colors.white,
          onTap: onBulkUpload,
        ),
        Gap(12.w),
        _ActionButton(
          label: exportLabel,
          icon: 'assets/icons/download_icon.svg',
          backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFF4A5565),
          textColor: Colors.white,
          onTap: onExport,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: icon, width: 20, height: 20, color: textColor),
              Gap(8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
