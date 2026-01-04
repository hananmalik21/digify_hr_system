import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkSchedulesListSkeleton extends StatelessWidget {
  final int itemCount;

  const WorkSchedulesListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Column(
          children: [
            const WorkScheduleCardSkeleton(),
            if (index < itemCount - 1) SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
