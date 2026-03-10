import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/dialogs/create_holiday_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/dialogs/view_holiday_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/mappers/public_holiday_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PublicHolidaysTab extends ConsumerStatefulWidget {
  const PublicHolidaysTab({super.key});

  @override
  ConsumerState<PublicHolidaysTab> createState() => _PublicHolidaysTabState();
}

class _PublicHolidaysTabState extends ConsumerState<PublicHolidaysTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedYear = PublicHolidaysConfig.defaultYear;
  String _selectedType = PublicHolidaysConfig.defaultType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(publicHolidaysTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(publicHolidaysNotifierProvider(enterpriseId).notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleDeleteHoliday(
    BuildContext context,
    String holidayId,
    PublicHolidaysNotifier notifier,
    PublicHolidaysState state,
  ) async {
    final holidayIdInt = int.tryParse(holidayId);
    if (holidayIdInt == null) return;

    final holiday = state.holidays.firstWhere((h) => h.id == holidayIdInt, orElse: () => state.holidays.first);
    final holidayName = holiday.nameEn;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Holiday',
      message: 'Are you sure you want to permanently delete this holiday?',
      itemName: holidayName,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed == true && mounted) {
      notifier.deleteHoliday(holidayIdInt, hard: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveEnterpriseId = ref.watch(publicHolidaysTabEnterpriseIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = effectiveEnterpriseId != null
        ? ref.watch(publicHolidaysNotifierProvider(effectiveEnterpriseId))
        : const PublicHolidaysState();
    final notifier = effectiveEnterpriseId != null
        ? ref.read(publicHolidaysNotifierProvider(effectiveEnterpriseId).notifier)
        : null;
    final holidayGroups = PublicHolidayMapper.groupByMonth(state.holidays);
    PublicHolidayMapper.calculateStats(state.holidays);

    if (effectiveEnterpriseId == null) {
      return const Center(
        child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view public holidays'),
      );
    }

    final notifierRef = notifier!;
    ref.listen<PublicHolidaysState>(publicHolidaysNotifierProvider(effectiveEnterpriseId), (previous, next) {
      if (previous == null) return;

      if (next.deleteSuccessMessage != null && previous.deleteSuccessMessage != next.deleteSuccessMessage) {
        ToastService.success(context, next.deleteSuccessMessage!);
        notifierRef.clearSideEffects();
      }

      if (next.deleteErrorMessage != null && previous.deleteErrorMessage != next.deleteErrorMessage) {
        ToastService.error(context, next.deleteErrorMessage!);
        notifierRef.clearSideEffects();
      }

      if (next.createSuccessMessage != null && previous.createSuccessMessage != next.createSuccessMessage) {
        ToastService.success(context, next.createSuccessMessage!);
        notifierRef.clearSideEffects();
      }

      if (next.createErrorMessage != null && previous.createErrorMessage != next.createErrorMessage) {
        ToastService.error(context, next.createErrorMessage!);
        notifierRef.clearSideEffects();
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PublicHolidaysActionBar(
            searchController: _searchController,
            selectedYear: _selectedYear,
            selectedType: _selectedType,
            availableYears: PublicHolidaysConfig.availableYears,
            availableTypes: PublicHolidaysConfig.availableTypes,
            onYearChanged: (year) {
              setState(() {
                _selectedYear = year ?? PublicHolidaysConfig.defaultYear;
              });
              notifierRef.setSelectedYear(_selectedYear == PublicHolidaysConfig.defaultYear ? null : _selectedYear);
            },
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type ?? PublicHolidaysConfig.defaultType;
              });
              notifierRef.setSelectedType(_selectedType == PublicHolidaysConfig.defaultType ? null : _selectedType);
            },
            onSearchChanged: (query) => notifierRef.setSearchQuery(query),
          ),
          Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          if (state.isLoading)
            const PublicHolidaysSkeleton(groupCount: 3, holidaysPerGroup: 2)
          else if (state.hasError)
            DigifyErrorState(message: state.errorMessage ?? 'An error occurred', onRetry: () => notifierRef.refresh())
          else if (holidayGroups.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  'No holidays found',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...holidayGroups.map(
              (group) => Column(
                children: [
                  MonthlyHolidayGroup(
                    data: group,
                    onViewHoliday: (id) {
                      final holidayIdInt = int.tryParse(id);
                      if (holidayIdInt == null) return;
                      final holiday = notifierRef.getHolidayById(holidayIdInt);
                      if (holiday != null) {
                        ViewHolidayDialog.show(context, holiday: holiday);
                      }
                    },
                    onEditHoliday: (id) {
                      final holidayIdInt = int.tryParse(id);
                      if (holidayIdInt == null) return;
                      final holiday = notifierRef.getHolidayById(holidayIdInt);
                      if (holiday != null) {
                        CreateHolidayDialog.show(context, enterpriseId: effectiveEnterpriseId, holiday: holiday);
                      }
                    },
                    onDeleteHoliday: (id) => _handleDeleteHoliday(context, id, notifierRef, state),
                  ),
                  Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
                ],
              ),
            ),
          Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          if (state.totalPages > 0) ...[
            PaginationControls.fromPaginationInfo(
              paginationInfo: PaginationInfo(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                totalItems: state.totalItems,
                pageSize: state.pageSize,
                hasNext: state.hasNextPage,
                hasPrevious: state.hasPreviousPage,
              ),
              currentPage: state.currentPage,
              pageSize: state.pageSize,
              onPrevious: state.hasPreviousPage ? () => notifierRef.goToPage(state.currentPage - 1) : null,
              onNext: state.hasNextPage ? () => notifierRef.goToPage(state.currentPage + 1) : null,
              style: PaginationStyle.simple,
            ),
            Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          ],
        ],
      ),
    );
  }
}
