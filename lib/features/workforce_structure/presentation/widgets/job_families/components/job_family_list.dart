import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamilyList extends StatelessWidget {
  final PaginationState<JobFamily> paginationState;
  final List<JobLevel> jobLevels;
  final AppLocalizations localizations;
  final bool isDark;

  const JobFamilyList({
    super.key,
    required this.paginationState,
    required this.jobLevels,
    required this.localizations,
    required this.isDark,
    this.onPrevious,
    this.onNext,
  });

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 500.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final spacing = 24.w;
              final runSpacing = 24.h;
              final targetCardWidth = 466.0;

              final columns = maxW < 600
                  ? 1
                  : maxW < 900
                  ? 2
                  : 3;
              final computed = (maxW - (spacing * (columns - 1))) / columns;
              final cardWidth = computed > targetCardWidth ? targetCardWidth : computed;

              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: paginationState.items.asMap().entries.map<Widget>((entry) {
                  final jobFamily = entry.value;

                  return SizedBox(
                    width: cardWidth,
                    child: JobFamilyCard(
                      jobFamily: jobFamily,
                      jobLevels: jobLevels,
                      localizations: localizations,
                      isDark: isDark,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        if (paginationState.totalPages > 0) ...[
          Gap(24.h),
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: paginationState.currentPage,
              totalPages: paginationState.totalPages,
              totalItems: paginationState.totalItems,
              pageSize: paginationState.pageSize,
              hasNext: paginationState.hasNextPage,
              hasPrevious: paginationState.hasPreviousPage,
            ),
            currentPage: paginationState.currentPage,
            pageSize: paginationState.pageSize,
            onPrevious: onPrevious,
            onNext: onNext,
            isLoading: paginationState.isLoading,
            style: PaginationStyle.simple,
          ),
          Gap(24.h),
        ],
      ],
    );
  }
}
