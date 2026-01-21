import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitRulesSection extends StatelessWidget {
  final bool isDark;
  final ForfeitRules forfeit;

  const ForfeitRulesSection({super.key, required this.isDark, required this.forfeit});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Forfeit Rules',
      iconPath: Assets.icons.leaveManagement.forfeitPolicy.path,
      warningBackgroundColor: isDark ? AppColors.warningBgDark.withValues(alpha: 0.2) : AppColors.warningBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.warningBgDark.withValues(alpha: 0.2) : AppColors.warningBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20.sp),
                Gap(8.w),
                Expanded(
                  child: Row(
                    children: [
                      Switch(
                        value: forfeit.enableAutomaticForfeit,
                        onChanged: null,
                        activeThumbColor: AppColors.primary,
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          'Enable Automatic Forfeit',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Forfeit Configuration',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Text(
            'Leave days will be automatically forfeited based on the configured rules',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Forfeit Trigger',
                  items: ['End of Year', 'End of Grace Period'],
                  itemLabelBuilder: (item) => item,
                  value: forfeit.forfeitTrigger,
                  onChanged: null,
                ),
              ),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'End of Grace Period',
                  items: ['28 days before', 'End of year'],
                  itemLabelBuilder: (item) => item,
                  value: forfeit.endOfGracePeriod,
                  onChanged: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
