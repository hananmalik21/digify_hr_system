import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/common/workforce_tab_enterprise_selector.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/reporting_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/components/reporting_legend.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/components/reporting_structure_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReportingStructureTab extends ConsumerWidget {
  const ReportingStructureTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(reportingStructureNotifierProvider);

    final paginationInfo = (state.totalPages > 0 || state.items.isNotEmpty)
        ? PaginationInfo(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: state.pageSize,
            hasNext: state.hasNextPage,
            hasPrevious: state.hasPreviousPage,
          )
        : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WorkforceTabEnterpriseSelector(tab: WorkforceTab.reportingStructure),
          Gap(24.h),
          ReportingStructureTable(
            localizations: localizations,
            positions: state.items,
            isDark: isDark,
            isLoading: state.isLoading,
            paginationInfo: paginationInfo,
            currentPage: state.currentPage,
            pageSize: state.pageSize,
            onPrevious: state.hasPreviousPage
                ? () => ref.read(reportingStructureNotifierProvider.notifier).goToPage(state.currentPage - 1)
                : null,
            onNext: state.hasNextPage
                ? () => ref.read(reportingStructureNotifierProvider.notifier).goToPage(state.currentPage + 1)
                : null,
          ),
          Gap(24.h),
          ReportingLegend(isDark: isDark, localizations: localizations),
          Gap(24.h),
        ],
      ),
    );
  }
}
