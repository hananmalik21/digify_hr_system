import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalancesSummaryCards extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalancesSummaryCards({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return _buildGridView(context);
  }

  Widget _buildGridView(BuildContext context) {
    final crossAxisCount = context.isMobile ? 1 : (context.isTablet ? 2 : 4);
    final aspectRatio = context.isMobile ? 3.6 : (context.isTablet ? 2.2 : 2.5);
    final spacing = 14.w;

    final cards = _getCardConfigs().map((config) {
      return _buildStatCard(
        context,
        label: config.label,
        value: config.value,
        iconPath: config.iconPath,
        color: config.color,
      );
    }).toList();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 14.h,
      crossAxisSpacing: spacing,
      childAspectRatio: aspectRatio,
      children: cards,
    );
  }

  List<_CardConfig> _getCardConfigs() {
    return [
      _CardConfig(
        label: localizations.totalEmployees,
        value: '3',
        iconPath: Assets.icons.employeesBlueIcon.path,
        color: AppColors.primary,
      ),
      _CardConfig(
        label: 'Avg Annual Leave',
        value: '27.7 days',
        iconPath: Assets.icons.leaveManagement.emptyLeave.path,
        color: AppColors.greenButton,
      ),
      _CardConfig(
        label: 'Avg Sick Leave',
        value: '15.0 days',
        iconPath: Assets.icons.workforce.fillRate.path,
        color: AppColors.statIconPurple,
      ),
      _CardConfig(
        label: 'Low Balance Alerts',
        value: '0',
        iconPath: Assets.icons.warningIcon.path,
        color: AppColors.informationIconColor,
      ),
    ];
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String iconPath,
    required Color color,
  }) {
    final isDark = context.isDark;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.sidebarChildItemText,
                  ),
                ),
                Gap(4.h),
                Text(
                  value,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          DigifyAsset(assetPath: iconPath, width: 24.sp, height: 24.sp, color: color),
        ],
      ),
    );
  }
}

class _CardConfig {
  final String label;
  final String value;
  final String iconPath;
  final Color color;

  const _CardConfig({required this.label, required this.value, required this.iconPath, required this.color});
}
