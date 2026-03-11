import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../providers/user_management/user_management_enterprise_provider.dart';
import '../providers/user_management/user_management_provider.dart';
import '../widgets/user_management/search_and_filter.dart';
import '../widgets/user_management/user_summary_stats.dart';
import '../widgets/user_management/user_management_table.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveEnterpriseId = ref.watch(
      userManagementSelectedEnterpriseProvider,
    );
    final state = ref.watch(userManagementProvider);
    final notifier = ref.read(userManagementProvider.notifier);

    return Container(
      color: isDark
          ? AppColors.backgroundDark
          : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: localizations.userManagement,
              description: 'Manage system users, roles, and access permissions',
              trailing: AppButton.primary(
                label: "Create New User",
                svgPath: Assets.icons.addNewIconFigma.path,
                onPressed: () {},
              ),
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref
                    .read(userManagementSelectedEnterpriseProvider.notifier)
                    .setEnterpriseId(enterpriseId);
              },
              subtitle: effectiveEnterpriseId != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            Gap(24.h),
            UserManagementSearchAndFilter(
              searchController: _searchController,
              statusFilter: state.statusFilter,
              onSearchChanged: (value) => notifier.setSearchQuery(value),
              onStatusFilterChanged: (value) => notifier.setStatusFilter(value),
              isDark: isDark,
            ),
            Gap(24.h),
            UserSummaryStats(localizations: localizations, isDark: isDark),
            Gap(24.h),
            UserManagementTable(
              users: state.users,
              isDark: isDark,
              isLoading: state.isLoading,
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}
