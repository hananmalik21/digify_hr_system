import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/employee_management/presentation/models/employee_detail_display_data.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_chip.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'employee_detail_summary_cards.dart';

class EmployeeDetailHeader extends StatelessWidget {
  const EmployeeDetailHeader({super.key, required this.displayData, required this.isDark, this.onEditPressed});

  final EmployeeDetailDisplayData displayData;
  final bool isDark;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
              Gap(24.w),
              Expanded(
                child: Text(
                  displayData.displayName,
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: textPrimary),
                ),
              ),
              AppButton.outline(label: 'Download PDF', svgPath: Assets.icons.downloadIcon.path, onPressed: () {}),
              Gap(8.w),
              AppButton.primary(label: 'Edit Profile', svgPath: Assets.icons.editIcon.path, onPressed: onEditPressed),
            ],
          ),
          Gap(8.h),
          Row(
            spacing: 16.w,
            children: [
              Gap(18.w),
              EmployeeDetailChip(
                path: Assets.icons.deiDashboardIcon.path,
                label: displayData.positionLabel,
                isDark: isDark,
              ),
              EmployeeDetailChip(
                path: Assets.icons.departmentsIcon.path,
                label: displayData.departmentLabel,
                isDark: isDark,
              ),
              EmployeeDetailChip(
                path: Assets.icons.employeeManagement.hash.path,
                label: displayData.employeeNumber,
                isDark: isDark,
              ),
            ],
          ),
          Gap(24.h),
          EmployeeDetailSummaryCards(displayData: displayData, isDark: isDark),
        ],
      ),
    );
  }
}
