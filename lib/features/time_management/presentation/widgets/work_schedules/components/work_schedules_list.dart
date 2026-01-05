import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkSchedulesList extends StatelessWidget {
  final List<WorkScheduleItem> schedules;
  final Function(WorkScheduleItem) onViewDetails;
  final Function(WorkScheduleItem) onEdit;
  final Function(WorkScheduleItem) onDelete;
  final Set<int> deletingScheduleIds;

  const WorkSchedulesList({
    super.key,
    required this.schedules,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
    this.deletingScheduleIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: schedules.asMap().entries.map((entry) {
        final index = entry.key;
        final schedule = entry.value;
        return Column(
          children: [
            WorkScheduleCard(
              title: schedule.title,
              titleArabic: schedule.titleArabic,
              year: schedule.year,
              code: schedule.code,
              isActive: schedule.isActive,
              workPatternName: schedule.workPatternName,
              assignmentMode: schedule.assignmentMode,
              effectiveStartDate: schedule.effectiveStartDate,
              effectiveEndDate: schedule.effectiveEndDate,
              weeklySchedule: schedule.weeklySchedule,
              onViewDetails: () => onViewDetails(schedule),
              onEdit: () => onEdit(schedule),
              onDelete: () => onDelete(schedule),
              isDeleting: deletingScheduleIds.contains(schedule.workScheduleId),
            ),
            if (index < schedules.length - 1) SizedBox(height: 20.h),
          ],
        );
      }).toList(),
    );
  }
}

class WorkScheduleItem {
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
  final int workScheduleId;

  const WorkScheduleItem({
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
    required this.workScheduleId,
  });
}
