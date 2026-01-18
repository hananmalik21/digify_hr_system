import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_row.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveBalancesTableSection extends StatelessWidget {
  final AppLocalizations localizations;
  final List<Map<String, dynamic>> employees;
  final bool isDark;
  final bool isLoading;

  const LeaveBalancesTableSection({
    super.key,
    required this.localizations,
    required this.employees,
    required this.isDark,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeaveBalancesTableHeader(isDark: isDark, localizations: localizations),
              if (isLoading && employees.isEmpty)
                LeaveBalancesTableSkeleton(localizations: localizations)
              else if (employees.isEmpty && !isLoading)
                SizedBox(
                  width: 1200.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Center(
                      child: Text(
                        localizations.noResultsFound,
                        style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                )
              else
                ...employees.map((employee) => LeaveBalancesTableRow(employeeData: employee)),
            ],
          ),
        ),
      ),
    );
  }
}
