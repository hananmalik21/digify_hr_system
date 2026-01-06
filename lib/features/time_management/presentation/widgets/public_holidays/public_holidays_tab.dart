import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_compliance_banner.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_stats_cards.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/mappers/public_holiday_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(publicHolidaysNotifierProvider);
    final notifier = ref.read(publicHolidaysNotifierProvider.notifier);
    final holidayGroups = PublicHolidayMapper.groupByMonth(state.holidays);
    final stats = PublicHolidayMapper.calculateStats(state.holidays);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PublicHolidaysComplianceBanner(),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          PublicHolidaysStatsCards(
            totalHolidays: stats.totalHolidays,
            fixedHolidays: stats.fixedHolidays,
            islamicHolidays: stats.islamicHolidays,
            paidHolidays: stats.paidHolidays,
            isDark: isDark,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
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
            onSearchChanged: (query) {
              notifier.setSearchQuery(query.isEmpty ? null : query);
            },
            onAddHoliday: () {},
            onImport: () {},
            onExport: () {},
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          if (state.isLoading && state.holidays.isEmpty)
            const PublicHolidaysSkeleton(groupCount: 3, holidaysPerGroup: 2)
          else if (state.hasError)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Text(state.errorMessage ?? 'An error occurred', style: TextStyle(color: AppColors.error)),
                    SizedBox(height: 16.h),
                    ElevatedButton(onPressed: () => notifier.refresh(), child: const Text('Retry')),
                  ],
                ),
              ),
            )
          else if (holidayGroups.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  'No holidays found',
                  style: TextStyle(
                    fontSize: 16.sp,
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
                    onViewHoliday: (id) {},
                    onEditHoliday: (id) {},
                    onDeleteHoliday: (id) {},
                  ),
                  SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
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
