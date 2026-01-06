import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/data/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class PublicHolidaysStatsCards extends StatelessWidget {
  final int totalHolidays;
  final int fixedHolidays;
  final int islamicHolidays;
  final int paidHolidays;
  final bool isDark;

  const PublicHolidaysStatsCards({
    super.key,
    required this.totalHolidays,
    required this.fixedHolidays,
    required this.islamicHolidays,
    required this.paidHolidays,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final spacing = 16.w;

    final stats = [
      StatsCardData(
        label: 'Total Holidays',
        value: '$totalHolidays',
        iconPath: Assets.icons.calendarIcon.path,
        iconColor: const Color(0xFF3B82F6),
        iconBackground: const Color(0xFF3B82F6).withValues(alpha: 0.1),
      ),
      StatsCardData(
        label: 'Fixed Holidays',
        value: '$fixedHolidays',
        iconPath: Assets.icons.clockIcon.path,
        iconColor: const Color(0xFF9333EA),
        iconBackground: const Color(0xFF9333EA).withValues(alpha: 0.1),
      ),
      StatsCardData(
        label: 'Islamic Holidays',
        value: '$islamicHolidays',
        iconPath: Assets.icons.leaveManagementIcon.path,
        iconColor: const Color(0xFF22C55E),
        iconBackground: const Color(0xFF22C55E).withValues(alpha: 0.1),
      ),
      StatsCardData(
        label: 'Paid Holidays',
        value: '$paidHolidays',
        iconPath: Assets.icons.sidebar.scheduleAssignments.path,
        iconColor: const Color(0xFFEA580C),
        iconBackground: const Color(0xFFEA580C).withValues(alpha: 0.1),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: StatsCard(data: stats[0])),
              SizedBox(width: spacing),
              Expanded(child: StatsCard(data: stats[1])),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: StatsCard(data: stats[2])),
              SizedBox(width: spacing),
              Expanded(child: StatsCard(data: stats[3])),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: StatsCard(data: stats[0])),
        SizedBox(width: spacing),
        Expanded(child: StatsCard(data: stats[1])),
        SizedBox(width: spacing),
        Expanded(child: StatsCard(data: stats[2])),
        SizedBox(width: spacing),
        Expanded(child: StatsCard(data: stats[3])),
      ],
    );
  }
}
