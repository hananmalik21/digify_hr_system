import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForfeitRulesSection extends StatelessWidget {
  final bool isDark;
  final ForfeitRules forfeit;
  final String carryForwardLimit;
  final String gracePeriod;
  final bool isEditing;

  const ForfeitRulesSection({
    super.key,
    required this.isDark,
    required this.forfeit,
    required this.carryForwardLimit,
    required this.gracePeriod,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Forfeit Rules',
      iconPath: Assets.icons.leaveManagement.warning.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                DigifyCheckbox(
                  value: forfeit.enableAutomaticForfeit,
                  onChanged: isEditing ? (_) {} : null,
                  label: 'Enable Automatic Forfeit',
                ),
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: Text(
                    'Automatically forfeit unused leave exceeding carry forward limit',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.warningBgDark.withValues(alpha: 0.2) : AppColors.warningBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.warningBorderDark : AppColors.warningBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 7.h,
              children: [
                Text(
                  'Forfeit Configuration',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.warningTextDark : AppColors.yellowText,
                  ),
                ),
                Text(
                  'Leave days exceeding the carry forward limit of $carryForwardLimit days will be automatically forfeited after the grace period of $gracePeriod days.',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: isDark ? AppColors.warningTextDark : AppColors.yellowText,
                  ),
                ),
                Row(
                  spacing: 24.w,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.h,
                        children: [
                          Text(
                            'Forfeit Trigger',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.warningTextDark.withValues(alpha: 0.8)
                                  : AppColors.yellowText.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            forfeit.forfeitTrigger ?? 'End of Grace Period',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: isDark ? AppColors.warningTextDark : AppColors.yellowText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.h,
                        children: [
                          Text(
                            'Notification Period',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.warningTextDark.withValues(alpha: 0.8)
                                  : AppColors.yellowText.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            forfeit.endOfGracePeriod.isNotEmpty ? forfeit.endOfGracePeriod : '30 days before',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: isDark ? AppColors.warningTextDark : AppColors.yellowText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
