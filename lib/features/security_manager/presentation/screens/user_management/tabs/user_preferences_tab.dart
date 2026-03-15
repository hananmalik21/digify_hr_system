import 'package:digify_hr_system/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_section.dart';

class UserPreferencesTab extends ConsumerStatefulWidget {
  const UserPreferencesTab({super.key});

  @override
  ConsumerState<UserPreferencesTab> createState() => _UserPreferencesTabState();
}

class _UserPreferencesTabState extends ConsumerState<UserPreferencesTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          _buildRegionalSettingsSection(context),
          Gap(24.h),
          _buildNotificationPreferencesSection(),
          Gap(24.h),
          _buildDisplayPreferencesSection(context),
        ],
      ),
    );
  }

  Widget _buildRegionalSettingsSection(BuildContext context) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Regional & Language Settings',
        icon: Icon(Icons.language, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifySelectField<String>(
              label: 'Preferred Language',
              value: state.language,
              items: const ['English', 'Arabic', 'Both (English/Arabic)'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setLanguage(v!),
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Time Zone',
              value: state.timeZone,
              items: const ['Asia/Kuwait (GMT+3)', 'UTC', 'GMT'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setTimeZone(v!),
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Date Format',
              value: state.dateFormat,
              items: const ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setDateFormat(v!),
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Currency',
              value: state.currency,
              items: const [
                'KWD - Kuwaiti Dinar',
                'USD - US Dollar',
                'EUR - Euro',
              ],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setCurrency(v!),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Preferred Language',
                    value: state.language,
                    items: const ['English', 'Arabic', 'Both (English/Arabic)'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setLanguage(v!),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Time Zone',
                    value: state.timeZone,
                    items: const ['Asia/Kuwait (GMT+3)', 'UTC', 'GMT'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setTimeZone(v!),
                  ),
                ),
              ],
            ),
            Gap(16.h),
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Date Format',
                    value: state.dateFormat,
                    items: const ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setDateFormat(v!),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Currency',
                    value: state.currency,
                    items: const [
                      'KWD - Kuwaiti Dinar',
                      'USD - US Dollar',
                      'EUR - Euro',
                    ],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setCurrency(v!),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationPreferencesSection() {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Notification Preferences',
        icon: Icon(
          Icons.notifications_none,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
      child: Column(
        children: [
          _buildPreferenceTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: state.receiveEmailNotifications ?? false,
            onChanged: (v) => notifier.setReceiveEmailNotifications(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'SMS Notifications',
            subtitle: 'Receive important alerts via SMS',
            value: state.receiveSmsNotifications ?? false,
            onChanged: (v) => notifier.setReceiveSmsNotifications(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'In-App Notifications',
            subtitle: 'Show notifications within the application',
            value: state.receivePushNotifications ?? false,
            onChanged: (v) => notifier.setReceivePushNotifications(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'Workflow Alerts',
            subtitle: 'Notifications for approvals and workflow items',
            value: state.allowWorkflowAlerts ?? false,
            onChanged: (v) => notifier.setAllowWorkflowAlerts(v),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayPreferencesSection(BuildContext context) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Display Preferences',
        icon: Icon(
          Icons.settings_outlined,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifySelectField<String>(
            label: 'Items Per Page',
            value: state.itemsPerPage,
            items: const ['10 items', '25 items', '50 items', '100 items'],
            itemLabelBuilder: (item) => item,
            onChanged: (v) => notifier.setItemsPerPage(v!),
          ),
          Gap(16.h),
          _buildPreferenceTile(
            title: 'Compact View',
            subtitle: 'Use compact mode for tables and lists',
            value: state.compactView ?? false,
            onChanged: (v) => notifier.setCompactView(v),
          ),
          Gap(12.h),
          _buildPreferenceTile(
            title: 'Show Tooltips',
            subtitle: 'Display helpful tooltips throughout the system',
            value: state.showTooltips ?? false,
            onChanged: (v) => notifier.setShowTooltips(v),
          ),
        ],
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
