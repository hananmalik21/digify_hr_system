import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_table.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobLevelSkeleton extends StatelessWidget {
  final int rowCount;

  const JobLevelSkeleton({super.key, this.rowCount = 10});

  @override
  Widget build(BuildContext context) {
    // Create dummy job levels for the skeleton
    final dummyJobLevels = List.generate(
      rowCount,
      (index) => JobLevel(
        id: index,
        nameEn: 'Skeleton Job Level Name',
        code: 'LVL0${index + 1}',
        description: 'This is a skeleton description for the job level table.',
        minGradeId: 1,
        maxGradeId: 2,
        status: 'ACTIVE',
        totalPositions: 10,
        filledPositions: 5,
        minGrade: const Grade(
          id: 1,
          gradeNumber: '1',
          gradeCategory: 'A',
          step1Salary: 0,
          step2Salary: 0,
          step3Salary: 0,
          step4Salary: 0,
          step5Salary: 0,
          status: 'ACTIVE',
          description: '',
        ),
        maxGrade: const Grade(
          id: 2,
          gradeNumber: '2',
          gradeCategory: 'A',
          step1Salary: 0,
          step2Salary: 0,
          step3Salary: 0,
          step4Salary: 0,
          step5Salary: 0,
          status: 'ACTIVE',
          description: '',
        ),
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: JobLevelsTable(jobLevels: dummyJobLevels),
    );
  }
}
