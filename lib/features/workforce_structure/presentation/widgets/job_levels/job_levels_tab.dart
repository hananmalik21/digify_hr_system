import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_levels_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobLevelNotifierProvider.notifier).loadFirstPage();
    });
  }

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
        const JobLevelsHeader(),
        Gap(24.h),
        if (paginationState.isLoading && paginationState.items.isEmpty)
          const JobLevelSkeleton(rowCount: 6)
        else if (paginationState.hasError && paginationState.items.isEmpty)
          DigifyErrorState(
            message: paginationState.errorMessage ?? 'Failed to load job levels',
            onRetry: () => ref.read(jobLevelNotifierProvider.notifier).refresh(),
          )
        else
          JobLevelsTable(jobLevels: jobLevels),
        if (paginationState.isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
          ),
      ],
    );
  }
}
