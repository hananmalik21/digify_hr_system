import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_section.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_table_header_text.dart';

class AccessAndPermissionsTab extends StatelessWidget {
  final bool isDark;

  const AccessAndPermissionsTab({
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
          _buildDataAccessPoliciesSection(),
          Gap(24.h),
          _buildFunctionalPrivilegesSection(context),
        ],
      ),
    );
  }

  Widget _buildDataAccessPoliciesSection() {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Data Access Policies',
        subtitle: 'Define what data the user can access',
        icon: Icon(Icons.dns_outlined, color: AppColors.primary, size: 18.sp),
        trailing: AppButton.primary(
          label: 'Add Policy',
          svgPath: Assets.icons.addNewIconFigma.path,
          onPressed: () {},
        ),
      ),
      child: Column(
        children: [
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
                _buildPolicyTableHeader(),
                _buildEmptyPolicyTableState(),
              ],
            ),
          ),
          Gap(24.h),
          _buildAvailableSecurityPoliciesSection(),
        ],
      ),
    );
  }

  Widget _buildPolicyTableHeader() {
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
          UserFormTableHeaderText(text: 'POLICY NAME', flex: 2, isDark: isDark),
          UserFormTableHeaderText(text: 'TYPE', flex: 1, isDark: isDark),
          UserFormTableHeaderText(text: 'SCOPE', flex: 1, isDark: isDark),
          UserFormTableHeaderText(text: 'EFFECTIVE DATE', flex: 1, isDark: isDark),
          UserFormTableHeaderText(text: 'ACTIONS', flex: 1, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyPolicyTableState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: Text(
        'No data access policies assigned. Click "Add Policy" to grant data access.',
        style: TextStyle(
          fontSize: 14.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAvailableSecurityPoliciesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Data Security Policies',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(16.h),
        _buildPolicyRow(
          'Kuwait Operations Data',
          'All Kuwait entities',
          'Business Unit',
        ),
        Gap(12.h),
        _buildPolicyRow(
          'HR Department Data',
          'HR Department only',
          'Department',
        ),
        Gap(12.h),
        _buildPolicyRow(
          'Confidential Employee Data',
          'Restricted access',
          'Data Security',
        ),
        Gap(12.h),
        _buildPolicyRow(
          'Payroll Sensitive Data',
          'Payroll administrators only',
          'Data Security',
        ),
      ],
    );
  }

  Widget _buildPolicyRow(
    String title,
    String subtitle,
    String tag,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? AppColors.cardBorderDark
              : AppColors.dashboardCardBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardBackgroundGreyDark
                  : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionalPrivilegesSection(BuildContext context) {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Functional Privileges',
        subtitle: 'Additional privileges and permissions',
        icon: Icon(
          Icons.vpn_key_outlined,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
      child: Column(
        children: [
          Gap(16.h),
          DigifyTextField(
            hintText: 'Search privileges...',
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
          Gap(16.h),
          _buildPrivilegesGrid(context),
        ],
      ),
    );
  }

  Widget _buildPrivilegesGrid(BuildContext context) {
    final privileges = [
      {'title': 'View All Employees', 'category': 'Employee Management'},
      {'title': 'Manage Payroll', 'category': 'Payroll'},
      {'title': 'Approve Leave Requests', 'category': 'Leave Management'},
      {'title': 'Access Reports', 'category': 'Reporting'},
      {'title': 'Manage Recruitment', 'category': 'Recruitment'},
      {'title': 'System Administration', 'category': 'Administration'},
      {'title': 'Edit Employee Records', 'category': 'Employee Management'},
      {'title': 'View Salary Information', 'category': 'Payroll'},
      {'title': 'Manage Performance Reviews', 'category': 'Performance'},
      {'title': 'Approve Expense Claims', 'category': 'Finance'},
      {
        'title': 'Manage Training Programs',
        'category': 'Learning & Development',
      },
      {'title': 'Access Audit Logs', 'category': 'Security'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isMobile ? 1 : 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 80.h,
      ),
      itemCount: privileges.length,
      itemBuilder: (context, index) {
        final privilege = privileges[index];
        return _buildPrivilegeCard(
          title: privilege['title']!,
          category: privilege['category']!,
        );
      },
    );
  }

  Widget _buildPrivilegeCard({
    required String title,
    required String category,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? AppColors.cardBorderDark
              : AppColors.dashboardCardBorder,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: DigifyCheckbox(value: false, onChanged: (v) {}),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                Gap(4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
