import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/employee_management_stats_cards.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/employee_search_and_actions.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/employees_grid_view.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_dialog.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/common/manage_employees_table.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ManageEmployeesScreen extends ConsumerWidget {
  const ManageEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveEnterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final listState = ref.watch(manageEmployeesListProvider);
    final viewMode = ref.watch(manageEmployeesViewModeProvider);

    ref.listen<int?>(manageEmployeesEnterpriseIdProvider, (previous, next) {
      if (next != null) {
        ref.read(manageEmployeesListProvider.notifier).loadPage(next, 1);
      }
    });

    if (effectiveEnterpriseId != null && listState.lastEnterpriseId != effectiveEnterpriseId && !listState.isLoading) {
      final id = effectiveEnterpriseId;
      Future.microtask(() {
        ref.read(manageEmployeesListProvider.notifier).loadPage(id, 1);
      });
    }

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: localizations.manageEmployees,
              description: localizations.manageEmployeesDescription,
              trailing: AppButton.primary(
                label: localizations.addNewEmployee,
                svgPath: Assets.icons.addDivisionIcon.path,
                onPressed: () => AddEmployeeDialog.show(context),
              ),
            ),
            Gap(24.h),
            EmployeeManagementStatsCards(localizations: localizations, isDark: isDark),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(manageEmployeesSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
              subtitle: effectiveEnterpriseId != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            Gap(24.h),
            EmployeeSearchAndActions(localizations: localizations, isDark: isDark),
            Gap(16.h),
            if (listState.error != null)
              DigifyErrorState(
                message: localizations.somethingWentWrong,
                retryLabel: localizations.retry,
                onRetry: () => ref.read(manageEmployeesListProvider.notifier).refresh(),
              )
            else if (viewMode == EmployeeViewMode.grid) ...[
              EmployeesGridView(
                employees: listState.items,
                localizations: localizations,
                isDark: isDark,
                isLoading: listState.isLoading,
                onView: (employee) => context.push(AppRoutes.employeeDetail, extra: employee),
                onMore: () {},
              ),
              if (listState.pagination != null) ...[
                Gap(16.h),
                PaginationControls.fromPaginationInfo(
                  paginationInfo: listState.pagination!,
                  currentPage: listState.currentPage,
                  pageSize: listState.pagination!.pageSize,
                  onPrevious: listState.pagination!.hasPrevious
                      ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(listState.currentPage - 1)
                      : null,
                  onNext: listState.pagination!.hasNext
                      ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(listState.currentPage + 1)
                      : null,
                  isLoading: listState.isLoading,
                  style: PaginationStyle.simple,
                ),
              ],
            ] else
              ManageEmployeesTable(
                localizations: localizations,
                employees: listState.items,
                isDark: isDark,
                isLoading: listState.isLoading,
                paginationInfo: listState.pagination,
                currentPage: listState.currentPage,
                pageSize: listState.pagination?.pageSize ?? 10,
                onPrevious: listState.pagination != null && listState.pagination!.hasPrevious
                    ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(listState.currentPage - 1)
                    : null,
                onNext: listState.pagination != null && listState.pagination!.hasNext
                    ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(listState.currentPage + 1)
                    : null,
                onView: (employee) => context.push(AppRoutes.employeeDetail, extra: employee),
                onEdit: (employee) => context.push(AppRoutes.employeeDetail, extra: employee),
                onMore: () {},
              ),
          ],
        ),
      ),
    );
  }
}
