import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../providers/overtime/overtime_enterprise_provider.dart';
import '../dialogs/edit_overtime_request_dialog/edit_overtime_request_dialog.dart';
import '../dialogs/new_overtime_request_dialog.dart';
import '../providers/overtime/overtime_provider.dart';
import '../widgets/overtime/component_overtime_filter_bar.dart';
import '../widgets/overtime/search/component_overtime_search_and_actions.dart';
import '../widgets/overtime/component_overtime_stats.dart';
import '../widgets/overtime/table/component_overtime_table.dart';

class OvertimeScreen extends ConsumerStatefulWidget {
  const OvertimeScreen({super.key});

  @override
  ConsumerState<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends ConsumerState<OvertimeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(overtimeManagementProvider.notifier).loadOvertime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(overtimeManagementProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            DigifyTabHeader(
              title: 'Overtime',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: localizations.export,
                    onPressed: () {},
                    svgPath: Assets.icons.downloadIcon.path,
                    backgroundColor: AppColors.shiftExportButton,
                  ),
                  Gap(8.w),
                  AppButton.primary(
                    label: localizations.requestOvertime,
                    svgPath: Assets.icons.addNewIconFigma.path,
                    onPressed: () => NewOvertimeRequestDialog.show(context),
                  ),
                ],
              ),
            ),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: ref.watch(overtimeEnterpriseIdProvider),
              onEnterpriseChanged: (id) => ref.read(overtimeSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
              subtitle: ref.watch(overtimeEnterpriseIdProvider) != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            const ComponentOvertimeFilterBar(),
            const ComponentOvertimeStats(),
            OvertimeSearchAndActions(localizations: localizations, isDark: isDark),
            OvertimeTable(
              localizations: localizations,
              records: state.records ?? [],
              totalItems: state.totalItems,
              isLoading: state.isLoading,
              currentPage: state.currentPage,
              pageSize: state.pageSize,
              paginationIsLoading: state.isLoading && (state.records?.isNotEmpty ?? false),
              onPrevious: state.currentPage > 1
                  ? () => ref.read(overtimeManagementProvider.notifier).goToPage(state.currentPage - 1)
                  : null,
              onNext: state.hasMore
                  ? () => ref.read(overtimeManagementProvider.notifier).goToPage(state.currentPage + 1)
                  : null,
              isDark: isDark,
              onEdit: (record) => EditOvertimeRequestDialog.show(context, record),
            ),
          ],
        ),
      ),
    );
  }
}
