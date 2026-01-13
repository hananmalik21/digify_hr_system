import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_card.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeStructureTab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const GradeStructureTab({super.key, this.scrollController});

  @override
  ConsumerState<GradeStructureTab> createState() => _GradeStructureTabState();
}

class _GradeStructureTabState extends ConsumerState<GradeStructureTab> with ScrollPaginationMixin {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradeNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  void onLoadMore() {
    final state = ref.read(gradeNotifierProvider);
    if (state.hasNextPage && !state.isLoadingMore) {
      ref.read(gradeNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeState = ref.watch(gradeNotifierProvider);
    final grades = gradeState.items;
    final isLoading = gradeState.isLoading;
    final errorMessage = gradeState.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradeStructureHeader(),
        Gap(24.h),
        if (isLoading && grades.isEmpty)
          const GradeStructureSkeleton()
        else if (errorMessage != null && grades.isEmpty)
          DigifyErrorState(message: errorMessage, onRetry: () => ref.read(gradeNotifierProvider.notifier).refresh())
        else if (grades.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Text('No grades found', style: context.textTheme.bodyMedium),
            ),
          )
        else
          Column(
            children: grades.map((grade) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: GradeStructureCard(grade: grade),
              );
            }).toList(),
          ),
        if (gradeState.isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
          ),
      ],
    );
  }
}
