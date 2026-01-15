import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveFilterTabs extends ConsumerWidget {
  const LeaveFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedFilter = ref.watch(leaveFilterProvider);

    return Row(
      children: [
        _FilterTab(
          label: localizations.leaveFilterAll,
          isSelected: selectedFilter == LeaveFilter.all,
          onTap: () => ref.read(leaveFilterProvider.notifier).setFilter(LeaveFilter.all),
          isDark: isDark,
        ),
        SizedBox(width: 8.w),
        _FilterTab(
          label: localizations.leaveFilterPending,
          isSelected: selectedFilter == LeaveFilter.pending,
          onTap: () => ref.read(leaveFilterProvider.notifier).setFilter(LeaveFilter.pending),
          isDark: isDark,
        ),
        SizedBox(width: 8.w),
        _FilterTab(
          label: localizations.leaveFilterApproved,
          isSelected: selectedFilter == LeaveFilter.approved,
          onTap: () => ref.read(leaveFilterProvider.notifier).setFilter(LeaveFilter.approved),
          isDark: isDark,
        ),
        SizedBox(width: 8.w),
        _FilterTab(
          label: localizations.leaveFilterRejected,
          isSelected: selectedFilter == LeaveFilter.rejected,
          onTap: () => ref.read(leaveFilterProvider.notifier).setFilter(LeaveFilter.rejected),
          isDark: isDark,
        ),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
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
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            height: 24 / (isSelected ? 15.6 : 15.4),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
