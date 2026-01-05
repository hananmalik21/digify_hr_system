import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_actions.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_content.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkScheduleCard extends StatelessWidget {
  final String title;
  final String? titleArabic;
  final String year;
  final String code;
  final bool isActive;
  final String workPatternName;
  final String assignmentMode;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final Map<String, String> weeklySchedule;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const WorkScheduleCard({
    super.key,
    required this.title,
    this.titleArabic,
    required this.year,
    required this.code,
    required this.isActive,
    required this.workPatternName,
    required this.assignmentMode,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.weeklySchedule,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final padding = ResponsiveHelper.getCardPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: const Color(0xFF000000).withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkScheduleCardHeader(title: title, titleArabic: titleArabic, year: year, code: code, isActive: isActive),
            SizedBox(height: 16.h),
            WorkScheduleCardContent(
              workPatternName: workPatternName,
              assignmentMode: assignmentMode,
              effectiveStartDate: effectiveStartDate,
              effectiveEndDate: effectiveEndDate,
              weeklySchedule: weeklySchedule,
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              padding: EdgeInsets.only(top: 17.h),
              child: WorkScheduleCardActions(
                onViewDetails: onViewDetails,
                onEdit: onEdit,
                onDelete: onDelete,
                isDeleting: isDeleting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
