import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeGridCard extends StatelessWidget {
  final EmployeeListItem employee;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onView;
  final VoidCallback? onMore;

  const EmployeeGridCard({
    super.key,
    required this.employee,
    required this.localizations,
    required this.isDark,
    this.onView,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final iconColor = AppColors.statIconBlue;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: 1.w),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                image: null,
                fallbackInitial: employee.fullName,
                size: 48.w,
                backgroundColor: AppColors.infoBg,
                textColor: iconColor,
                showStatusDot: false,
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      employee.fullName.toUpperCase(),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      employee.employeeId,
                      style: textTheme.bodySmall?.copyWith(color: secondaryColor, fontSize: 12.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              DigifyAssetButton(
                assetPath: Assets.icons.employeeManagement.more.path,
                onTap: onMore,
                width: 20,
                height: 20,
                padding: 4.w,
                color: secondaryColor,
              ),
            ],
          ),
          Gap(16.h),
          if (employee.position.isNotEmpty ||
              employee.department.isNotEmpty ||
              (employee.email != null && employee.email!.isNotEmpty) ||
              (employee.phone != null && employee.phone!.isNotEmpty)) ...[
            _DetailRow(
              iconPath: Assets.icons.positionsIcon.path,
              label: employee.position.isNotEmpty ? employee.position : '—',
              iconColor: iconColor,
              textColor: titleColor,
              textTheme: textTheme,
            ),
            Gap(8.h),
            _DetailRow(
              iconPath: Assets.icons.departmentsIcon.path,
              label: employee.department.isNotEmpty ? employee.department.toUpperCase() : '—',
              iconColor: iconColor,
              textColor: titleColor,
              textTheme: textTheme,
            ),
            if (employee.email != null && employee.email!.trim().isNotEmpty) ...[
              Gap(8.h),
              _DetailRow(
                iconPath: Assets.icons.emailIcon.path,
                label: employee.email!,
                iconColor: iconColor,
                textColor: titleColor,
                textTheme: textTheme,
              ),
            ],
            if (employee.phone != null && employee.phone!.trim().isNotEmpty) ...[
              Gap(8.h),
              _DetailRow(
                iconPath: Assets.icons.phoneIcon.path,
                label: employee.phone!,
                iconColor: iconColor,
                textColor: titleColor,
                textTheme: textTheme,
              ),
            ],
            Gap(16.h),
          ] else
            Gap(8.h),
          Container(height: 1, color: borderColor),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStatusCapsule(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onView,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.primary, width: 1.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localizations.view,
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                        Gap(6.w),
                        DigifyAsset(
                          assetPath: Assets.icons.arrowRightIcon.path,
                          width: 16,
                          height: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCapsule() {
    final isProbation = employee.status.toLowerCase().contains('probation');
    final label = employee.status.isEmpty
        ? localizations.onProbation
        : (employee.status.length > 1
              ? employee.status[0].toUpperCase() + employee.status.substring(1)
              : employee.status.toUpperCase());
    return DigifyCapsule(
      label: label.toUpperCase(),
      iconPath: isProbation ? Assets.icons.clockIcon.path : null,
      backgroundColor: isProbation ? AppColors.warningBg : AppColors.activeStatusBg,
      textColor: isProbation ? AppColors.warningText : AppColors.successText,
      borderColor: isProbation ? AppColors.warningBorder : AppColors.activeStatusBorder,
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color iconColor;
  final Color textColor;
  final TextTheme textTheme;

  const _DetailRow({
    required this.iconPath,
    required this.label,
    required this.iconColor,
    required this.textColor,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: iconColor),
        Gap(8.w),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: textColor, fontSize: 13.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
