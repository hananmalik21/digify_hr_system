import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWelcomeSection extends StatelessWidget {
  const HeaderWelcomeSection({super.key, required this.localizations, required this.isTablet, required this.isDark});

  final AppLocalizations localizations;
  final bool isTablet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final hint = '${localizations.search}...';

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w),
        child: TextField(
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontSize: isTablet ? 14.sp : 15.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: isTablet ? 14.sp : 15.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
            ),
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 6.w),
              child: Icon(
                Icons.search_rounded,
                size: 18.sp,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.only(end: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: Text(
                  '⌘ K',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE2E8F0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ),
    );
  }
}
