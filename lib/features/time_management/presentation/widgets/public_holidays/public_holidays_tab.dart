import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/public_holidays_mock_datasource.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_compliance_banner.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/public_holidays_stats_cards.dart';
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

  // Get mock data from data source
  late final List<MonthlyHolidayGroupData> _holidayGroups = PublicHolidaysMockDataSource.getMockHolidayGroups();
  late final PublicHolidaysStats _stats = PublicHolidaysMockDataSource.getMockStats();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PublicHolidaysComplianceBanner(),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          PublicHolidaysStatsCards(
            totalHolidays: _stats.totalHolidays,
            fixedHolidays: _stats.fixedHolidays,
            islamicHolidays: _stats.islamicHolidays,
            paidHolidays: _stats.paidHolidays,
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
            },
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type ?? PublicHolidaysConfig.defaultType;
              });
            },
            onSearchChanged: (query) {
              // Handle search
            },
            onAddHoliday: () {
              // Handle add holiday
            },
            onImport: () {
              // Handle import
            },
            onExport: () {
              // Handle export
            },
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
          ..._holidayGroups.map(
            (group) => Column(
              children: [
                MonthlyHolidayGroup(
                  data: group,
                  onViewHoliday: (id) {
                    // Handle view holiday
                  },
                  onEditHoliday: (id) {
                    // Handle edit holiday
                  },
                  onDeleteHoliday: (id) {
                    // Handle delete holiday
                  },
                ),
                SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
