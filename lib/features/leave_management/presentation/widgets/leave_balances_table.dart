import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances/leave_balances_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalancesTable extends ConsumerWidget {
  const LeaveBalancesTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final balancesAsync = ref.watch(leaveBalancesProvider);
    final pagination = ref.watch(leaveBalancesPaginationProvider);
    final notifierState = ref.watch(leaveBalancesNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          balancesAsync.when(
            data: (paginated) {
              final rows = _balancesToRowMaps(paginated.balances);
              return LeaveBalancesTableSection(
                localizations: localizations,
                employees: rows,
                isDark: isDark,
                isLoading: notifierState.isLoading && notifierState.data == null,
              );
            },
            loading: () => LeaveBalancesTableSection(
              localizations: localizations,
              employees: const [],
              isDark: isDark,
              isLoading: true,
            ),
            error: (e, _) => LeaveBalancesTableSection(
              localizations: localizations,
              employees: const [],
              isDark: isDark,
              isLoading: false,
              error: 'Error: ${e.toString()}',
            ),
          ),
          if (notifierState.data != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: notifierState.data!.pagination,
              currentPage: pagination.page,
              pageSize: pagination.pageSize,
              onPrevious: notifierState.data!.pagination.hasPrevious
                  ? () {
                      ref.read(leaveBalancesPaginationProvider.notifier).state = (
                        page: pagination.page - 1,
                        pageSize: pagination.pageSize,
                      );
                    }
                  : null,
              onNext: notifierState.data!.pagination.hasNext
                  ? () {
                      ref.read(leaveBalancesPaginationProvider.notifier).state = (
                        page: pagination.page + 1,
                        pageSize: pagination.pageSize,
                      );
                    }
                  : null,
              isLoading: notifierState.isLoading,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }

  static List<Map<String, dynamic>> _balancesToRowMaps(List<LeaveBalance> balances) {
    return balances.map((b) {
      return <String, dynamic>{
        'name': b.employeeName,
        'id': b.employeeGuid,
        'department': '-',
        'joinDate': '-',
        'annualLeave': 0,
        'sickLeave': 0,
        'unpaidLeave': 0,
        'totalAvailable': b.availableDays,
        'balanceGuid': b.employeeLeaveBalanceGuid,
        'balance': b,
      };
    }).toList();
  }
}
