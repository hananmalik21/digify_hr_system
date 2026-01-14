import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const LeaveFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final filters = [
      {'key': 'all', 'label': localizations.all},
      {'key': 'pending', 'label': localizations.tmFilterPending},
      {'key': 'approved', 'label': localizations.tmFilterApproved},
      {'key': 'rejected', 'label': localizations.tmFilterRejected},
    ];

    return Row(
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter['key'];
        return Padding(
          padding: EdgeInsetsDirectional.only(end: 8.w),
          child: _FilterTabButton(
            label: filter['label']!,
            isSelected: isSelected,
            onTap: () => onFilterChanged(filter['key']!),
            isDark: isDark,
          ),
        );
      }).toList(),
    );
  }
}

class _FilterTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.cardBackgroundDark : Colors.white),
            border: isSelected
                ? null
                : Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
                    width: 1,
                  ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSelected ? 15.6.sp : 15.4.sp,
              fontWeight: FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
              height: 24 / (isSelected ? 15.6 : 15.4),
            ),
          ),
        ),
      ),
    );
  }
}
