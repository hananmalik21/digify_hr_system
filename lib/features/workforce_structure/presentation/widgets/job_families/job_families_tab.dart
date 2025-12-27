import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_empty_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_list.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamiliesTab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const JobFamiliesTab({super.key, this.scrollController});

  @override
  ConsumerState<JobFamiliesTab> createState() => _JobFamiliesTabState();
}

class _JobFamiliesTabState extends ConsumerState<JobFamiliesTab>
    with ScrollPaginationMixin {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobFamilyNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onLoadMore() {
    final state = ref.read(jobFamilyNotifierProvider);
    if (state.hasNextPage && !state.isLoadingMore) {
      ref.read(jobFamilyNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final paginationState = ref.watch(jobFamilyNotifierProvider);
    final jobLevels = ref.watch(jobLevelListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JobFamilyHeader(localizations: localizations),
        SizedBox(height: 24.h),
        _buildContent(
          context,
          localizations,
          paginationState,
          jobLevels,
          isDark,
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations localizations,
    paginationState,
    List<JobLevel> jobLevels,
    bool isDark,
  ) {
    // Show loading for first page
    if (paginationState.isLoading && paginationState.items.isEmpty) {
      return const JobFamilySkeleton();
    }

    // Show error if no items and has error
    if (paginationState.hasError && paginationState.items.isEmpty) {
      return JobFamilyErrorState(
        errorMessage: paginationState.errorMessage,
        onRetry: () => ref.read(jobFamilyNotifierProvider.notifier).refresh(),
      );
    }

    // Show empty state
    if (paginationState.isEmpty) {
      return const JobFamilyEmptyState();
    }

    // Show list with pagination
    return JobFamilyList(
      paginationState: paginationState,
      jobLevels: jobLevels,
      localizations: localizations,
      isDark: isDark,
    );
  }
}
