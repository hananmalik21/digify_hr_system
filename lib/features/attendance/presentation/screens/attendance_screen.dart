import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/attendance_pagination.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/attendance_stat_card.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/attendance_table.dart';
import 'package:digify_hr_system/features/attendance/presentation/widgets/enterprise_filters_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/export_button.dart';
import '../../../../core/widgets/buttons/import_button.dart';
import '../../../../core/widgets/forms/date_selection_field.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  final TextEditingController _employeeNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _employeeNumberController.text = ref.read(attendanceProvider).employeeNumber;
  }

  @override
  void dispose() {
    _employeeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(attendanceProvider);
    final notifier = ref.read(attendanceProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            // Header Section
            context.isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderTitle(context, isDark),
                      Gap(16.h),
                      _buildHeaderActions(context.isMobile),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderTitle(context, isDark),
                      _buildHeaderActions(context.isMobile),
                    ],
                  ),
            Gap(24.h),

            // Date & Employee Filters Card
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  width: 1,
                ),
              ),
              child: context.isMobile
                  ? Column(
                      children: [
                        DateSelectionField(
                          label: 'From Date',
                          date: state.fromDate,
                          onDateSelected: (date) => notifier.setFromDate(date),
                          labelIconPath: Assets.icons.attendanceIcon.path,
                        ),
                        Gap(16.h),
                        DateSelectionField(
                          label: 'To Date',
                          date: state.toDate,
                          onDateSelected: (date) => notifier.setToDate(date),
                          labelIconPath: Assets.icons.attendanceIcon.path,
                        ),
                        Gap(16.h),
                        DigifyTextField(
                          labelText: 'Employee Number',
                          hintText: 'Enter employee number...',
                          controller: _employeeNumberController,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20.r),
                          ),
                          onChanged: (value) => notifier.setEmployeeNumber(value),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: DateSelectionField(
                            label: 'From Date',
                            date: state.fromDate,
                            onDateSelected: (date) => notifier.setFromDate(date),
                            labelIconPath: Assets.icons.attendanceIcon.path,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: DateSelectionField(
                            label: 'To Date',
                            date: state.toDate,
                            onDateSelected: (date) => notifier.setToDate(date),
                            labelIconPath: Assets.icons.attendanceIcon.path,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: DigifyTextField(
                            labelText: 'Employee Number',
                            hintText: 'Enter employee number...',
                            controller: _employeeNumberController,
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20.r),
                            ),
                            onChanged: (value) => notifier.setEmployeeNumber(value),
                          ),
                        ),
                      ],
                    ),
            ),
            Gap(24.h),

            // Statistics Grid
            Builder(
              builder: (context) {
                final isMobile = context.isMobile;
                final cards = [
                  AttendanceStatCard(
                    label: 'Total Staff',
                    value: state.totalStaff.toString(),
                    iconPath: Assets.icons.workforceStructureIcon.path,
                    iconBackgroundColor: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Present',
                    value: state.present.toString(),
                    icon: Icons.check_circle_outline,
                    iconBackgroundColor: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Late',
                    value: state.late_count.toString(),
                    icon: Icons.access_time,
                    iconBackgroundColor: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Absent',
                    value: state.absent.toString(),
                    icon: Icons.cancel_outlined,
                    iconBackgroundColor: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'Half Day',
                    value: state.halfDay.toString(),
                    icon: Icons.timer_outlined,
                    iconBackgroundColor: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                  AttendanceStatCard(
                    label: 'On Leave',
                    value: state.onLeave.toString(),
                    iconPath: Assets.icons.leaveManagementIcon.path,
                    iconBackgroundColor: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    isDark: isDark,
                  ),
                ];

                if (isMobile) {
                  return Wrap(
                    spacing: 16.w,
                    runSpacing: 16.h,
                    children: cards
                        .map((card) => SizedBox(
                              width: (context.screenWidth - 64.w) / 2, // 2 cards per row
                              child: card,
                            ))
                        .toList(),
                  );
                }

                return Row(
                  children: cards.map((card) => Expanded(child: Padding(
                    padding: EdgeInsets.only(right: card == cards.last ? 0 : 16.w),
                    child: card,
                  ))).toList(),
                );
              },
            ),
            Gap(24.h),

            // Enterprise Structure Filters Section
            EnterpriseFiltersCard(isDark: isDark),
            Gap(24.h),

            // Attendance Records Table
             AttendanceTable(
              records: state.records,
              isDark: isDark,
            ),
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
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Attendance',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
          ),
        ),
        Gap(4.h),
        Text(
          'Track and manage employee attendance records',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(bool isMobile) {
    final actions = [
      ImportButton(onTap: () {}, customLabel: 'Import'),
      Gap(12.w),
      ExportButton(onTap: () {}, customLabel: 'Export'),
      Gap(12.w),
      AppButton.primary(
        label: 'Mark Attendance',
        onPressed: () {},
        icon: Icons.add,
      ),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: actions.where((w) => w is! Gap).toList(),
      );
    }

    return Row(children: actions);
  }
}
