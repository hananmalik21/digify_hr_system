import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_provider.dart';
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
      ref.read(publicHolidaysNotifierProvider.notifier).loadHolidays(refresh: true);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(publicHolidaysNotifierProvider);
    final notifier = ref.read(publicHolidaysNotifierProvider.notifier);
    final holidayGroups = PublicHolidayMapper.groupByMonth(state.holidays);
    PublicHolidayMapper.calculateStats(state.holidays);

    ref.listen<PublicHolidaysState>(publicHolidaysNotifierProvider, (previous, next) {
      if (previous == null) return;

      if (next.deleteSuccessMessage != null && previous.deleteSuccessMessage != next.deleteSuccessMessage) {
        ToastService.success(context, next.deleteSuccessMessage!);
        notifier.clearSideEffects();
      }

      if (next.deleteErrorMessage != null && previous.deleteErrorMessage != next.deleteErrorMessage) {
        ToastService.error(context, next.deleteErrorMessage!);
        notifier.clearSideEffects();
      }

      if (next.createSuccessMessage != null && previous.createSuccessMessage != next.createSuccessMessage) {
        ToastService.success(context, next.createSuccessMessage!);
        notifier.clearSideEffects();
      }

      if (next.createErrorMessage != null && previous.createErrorMessage != next.createErrorMessage) {
        ToastService.error(context, next.createErrorMessage!);
        notifier.clearSideEffects();
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
              notifier.setSelectedYear(_selectedYear == PublicHolidaysConfig.defaultYear ? null : _selectedYear);
            },
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type ?? PublicHolidaysConfig.defaultType;
              });
              notifier.setSelectedType(_selectedType == PublicHolidaysConfig.defaultType ? null : _selectedType);
            },
            onSearchChanged: (query) => notifier.setSearchQuery(query),
            onAddHoliday: () => CreateHolidayDialog.show(context),
            onImport: () {},
            onExport: () {},
          ),
          Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          if (state.isLoading && state.holidays.isEmpty)
            const PublicHolidaysSkeleton(groupCount: 3, holidaysPerGroup: 2)
          else if (state.hasError)
            DigifyErrorState(message: state.errorMessage ?? 'An error occurred', onRetry: () => notifier.refresh())
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
                      final holiday = notifier.getHolidayById(holidayIdInt);
                      if (holiday != null) {
                        ViewHolidayDialog.show(context, holiday: holiday);
                      }
                    },
                    onEditHoliday: (id) {
                      final holidayIdInt = int.tryParse(id);
                      if (holidayIdInt == null) return;
                      final holiday = notifier.getHolidayById(holidayIdInt);
                      if (holiday != null) {
                        CreateHolidayDialog.show(context, holiday: holiday);
                      }
                    },
                    onDeleteHoliday: (id) => _handleDeleteHoliday(context, id, notifier, state),
                  ),
                  Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
                ],
              ),
            ),
          if (state.hasMore && !state.isLoadingMore)
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: ElevatedButton(onPressed: () => notifier.loadNextPage(), child: const Text('Load More')),
              ),
            )
          else if (state.isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
            ),
        ],
      ),
    );
  }
}
