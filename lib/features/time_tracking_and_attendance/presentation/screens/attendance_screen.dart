import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_header.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_table.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_search_and_filter.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/attendance/attendance_enterprise_provider.dart';
import '../dialogs/mark_attendance_dialog.dart';

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
    _employeeNumberController.text = ref.read(attendanceNotifierProvider).employeeNumber;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(attendanceEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(attendanceNotifierProvider.notifier).setCompanyId(enterpriseId.toString());
      }
    });
  }

  @override
  void dispose() {
    _employeeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    ref.watch(attendanceEnterpriseSyncProvider);
    final state = ref.watch(attendanceNotifierProvider);
    final notifier = ref.read(attendanceNotifierProvider.notifier);
    final selectedEnterpriseId = ref.watch(attendanceEnterpriseIdProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            AttendanceScreenHeader(onMarkAttendance: () => MarkAttendanceDialog.show(context)),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: selectedEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(attendanceSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
              subtitle: selectedEnterpriseId != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            AttendanceSearchAndFilter(
              employeeNumberController: _employeeNumberController,
              fromDate: state.fromDate,
              toDate: state.toDate,
              onSearchChanged: notifier.setEmployeeNumber,
              onFromDateSelected: notifier.setFromDate,
              onToDateSelected: notifier.setToDate,
              onApply: notifier.applyDateFilters,
              onClear: notifier.clearDateFilters,
              isDark: isDark,
            ),
            AttendanceTable(
              records: state.records,
              isDark: isDark,
              currentPage: state.currentPage,
              pageSize: state.pageSize,
              totalItems: state.totalItems,
              isLoading: state.isLoading,
              onPrevious: state.currentPage > 1 ? () => notifier.setPage(state.currentPage - 1) : null,
              onNext: (state.currentPage * state.pageSize) < state.totalItems
                  ? () => notifier.setPage(state.currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
