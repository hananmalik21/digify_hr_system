import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/security_manager/data/config/user_management_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManagementTableHeader extends StatelessWidget {
  final bool isDark;

  const UserManagementTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          if (UserManagementTableConfig.showUser)
            _buildHeaderCell(context, 'User Details', UserManagementTableConfig.userWidth.w),
          if (UserManagementTableConfig.showDepartment)
            _buildHeaderCell(context, 'Department', UserManagementTableConfig.departmentWidth.w),
          if (UserManagementTableConfig.showRoles)
            _buildHeaderCell(context, 'Assigned Roles', UserManagementTableConfig.rolesWidth.w),
          if (UserManagementTableConfig.showStatus)
            _buildHeaderCell(context, 'Status', UserManagementTableConfig.statusWidth.w),
          if (UserManagementTableConfig.showSecurity)
            _buildHeaderCell(context, 'Security', UserManagementTableConfig.securityWidth.w),
          if (UserManagementTableConfig.showActions)
            _buildHeaderCell(context, 'Actions', UserManagementTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {TextAlign textAlign = TextAlign.left}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: UserManagementTableConfig.cellPaddingHorizontal.w,
        vertical: 14.h,
      ),
      alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        textAlign: textAlign,
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.tableHeaderText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
