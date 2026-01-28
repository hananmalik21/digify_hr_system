import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/label_value_pair.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyDetailsHeader extends StatelessWidget {
  final String policyName;
  final String policyNameArabic;
  final String lastModified;
  final String selectedBy;
  final bool isEditing;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onSavePressed;
  final bool isDark;

  const PolicyDetailsHeader({
    super.key,
    required this.policyName,
    required this.policyNameArabic,
    required this.lastModified,
    required this.selectedBy,
    this.isEditing = false,
    this.onEditPressed,
    this.onCancelPressed,
    this.onSavePressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policyName,
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      policyNameArabic,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.shiftExportButton,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    Gap(14.h),
                    Row(
                      spacing: 24.w,
                      children: [
                        LabelValuePair(label: 'Last Modified', value: lastModified, isDark: isDark),
                        LabelValuePair(label: 'Modified By', value: selectedBy, isDark: isDark),
                      ],
                    ),
                  ],
                ),
              ),
              if (isEditing) ...[
                AppButton.outline(label: 'Cancel', onPressed: onCancelPressed),
                Gap(7.w),
                AppButton.primary(label: 'Save', svgPath: Assets.icons.saveConfigIcon.path, onPressed: onSavePressed),
              ] else
                AppButton.primary(
                  label: 'Edit Policy',
                  svgPath: Assets.icons.editIconGreen.path,
                  onPressed: onEditPressed,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
