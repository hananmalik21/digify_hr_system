import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/add_position_button.dart';
import 'package:digify_hr_system/core/widgets/export_button.dart';
import 'package:digify_hr_system/core/widgets/import_button.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceSearchAndActions extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback onAddPosition;

  const WorkforceSearchAndActions({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.onAddPosition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildSearchField(context, ref),
          _buildOptionChip(
            width: 200.w,
            label: localizations.allDepartments,
            isDark: isDark,
          ),
          _buildOptionChip(
            width: 150.w,
            label: localizations.allStatus,
            isDark: isDark,
          ),
          AddButton(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            onTap: onAddPosition,
          ),
          ImportButton(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            backgroundColor: AppColors.greenButton,
            textColor: Colors.white,
            onTap: () {},
          ),
          ExportButton(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            backgroundColor: const Color(0xFF4A5565),
            textColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 520.w,
      child: TextField(
        onChanged: (value) {
          ref.read(positionSearchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.2,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
            child: SvgIconWidget(
              assetPath: 'assets/icons/search_icon.svg',
              size: 20.sp,
              color: AppColors.textMuted,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          hintText: localizations.searchPositionsPlaceholder,
          hintStyle: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPlaceholder,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 12.w,
          ),
        ),
        style: TextStyle(
          fontSize: 15.3.sp,
          fontWeight: FontWeight.w400,
          color: context.themeTextPrimary,
        ),
      ),
    );
  }

  Widget _buildOptionChip({
    required String label,
    required bool isDark,
    double? width,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
        ),
        color: isDark ? AppColors.inputBgDark : Colors.white,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            height: 19 / 15.3,
          ),
        ),
      ),
    );
  }
}
