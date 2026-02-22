import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelsTab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const JobLevelsTab({super.key, this.scrollController});

  @override
  ConsumerState<JobLevelsTab> createState() => _JobLevelsTabState();
}

class _JobLevelsTabState extends ConsumerState<JobLevelsTab> with ScrollPaginationMixin {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  void onLoadMore() {
    final state = ref.read(jobLevelNotifierProvider);
    if (state.hasNextPage && !state.isLoadingMore) {
      ref.read(jobLevelNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(jobLevelNotifierProvider);
    final jobLevels = paginationState.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (paginationState.isLoading && paginationState.items.isEmpty)
          const JobLevelSkeleton(rowCount: 6)
        else if (paginationState.hasError && paginationState.items.isEmpty)
          DigifyErrorState(
            message: paginationState.errorMessage ?? 'Failed to load job levels',
            onRetry: () => ref.read(jobLevelNotifierProvider.notifier).refresh(),
          )
        else if (jobLevels.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 64.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.layers_outlined, size: 64.sp, color: AppColors.textSecondary),
                  SizedBox(height: 16.h),
                  Text(
                    'No job levels found',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Create your first job level to get started',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          )
        else
          JobLevelsTable(jobLevels: jobLevels, paginationState: paginationState),
      ],
    );
  }
}
