import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceStatsCards extends StatelessWidget {
  final AppLocalizations localizations;
  final WorkforceStats stats;
  final bool isDark;

  const WorkforceStatsCards({
    super.key,
    required this.localizations,
    required this.stats,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            label: localizations.totalPositions,
            value: '${stats.totalPositions}',
            iconPath: 'assets/icons/stat_positions_icon.svg',
            valueColor: const Color(0xFF155DFC),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            context,
            label: localizations.filledPositions,
            value: '${stats.filledPositions}',
            iconPath: 'assets/icons/stat_filled_icon.svg',
            valueColor: const Color(0xFF10B981),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            context,
            label: localizations.vacantPositions,
            value: '${stats.vacantPositions}',
            iconPath: 'assets/icons/stat_vacant_icon.svg',
            valueColor: const Color(0xFFF59E0B),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String iconPath,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  height: 20 / 13.7,
                ),
              ),
              SvgIconWidget(assetPath: iconPath, size: 20.sp),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 27.3.sp,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 36 / 27.3,
            ),
          ),
        ],
      ),
    );
  }
}
