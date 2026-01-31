import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/common/leave_management_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePoliciesStatCards extends ConsumerWidget {
  final bool isDark;

  const LeavePoliciesStatCards({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final policiesAsync = ref.watch(leavePoliciesFromAbsProvider);
    final total = policiesAsync.value?.length ?? 0;
    final kuwaitCompliant = policiesAsync.value?.where((p) => p.kuwaitLaborCompliant == 'Y').length ?? 0;
    final paid = total;
    const custom = 0;

    final cards = [
      LeaveManagementStatCard(label: 'Total Policies', value: '$total', isDark: isDark),
      LeaveManagementStatCard(label: 'Kuwait Law Compliant', value: '$kuwaitCompliant', isDark: isDark),
      LeaveManagementStatCard(label: 'Paid Leave Types', value: '$paid', isDark: isDark),
      LeaveManagementStatCard(label: 'Custom Policies', value: '$custom', isDark: isDark),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: cards.map((card) {
          return SizedBox(width: (context.screenWidth - 48.w - 12.w) / 2, child: card);
        }).toList(),
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
