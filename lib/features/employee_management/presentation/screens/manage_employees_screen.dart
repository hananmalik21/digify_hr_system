import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/employee_management_stats_cards.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/employee_search_and_actions.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/manage_employees_table.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageEmployeesScreen extends ConsumerWidget {
  const ManageEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employeesAsync = ref.watch(manageEmployeesListProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24.h,
        children: [
          DigifyTabHeader(
            title: localizations.manageEmployees,
            description: localizations.manageEmployeesDescription,
            trailing: AppButton.primary(
              label: localizations.addNewEmployee,
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: () {},
            ),
          ),
          EmployeeManagementStatsCards(localizations: localizations, isDark: isDark),
          EmployeeSearchAndActions(localizations: localizations, isDark: isDark),
          employeesAsync.when(
            data: (employees) => ManageEmployeesTable(
              localizations: localizations,
              employees: employees,
              isDark: isDark,
              isLoading: false,
              onView: (_) {},
              onEdit: (_) {},
              onMore: () {},
            ),
            loading: () => ManageEmployeesTable(
              localizations: localizations,
              employees: [],
              isDark: isDark,
              isLoading: true,
              onView: (_) {},
              onEdit: (_) {},
              onMore: () {},
            ),
            error: (error, _) => DigifyErrorState(
              message: localizations.somethingWentWrong,
              retryLabel: localizations.retry,
              onRetry: () => ref.read(manageEmployeesListProvider.notifier).refresh(),
            ),
          ),
        ],
      ),
    );
  }
}
