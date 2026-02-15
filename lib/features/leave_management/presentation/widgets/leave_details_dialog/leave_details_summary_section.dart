import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_stats_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsSummarySection extends StatelessWidget {
  const LeaveDetailsSummarySection({super.key, required this.summary, required this.isDark});

  final Map<String, dynamic> summary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Total Accrued',
            value: '${summary['totalAccrued']} days',
            iconPath: Assets.icons.addBusinessUnitIcon.path,
            isDark: isDark,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Total Consumed',
            value: '${summary['totalConsumed']} days',
            iconPath: Assets.icons.leaveManagement.minus.path,
            isDark: isDark,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Current Balance',
            value: '${summary['currentBalance']} days',
            iconPath: Assets.icons.leaveManagementMainIcon.path,
            isDark: isDark,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: LeaveDetailsStatsCard(
            label: 'Entitlement',
            value: summary['entitlement'] as String,
            iconPath: Assets.icons.leaveManagement.downfall.path,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
