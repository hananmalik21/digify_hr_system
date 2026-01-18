import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_row.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveBalancesTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalancesTableSkeleton({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          8,
          (index) => LeaveBalancesTableRow(
            employeeData: {
              'name': 'Employee Name',
              'id': 'EMP-000000',
              'department': 'Department Name',
              'joinDate': '2020-01-15',
              'annualLeave': 23,
              'sickLeave': 15,
              'unpaidLeave': 0,
              'totalAvailable': 38,
            },
          ),
        ),
      ),
    );
  }
}
