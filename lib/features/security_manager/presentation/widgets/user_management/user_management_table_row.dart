import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/features/security_manager/data/config/user_management_table_config.dart';
import 'package:digify_hr_system/features/security_manager/domain/models/system_user.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_security_status.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_status_chip.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UserManagementTableRow extends StatelessWidget {
  final SystemUser user;
  final bool isDark;

  const UserManagementTableRow({super.key, required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(
      fontSize: 14.sp,
      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
    );
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(
      fontSize: 12.sp,
      color: AppColors.tableHeaderText,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          if (UserManagementTableConfig.showUser)
            _buildDataCell(
              Row(
                children: [
                  AppAvatar(
                    image: null,
                    fallbackInitial: user.initials,
                    size: 44.w,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    textColor: AppColors.primary,
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Gap(2.h),
                        Text(user.email, style: secondaryStyle),
                        Text(user.employeeNumber, style: secondaryStyle),
                      ],
                    ),
                  ),
                ],
              ),
              UserManagementTableConfig.userWidth.w,
            ),
          if (UserManagementTableConfig.showDepartment)
            _buildDataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.department,
                    style: textStyle?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Gap(2.h),
                  Text(user.designation, style: secondaryStyle),
                ],
              ),
              UserManagementTableConfig.departmentWidth.w,
            ),
          if (UserManagementTableConfig.showRoles)
            _buildDataCell(
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: user.roles
                    .map((role) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.roleBadgeBg,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.roleBadgeBorder, width: 1),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.roleBadgeText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              UserManagementTableConfig.rolesWidth.w,
            ),
          if (UserManagementTableConfig.showStatus)
            _buildDataCell(
              UserStatusChip(status: user.status),
              UserManagementTableConfig.statusWidth.w,
            ),
          if (UserManagementTableConfig.showSecurity)
            _buildDataCell(
              UserSecurityStatus(is2FAEnabled: user.is2FAEnabled),
              UserManagementTableConfig.securityWidth.w,
            ),
          if (UserManagementTableConfig.showActions)
            _buildDataCell(
              _buildActionsCell(),
              UserManagementTableConfig.actionsWidth.w,
            ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: UserManagementTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildActionsCell() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.editIconPurple.path,
          onTap: () {},
          width: 20.w,
          height: 20.h,
          color: AppColors.primary,
        ),
        Gap(12.w),
        DigifyAssetButton(
          assetPath: Assets.icons.blueEyeIcon.path,
          onTap: () {},
          width: 20.w,
          height: 20.h,
          color: AppColors.textSecondary,
        ),
        Gap(12.w),
        DigifyAssetButton(
          assetPath: Assets.icons.deleteIconRed.path,
          onTap: () {},
          width: 20.w,
          height: 20.h,
          color: AppColors.error,
        ),
      ],
    );
  }
}
