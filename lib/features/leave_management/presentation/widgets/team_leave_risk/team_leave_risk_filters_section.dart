import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TeamLeaveRiskFiltersSection extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const TeamLeaveRiskFiltersSection({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 17.5.sp,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
              ),
              Gap(7.w),
              Text(
                '${localizations.filters}:',
                style: TextStyle(
                  fontSize: 13.9.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                  height: 21 / 13.9,
                  letterSpacing: 0,
                ),
              ),
              Gap(14.w),
              _FilterDropdown(label: localizations.allDepartments, isDark: isDark),
              Gap(14.w),
              _FilterDropdown(label: localizations.allLeaveTypes, isDark: isDark),
            ],
          ),
          const Spacer(),
          AppButton.primary(label: localizations.exportReport, icon: Icons.download, onPressed: () {}),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final bool isDark;

  const _FilterDropdown({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 19.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.7.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
          height: 16.5 / 13.7,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
