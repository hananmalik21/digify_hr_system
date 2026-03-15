import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../../../widgets/user_management/user_form_section.dart';

class SecuritySettingsTab extends ConsumerStatefulWidget {
  const SecuritySettingsTab({super.key});

  @override
  ConsumerState<SecuritySettingsTab> createState() =>
      _SecuritySettingsTabState();
}

class _SecuritySettingsTabState extends ConsumerState<SecuritySettingsTab> {
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
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return UserFormSection(
      isDark: context.isDark,
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
            value: state.enable2FA ?? false,
            onChanged: (v) => notifier.setEnable2FA(v),
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            _buildPreferenceTile(
              title: 'Force Password Change',
              subtitle: 'On next login',
              value: state.forcePasswordChange ?? false,
              onChanged: (v) => notifier.setForcePasswordChange(v),
            ),
            Gap(12.h),
            _buildPreferenceTile(
              title: 'Account Lockout',
              subtitle: 'After failed login attempts',
              value: state.accountLockout ?? false,
              onChanged: (v) => notifier.setAccountLockout(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildPreferenceTile(
                    title: 'Force Password Change',
                    subtitle: 'On next login',
                    value: state.forcePasswordChange ?? false,
                    onChanged: (v) => notifier.setForcePasswordChange(v),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: _buildPreferenceTile(
                    title: 'Account Lockout',
                    subtitle: 'After failed login attempts',
                    value: state.accountLockout ?? false,
                    onChanged: (v) => notifier.setAccountLockout(v),
                  ),
                ),
              ],
            ),
          ],
          if (state.accountLockout ?? false) ...[
            Gap(16.h),
            DigifySelectField<int>(
              label: 'Failed Login Attempts Before Lockout',
              value: state.failedLoginAttempts,
              items: const [3, 5, 10],
              itemLabelBuilder: (item) => '$item attempts',
              onChanged: (v) => notifier.setFailedLoginAttempts(v!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionManagementSection(BuildContext context) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Session Management',
        icon: Icon(Icons.access_time, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          DigifySelectField<int>(
            label: 'Session Timeout (minutes)',
            value: state.sessionTimeOut,
            items: const [30, 60, 120],
            itemLabelBuilder: (item) => '$item attempts',
            onChanged: (v) => notifier.setSessionTimeOut(v!),
          ),
          Gap(16.h),
          _buildPreferenceTile(
            title: 'Concurrent Sessions',
            subtitle: 'Allow user to login from multiple devices',
            value: state.allowConcurrentSession ?? false,
            onChanged: (v) => notifier.setAllowConcurrentSession(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'IP Address Restriction',
            subtitle: 'Restrict access to specific IP addresses',
            value: state.ipAddressRestriction ?? false,
            onChanged: (v) => notifier.setIpAddressRestriction(v),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditSection() {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return UserFormSection(
      isDark: context.isDark,
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
            value: state.auditUserActions ?? false,
            onChanged: (v) => notifier.setAuditUserActions(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'Data Access Logging',
            subtitle: 'Track sensitive data access',
            value: state.dataAccessLogging ?? false,
            onChanged: (v) => notifier.setDataAccessLogging(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'Compliance Alerts',
            subtitle: 'Send alerts for policy violations',
            value: state.complianceAlert ?? false,
            onChanged: (v) => notifier.setComplianceAlert(v),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedPreferenceTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
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
      ),
    );
  }

  Widget _buildPreferenceTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.borderGrey,
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
                      color: context.isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.isDark
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
      ),
    );
  }
}
