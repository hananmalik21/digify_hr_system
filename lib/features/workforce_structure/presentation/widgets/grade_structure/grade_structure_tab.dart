import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_card.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeStructureTab extends ConsumerWidget {
  const GradeStructureTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeStructures = ref.watch(gradeStructureListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradeStructureHeader(),
        SizedBox(height: 24.h),
        Column(
          children: gradeStructures.map((grade) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: GradeStructureCard(grade: grade),
            );
          }).toList(),
        ),
      ],
    );
  }
}
