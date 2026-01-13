import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/feedback/shimmer_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Common widget for selecting an enterprise with engaging visual feedback
class EnterpriseSelectorWidget extends ConsumerWidget {
  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final String? subtitle;

  const EnterpriseSelectorWidget({
    super.key,
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesState = ref.watch(enterprisesProvider);
    final isDark = context.isDark;
    final selectedEnterprise = enterprisesState.findEnterpriseById(selectedEnterpriseId);
    final hasSelection = selectedEnterprise != null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.business, size: 20.sp, color: AppColors.primary),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enterprise Selection',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      Gap(2.h),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Gap(16.h),
          if (enterprisesState.isLoading)
            ShimmerWidget(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            )
          else
            DigifySelectField<Enterprise>(
              label: 'Select Enterprise',
              isRequired: true,
              hint: 'Select enterprise',
              items: enterprisesState.enterprises,
              itemLabelBuilder: (e) => e.name,
              value: selectedEnterprise,
              onChanged: (e) => onEnterpriseChanged(e?.id),
            ),
          if (hasSelection) ...[
            Gap(12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.primary, size: 18.sp),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'Selected: ${selectedEnterprise.name}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
