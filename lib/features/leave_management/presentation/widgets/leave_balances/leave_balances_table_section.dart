import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_row.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Presentational table section: header + rows / loading / empty / error.
/// Does not include outer container; caller wraps with container and optional pagination.
class LeaveBalancesTableSection extends StatelessWidget {
  final AppLocalizations localizations;
  final List<Map<String, dynamic>> employees;
  final bool isDark;
  final bool isLoading;
  final String? error;

  const LeaveBalancesTableSection({
    super.key,
    required this.localizations,
    required this.employees,
    required this.isDark,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollableSingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Skeletonizer(
        enabled: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeaveBalancesTableHeader(isDark: isDark, localizations: localizations),
            if (error != null)
              _buildMessageState(16.sp, error!, AppColors.error)
            else if (isLoading && employees.isEmpty)
              LeaveBalancesTableSkeleton(localizations: localizations)
            else if (employees.isEmpty)
              _buildMessageState(16.sp, localizations.noResultsFound, AppColors.textMuted)
            else
              ...employees.map((e) => LeaveBalancesTableRow(employeeData: e)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageState(double fontSize, String text, Color color) {
    return SizedBox(
      width: 1200.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: color),
          ),
        ),
      ),
    );
  }
}
