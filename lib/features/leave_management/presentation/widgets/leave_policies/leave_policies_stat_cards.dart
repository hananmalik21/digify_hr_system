import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/common/leave_management_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePoliciesStatCards extends StatelessWidget {
  final bool isDark;

  const LeavePoliciesStatCards({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final cards = [
      LeaveManagementStatCard(label: 'Total Policies', value: '6', isDark: isDark),
      LeaveManagementStatCard(label: 'Kuwait Law Compliant', value: '6', isDark: isDark),
      LeaveManagementStatCard(label: 'Paid Leave Types', value: '5', isDark: isDark),
      LeaveManagementStatCard(label: 'Custom Policies', value: '0', isDark: isDark),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            SizedBox(width: double.infinity, child: cards[i]),
            if (i < cards.length - 1) Gap(12.h),
          ],
        ],
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(width: (context.screenWidth - 48.w - 12.w) / 2, child: card);
        }).toList(),
      );
    } else {
      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[Expanded(child: cards[i]), if (i < cards.length - 1) Gap(21.w)],
        ],
      );
    }
  }
}
