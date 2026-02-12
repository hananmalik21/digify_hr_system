import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/employee_leave_stats.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/employee_leave_stats_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeDetailLeaveStatsCards extends ConsumerWidget {
  const EmployeeDetailLeaveStatsCards({
    super.key,
    required this.employeeGuid,
    required this.isDark,
    required this.localizations,
  });

  final String employeeGuid;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(employeeLeaveStatsProvider(employeeGuid));

    return statsAsync.when(
      data: (stats) => _buildCardsRow(context, stats: stats),
      loading: () => Skeletonizer(enabled: true, child: _buildCardsRow(context)),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCardsRow(BuildContext context, {EmployeeLeaveStats? stats}) {
    final cards = [
      _EmployeeLeaveStatCard(
        label: localizations.totalRequests,
        value: stats?.totalDisplay ?? '0',
        iconPath: Assets.icons.calendarIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.infoBg,
        iconColor: AppColors.statIconBlue,
      ),
      _EmployeeLeaveStatCard(
        label: localizations.leaveFilterApproved,
        value: stats?.approvedDisplay ?? '0',
        iconPath: Assets.icons.checkIconGreen.path,
        isDark: isDark,
        iconBgColor: AppColors.successBg,
        iconColor: AppColors.success,
      ),
      _EmployeeLeaveStatCard(
        label: localizations.leaveFilterPending,
        value: stats?.pendingDisplay ?? '0',
        iconPath: Assets.icons.clockIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.warningBg,
        iconColor: AppColors.warning,
      ),
      _EmployeeLeaveStatCard(
        label: localizations.rejected,
        value: stats?.rejectedDisplay ?? '0',
        iconPath: Assets.icons.closeIcon.path,
        isDark: isDark,
        iconBgColor: AppColors.errorBg,
        iconColor: AppColors.error,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 21.w : 0),
              child: cards[i],
            ),
          ),
      ],
    );
  }
}

class _EmployeeLeaveStatCard extends StatelessWidget {
  const _EmployeeLeaveStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconBgColor,
    required this.iconColor,
  });

  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
                Gap(7.h),
                Text(
                  value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 21, height: 21),
          ),
        ],
      ),
    );
  }
}
