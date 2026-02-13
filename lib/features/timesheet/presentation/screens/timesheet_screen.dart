import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/attendance_pagination.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/attendance_stat_card.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/enterprise_filters_card.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet_status.dart';
import 'package:digify_hr_system/features/timesheet/presentation/providers/timesheet_provider.dart';
import 'package:digify_hr_system/features/timesheet/presentation/widgets/timesheet_table.dart';
import 'package:digify_hr_system/features/timesheet/presentation/widgets/week_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/export_button.dart';
import '../../../../core/widgets/buttons/import_button.dart';
import '../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';

class TimesheetScreen extends ConsumerStatefulWidget {
  const TimesheetScreen({super.key});

  @override
  ConsumerState<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends ConsumerState<TimesheetScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(timesheetNotifierProvider);
    final notifier = ref.read(timesheetNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 27.w, right: 21.w, top: 61.h, bottom: 48.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            context.isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_buildHeaderTitle(context, isDark), Gap(16.h), _buildHeaderActions(context.isMobile)],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildHeaderTitle(context, isDark), _buildHeaderActions(context.isMobile)],
                  ),
            Gap(21.h),

            // Week Navigation
            WeekNavigation(
              weekStartDate: state.weekStartDate,
              weekEndDate: state.weekEndDate,
              onPreviousWeek: notifier.goToPreviousWeek,
              onNextWeek: notifier.goToNextWeek,
              onCurrentWeek: notifier.goToCurrentWeek,
              isDark: isDark,
            ),
            Gap(21.h),

            // Statistics Grid
            Builder(
              builder: (context) {
                final screenWidth = context.screenWidth;
                final padding = 48.w; // Left + right padding
                final availableWidth = screenWidth - padding;
                final spacing = 16.w;
                final minCardWidth = 150.w;
                final maxCardWidth = 200.w;
                
                // Calculate how many cards can fit per row
                final cardsPerRow = ((availableWidth + spacing) / (maxCardWidth + spacing)).floor();
                final cardWidth = cardsPerRow > 0 
                    ? ((availableWidth - (spacing * (cardsPerRow - 1))) / cardsPerRow).clamp(minCardWidth, maxCardWidth)
                    : availableWidth;

                final cards = [
                  AttendanceStatCard(
                    label: 'Total',
                    value: state.total.toString(),
                    icon: Icons.grid_view,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Draft',
                    value: state.draft.toString(),
                    icon: Icons.edit_outlined,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Submitted',
                    value: state.submitted.toString(),
                    icon: Icons.send_outlined,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Approved',
                    value: state.approved.toString(),
                    icon: Icons.check_circle_outline,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Rejected',
                    value: state.rejected.toString(),
                    icon: Icons.cancel_outlined,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Reg. Hours',
                    value: '${state.regularHours.toInt()}h',
                    icon: Icons.access_time,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'OT Hours',
                    value: '${state.overtimeHours.toInt()}h',
                    icon: Icons.access_time,
                    iconBackgroundColor: AppColors.jobRoleBg,
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                ];

                return Wrap(
                  spacing: spacing,
                  runSpacing: 16.h,
                  children: cards
                      .map(
                        (card) => SizedBox(
                          width: cardWidth,
                          child: card,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            Gap(21.h),

            // Enterprise Structure Filters Section
            EnterpriseFiltersCard(isDark: isDark),
            Gap(21.h),

            // Search and Status Filter
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
              ),
              child: context.isMobile
                  ? Column(
                      children: [
                        DigifyTextField(
                          hintText: 'Search timesheets...',
                          controller: _searchController,
                          fillColor: AppColors.cardBackground,
                          filled: true,
                          prefixIcon: Icon(Icons.search, size: 20.r, color: AppColors.textSecondary),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          onChanged: (value) => notifier.setSearchQuery(value),
                        ),
                        Gap(12.h),
                        Container(
                          height: 1,
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                        ),
                        Gap(12.h),
                        Row(
                          children: [
                            Icon(Icons.filter_list, size: 20.r, color: AppColors.textSecondary),
                            Gap(8.w),
                            Expanded(
                              child: DigifySelectField<TimesheetStatus?>(
                                hint: 'All Status',
                                value: state.statusFilter,
                                items: [null, TimesheetStatus.draft, TimesheetStatus.submitted, TimesheetStatus.approved, TimesheetStatus.rejected],
                                itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                                onChanged: (value) => notifier.setStatusFilter(value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: DigifyTextField(
                            hintText: 'Search timesheets...',
                            controller: _searchController,
                            fillColor: AppColors.cardBackground,
                            filled: true,
                            prefixIcon: Icon(Icons.search, size: 20.r, color: AppColors.textSecondary),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            onChanged: (value) => notifier.setSearchQuery(value),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                        ),
                        Row(
                          children: [
                            Icon(Icons.filter_list, size: 20.r, color: AppColors.textSecondary),
                            Gap(8.w),
                            SizedBox(
                              width: 180.w,
                              child: DigifySelectField<TimesheetStatus?>(
                                hint: 'All Status',
                                value: state.statusFilter,
                                items: [null, TimesheetStatus.draft, TimesheetStatus.submitted, TimesheetStatus.approved, TimesheetStatus.rejected],
                                itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                                onChanged: (value) => notifier.setStatusFilter(value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            Gap(21.h),

            // Timesheet Records Table
            TimesheetTable(records: state.records, isDark: isDark),
            Gap(24.h),

            // Pagination
            AttendancePagination(
              currentPage: state.currentPage,
              totalPages: (state.totalItems / state.pageSize).ceil(),
              totalItems: state.totalItems,
              itemsPerPage: state.pageSize,
              onPageChanged: notifier.setPage,
              onItemsPerPageChanged: (size) {
                if (size != null) notifier.setPageSize(size);
              },
              isDark: isDark,
            ),
          ],
        ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Sheets',
          style: context.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: isDark ? null : AppColors.dialogTitle, fontFamily: 'Inter'),
        ),
        Gap(2.h),
        Text(
          'Track and manage employee time entries',
          style: context.textTheme.bodyMedium?.copyWith(color: isDark ? null : AppColors.textSecondary, fontFamily: 'Inter'),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(bool isMobile) {
    final actions = [
      ImportButton(onTap: () {}, customLabel: 'Import'),
      Gap(11.w),
      ExportButton(onTap: () {}, customLabel: 'Export'),
      Gap(11.w),
      AppButton(
        fontSize: 14.sp,
        label: 'New Timesheet',
        onPressed: () {
          // TODO: Implement new timesheet dialog
        },
        icon: Icons.add,
        height: 35.h,
        type: AppButtonType.primary,
        borderRadius: BorderRadius.circular(7.0),
      ),
    ];

    if (isMobile) {
      return Wrap(spacing: 12.w, runSpacing: 12.h, children: actions.where((w) => w is! Gap).toList());
    }

    return Row(children: actions);
  }
}

