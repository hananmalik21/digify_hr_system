import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompensationTotalSummaryModule extends StatelessWidget {
  const CompensationTotalSummaryModule({super.key, this.monthlyTotal = '0.000', this.annualTotal = '0.000'});

  final String monthlyTotal;
  final String annualTotal;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final summaryBg = isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.infoBg;
    final labelColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.infoTextSecondary;
    final annualColor = isDark ? AppColors.textSecondaryDark : AppColors.primary;
    final iconBg = AppColors.primary.withValues(alpha: 0.15);
    final iconColor = AppColors.primary;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: summaryBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.primary.withValues(alpha: 0.3) : AppColors.infoBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4.h,
              children: [
                Text(
                  localizations.totalMonthlyCompensation,
                  style: context.textTheme.labelSmall?.copyWith(color: labelColor, fontSize: 12.sp),
                ),
                Text('$monthlyTotal KWD', style: context.textTheme.headlineMedium?.copyWith(color: valueColor)),
                Text(
                  localizations.annualKwd(annualTotal),
                  style: context.textTheme.labelSmall?.copyWith(color: annualColor, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: Assets.icons.leaveManagement.dollar.path,
              width: 32,
              height: 32,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
