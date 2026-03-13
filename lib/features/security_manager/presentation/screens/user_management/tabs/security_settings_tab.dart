import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_section.dart';

class SecuritySettingsTab extends StatelessWidget {
  final bool isDark;

  const SecuritySettingsTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          _buildAuthenticationSection(context),
          Gap(24.h),
          _buildSessionManagementSection(context),
          Gap(24.h),
          _buildAuditSection(),
        ],
      ),
    );
  }

  Widget _buildAuthenticationSection(BuildContext context) {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Authentication & Security',
        icon: Icon(
          Icons.verified_user_outlined,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHighlightedPreferenceTile(
            title: 'Enable Two-Factor Authentication (2FA)',
            subtitle: 'Require additional verification for enhanced security',
            value: false,
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            _buildPreferenceTile(
              title: 'Force Password Change',
              subtitle: 'On next login',
              value: false,
            ),
            Gap(12.h),
            _buildPreferenceTile(
              title: 'Account Lockout',
              subtitle: 'After failed login attempts',
              value: false,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildPreferenceTile(
                    title: 'Force Password Change',
                    subtitle: 'On next login',
                    value: false,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: _buildPreferenceTile(
                    title: 'Account Lockout',
                    subtitle: 'After failed login attempts',
                    value: false,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          DigifySelectField<String>(
            label: 'Failed Login Attempts Before Lockout',
            value: '5 attempts',
            items: const ['3 attempts', '5 attempts', '10 attempts'],
            itemLabelBuilder: (item) => item,
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSessionManagementSection(BuildContext context) {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Session Management',
        icon: Icon(Icons.access_time, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          const DigifyTextField(
            labelText: 'Session Timeout (minutes)',
            hintText: '30 minutes',
            // helperText: 'Automatically log out user after inactivity',
          ),
          Gap(16.h),
          _buildPreferenceTile(
            title: 'Concurrent Sessions',
            subtitle: 'Allow user to login from multiple devices',
            value: false,
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'IP Address Restriction',
            subtitle: 'Restrict access to specific IP addresses',
            value: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditSection() {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Audit & Compliance',
        icon: Icon(
          Icons.analytics_outlined,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
      child: Column(
        children: [
          _buildPreferenceTile(
            title: 'Audit User Actions',
            subtitle: 'Log all user activities for compliance',
            value: false,
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'Data Access Logging',
            subtitle: 'Track sensitive data access',
            value: false,
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'Compliance Alerts',
            subtitle: 'Send alerts for policy violations',
            value: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedPreferenceTile({
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          DigifyCheckbox(value: value, onChanged: (v) {}),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile({
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
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
          DigifyCheckbox(value: value, onChanged: (v) {}),
        ],
      ),
    );
  }
}
