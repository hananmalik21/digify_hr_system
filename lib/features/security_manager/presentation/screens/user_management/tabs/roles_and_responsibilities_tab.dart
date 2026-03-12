import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_section.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_table_header_text.dart';

class RolesAndResponsibilitiesTab extends StatelessWidget {
  final bool isDark;

  const RolesAndResponsibilitiesTab({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssignedRolesSection(),
          Gap(24.h),
          Text(
            'Available Roles (6)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          _buildAvailableRolesGrid(context),
        ],
      ),
    );
  }

  Widget _buildAssignedRolesSection() {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Assigned Roles',
        subtitle: 'Assign application, job, and functional roles to the user',
        icon: Icon(
          Icons.shield_outlined,
          color: AppColors.primary,
          size: 18.sp,
        ),
        trailing: AppButton.primary(
          label: 'Add Role',
          svgPath: Assets.icons.addNewIconFigma.path,
          onPressed: () {},
        ),
      ),
      child: Column(
        children: [
          _buildSearchAndFiltersRow(),
          Gap(16.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark
                    ? AppColors.cardBorderDark
                    : AppColors.dashboardCardBorder,
              ),
            ),
            child: Column(
              children: [
                _buildTableHeader(),
                _buildEmptyTableState(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardBackgroundGreyDark
            : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: DigifyCheckbox(value: false, onChanged: (v) {}),
          ),
          Gap(16.w),
          UserFormTableHeaderText(text: 'ROLE NAME', flex: 2, isDark: isDark),
          UserFormTableHeaderText(text: 'CATEGORY', flex: 1, isDark: isDark),
          UserFormTableHeaderText(text: 'DESCRIPTION', flex: 2, isDark: isDark),
          UserFormTableHeaderText(text: 'EFFECTIVE DATE', flex: 1, isDark: isDark),
          UserFormTableHeaderText(text: 'END DATE', flex: 1, isDark: isDark),
          UserFormTableHeaderText(text: 'ACTIONS', flex: 1, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyTableState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: Text(
        'No roles assigned. Click "Add Role" to assign roles to this user.',
        style: TextStyle(
          fontSize: 14.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSearchAndFiltersRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: DigifyTextField(
            hintText: 'Search roles...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: DigifyAsset(
                assetPath: Assets.icons.searchIconFigma.path,
                width: 18,
                height: 18,
                color: AppColors.textPlaceholder,
              ),
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          flex: 1,
          child: DigifySelectField<String>(
            hint: 'All Categories',
            items: const ['All Categories', 'Application', 'Job', 'Function'],
            itemLabelBuilder: (v) => v,
            onChanged: (v) {},
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableRolesGrid(BuildContext context) {
    final roles = [
      {
        'title': 'HR Administrator',
        'desc': 'Full access to HR module',
        'type': 'Application Role',
        'users': '3 users',
        'color': const Color(0xFFE3F2FD),
        'textColor': const Color(0xFF1E88E5),
      },
      {
        'title': 'Payroll Administrator',
        'desc': 'Manage payroll operations',
        'type': 'Application Role',
        'users': '2 users',
        'color': const Color(0xFFE3F2FD),
        'textColor': const Color(0xFF1E88E5),
      },
      {
        'title': 'Department Manager',
        'desc': 'Manage department employees',
        'type': 'Job Role',
        'users': '8 users',
        'color': const Color(0xFFF3E5F5),
        'textColor': const Color(0xFF8E24AA),
      },
      {
        'title': 'Employee',
        'desc': 'Basic employee access',
        'type': 'Abstract Role',
        'users': '150 users',
        'color': const Color(0xFFE8F5E9),
        'textColor': const Color(0xFF43A047),
      },
      {
        'title': 'Recruiter',
        'desc': 'Recruitment module access',
        'type': 'Function Role',
        'users': '5 users',
        'color': const Color(0xFFFFF3E0),
        'textColor': const Color(0xFFFB8C00),
      },
      {
        'title': 'Time Administrator',
        'desc': 'Manage attendance and time',
        'type': 'Function Role',
        'users': '4 users',
        'color': const Color(0xFFFFF3E0),
        'textColor': const Color(0xFFFB8C00),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isMobile ? 1 : 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        mainAxisExtent: 120.h,
      ),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return _buildRoleCard(
          title: role['title'] as String,
          description: role['desc'] as String,
          type: role['type'] as String,
          userCount: role['users'] as String,
          typeColor: role['color'] as Color,
          typeTextColor: role['textColor'] as Color,
        );
      },
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required String type,
    required String userCount,
    required Color typeColor,
    required Color typeTextColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? AppColors.cardBorderDark
              : AppColors.dashboardCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardBackgroundGreyDark
                      : AppColors.tableHeaderBackground,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  userCount,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          Gap(4.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            type,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: typeTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
