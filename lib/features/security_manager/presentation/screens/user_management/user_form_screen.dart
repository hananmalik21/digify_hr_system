import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../widgets/user_management/user_form_tab_bar.dart';
import 'tabs/account_information_tab.dart';
import 'tabs/roles_and_responsibilities_tab.dart';
import 'tabs/access_and_permissions_tab.dart';
import 'tabs/user_preferences_tab.dart';
import 'tabs/security_settings_tab.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  const UserFormScreen({super.key});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.tableHeaderBackground,
      body: Column(
        children: [
          _buildHeader(context, localizations, isDark),
          UserFormTabBar(controller: _tabController, isDark: isDark),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AccountInformationTab(),
                RolesAndResponsibilitiesTab(),
                AccessAndPermissionsTab(),
                UserPreferencesTab(),
                SecuritySettingsTab(),
              ],
            ),
          ),
          _buildFooter(context, localizations, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      color: isDark ? AppColors.cardBackgroundDark : Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          Gap(8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create User',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                'Add a new user to the system',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
          Gap(12.w),
          AppButton(
            label: 'Save Draft',
            svgPath: Assets.icons.saveIcon.path,
            backgroundColor: AppColors.shiftExportButton,
            onPressed: () {},
          ),
          Gap(12.w),
          AppButton.primary(
            label: 'Save User',
            svgPath: Assets.icons.checkIconGreen.path,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20.sp, color: AppColors.primary),
          Gap(8.w),
          Text(
            'All fields marked with * are required',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
          Gap(12.w),
          AppButton(
            label: 'Save Draft',
            svgPath: Assets.icons.saveIcon.path,
            backgroundColor: AppColors.shiftExportButton,
            onPressed: () {},
          ),
          Gap(12.w),
          AppButton.primary(
            label: 'Save User',
            svgPath: Assets.icons.checkIconGreen.path,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
