import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_enterprise_selector.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_empty_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_list.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/components/job_family_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobFamiliesTab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const JobFamiliesTab({super.key, this.scrollController});

  @override
  ConsumerState<JobFamiliesTab> createState() => _JobFamiliesTabState();
}

class _JobFamiliesTabState extends ConsumerState<JobFamiliesTab> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final paginationState = ref.watch(jobFamilyNotifierProvider);
    final jobLevels = ref.watch(jobLevelListProvider);

    return _buildContent(context, localizations, paginationState, jobLevels, isDark);
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations localizations,
    paginationState,
    List<JobLevel> jobLevels,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WorkforceTabEnterpriseSelector(tab: WorkforceTab.jobFamilies),
        Gap(24.h),
        _buildMainContent(context, localizations, paginationState, jobLevels, isDark),
      ],
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    AppLocalizations localizations,
    dynamic paginationState,
    List<JobLevel> jobLevels,
    bool isDark,
  ) {
    if (paginationState.isLoading && paginationState.items.isEmpty) {
      return const JobFamilySkeleton();
    }

    // Show error if no items and has error
    if (paginationState.hasError && paginationState.items.isEmpty) {
      return DigifyErrorState(
        message: paginationState.errorMessage ?? 'Failed to load job families',
        onRetry: () => ref.read(jobFamilyNotifierProvider.notifier).refresh(),
      );
    }

    // Show empty state
    if (paginationState.isEmpty) {
      return const JobFamilyEmptyState();
    }

    return JobFamilyList(
      paginationState: paginationState,
      jobLevels: jobLevels,
      localizations: localizations,
      isDark: isDark,
      onPrevious: paginationState.hasPreviousPage
          ? () => ref.read(jobFamilyNotifierProvider.notifier).goToPage(paginationState.currentPage - 1)
          : null,
      onNext: paginationState.hasNextPage
          ? () => ref.read(jobFamilyNotifierProvider.notifier).goToPage(paginationState.currentPage + 1)
          : null,
    );
  }
}
