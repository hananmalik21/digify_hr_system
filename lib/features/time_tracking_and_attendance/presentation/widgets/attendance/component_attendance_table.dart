import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/pagination_controls.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'attendance_expanded_panel.dart';
import 'attendance_table_header.dart';
import 'attendance_table_row.dart';
import 'attendance_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceTable extends ConsumerWidget {
  final List<AttendanceRecord> records;
  final bool isDark;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final bool isLoading;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const AttendanceTable({
    super.key,
    required this.records,
    required this.isDark,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    this.isLoading = false,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedIndex = ref.watch(attendanceExpandedIndexProvider);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AttendanceTableHeader(isDark: isDark),
                  if (isLoading)
                    AttendanceTableSkeleton(isDark: isDark)
                  else if (records.isEmpty)
                    SizedBox(
                      width: AttendanceTableConfig.totalWidth.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.h),
                        child: Center(
                          child: Text(
                            localizations.noResultsFound,
                            style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(records.length, (index) {
                      final record = records[index];
                      final isExpanded = expandedIndex == index;
                      final isLast = index == records.length - 1;

                      return Column(
                        children: [
                          AttendanceTableRow(
                            record: record,
                            isDark: isDark,
                            isExpanded: isExpanded,
                            onToggle: () {
                              final notifier = ref.read(attendanceExpandedIndexProvider.notifier);
                              if (expandedIndex == index) {
                                notifier.state = null;
                              } else {
                                notifier.state = index;
                              }
                            },
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isExpanded) AttendanceExpandedPanel(record: record, isDark: isDark),
                                if (isExpanded && !isLast)
                                  Divider(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalItems == 0 ? 1 : (totalItems / pageSize).ceil(),
            totalItems: totalItems,
            pageSize: pageSize,
            hasNext: (currentPage * pageSize) < totalItems,
            hasPrevious: currentPage > 1,
            onPrevious: onPrevious,
            onNext: onNext,
            isLoading: false,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
