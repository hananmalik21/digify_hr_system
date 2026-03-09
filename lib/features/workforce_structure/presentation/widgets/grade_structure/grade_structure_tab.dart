import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_enterprise_selector.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_card.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeStructureTab extends ConsumerStatefulWidget {
  const GradeStructureTab({super.key});

  @override
  ConsumerState<GradeStructureTab> createState() => _GradeStructureTabState();
}

class _GradeStructureTabState extends ConsumerState<GradeStructureTab> {
  @override
  Widget build(BuildContext context) {
    final gradeState = ref.watch(gradeNotifierProvider);
    final grades = gradeState.items;
    final isLoading = gradeState.isLoading;
    final errorMessage = gradeState.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkforceTabEnterpriseSelector(tab: WorkforceTab.gradeStructure),
        Gap(24.h),
        if (isLoading)
          const GradeStructureSkeleton()
        else if (errorMessage != null && grades.isEmpty)
          DigifyErrorState(message: errorMessage, onRetry: () => ref.read(gradeNotifierProvider.notifier).refresh())
        else if (grades.isEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 64.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_outlined, size: 64.sp, color: AppColors.textSecondary),
                    SizedBox(height: 16.h),
                    Text(
                      'No grades found',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Create your first grade to get started',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: Column(
              children: grades.map((grade) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GradeStructureCard(grade: grade),
                );
              }).toList(),
            ),
          ),
        if (gradeState.totalPages > 0) ...[
          Gap(24.h),
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: gradeState.currentPage,
              totalPages: gradeState.totalPages,
              totalItems: gradeState.totalItems,
              pageSize: gradeState.pageSize,
              hasNext: gradeState.hasNextPage,
              hasPrevious: gradeState.hasPreviousPage,
            ),
            currentPage: gradeState.currentPage,
            pageSize: gradeState.pageSize,
            onPrevious: gradeState.hasPreviousPage
                ? () => ref.read(gradeNotifierProvider.notifier).goToPage(gradeState.currentPage - 1)
                : null,
            onNext: gradeState.hasNextPage
                ? () => ref.read(gradeNotifierProvider.notifier).goToPage(gradeState.currentPage + 1)
                : null,
            style: PaginationStyle.simple,
          ),
        ],
      ],
    );
  }
}
