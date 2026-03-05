import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:digify_hr_system/gen/assets.gen.dart';

class TimesheetStatsGrid extends StatelessWidget {
  final int total;
  final int draft;
  final int submitted;
  final int approved;
  final int rejected;
  final double regularHours;
  final double overtimeHours;
  final bool isDark;
  final bool isLoading;

  const TimesheetStatsGrid({
    super.key,
    required this.total,
    required this.draft,
    required this.submitted,
    required this.approved,
    required this.rejected,
    required this.regularHours,
    required this.overtimeHours,
    required this.isDark,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final spacing = 12.w;
    final runSpacing = 12.h;

    final cards = [
      AttendanceStatCard(
        label: 'Total',
        value: total.toString(),
        iconPath: Assets.icons.viewIconBlueFigma.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Draft',
        value: draft.toString(),
        iconPath: Assets.icons.headIcon.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Submitted',
        value: submitted.toString(),
        iconPath: Assets.icons.submitted.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Approved',
        value: approved.toString(),
        icon: Icons.check_circle_outline,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Rejected',
        value: rejected.toString(),
        icon: Icons.cancel_outlined,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Reg. Hours',
        value: '${regularHours.toInt()}h',
        iconPath: Assets.icons.clockIcon.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'OT Hours',
        value: '${overtimeHours.toInt()}h',
        iconPath: Assets.icons.attendance.halfDay.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
    ];

    final content = isMobile
        ? Column(
            children: [
              for (var i = 0; i < cards.length; i++)
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: i < cards.length - 1 ? runSpacing : 0),
                  child: cards[i],
                ),
            ],
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final minCardWidth = 140.w;
              final countPerRow = ((availableWidth + spacing) / (minCardWidth + spacing)).floor().clamp(
                1,
                cards.length,
              );
              final cardWidth = (availableWidth - (countPerRow - 1) * spacing) / countPerRow;
              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: cards.map((card) => SizedBox(width: cardWidth, child: card)).toList(),
              );
            },
          );

    return isLoading ? Skeletonizer(enabled: true, child: content) : content;
  }
}
