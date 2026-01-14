import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/leave_entitlements_section.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/leave_filter_tabs.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/leave_requests_table.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/dialogs/new_leave_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveManagementScreen extends ConsumerStatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  ConsumerState<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends ConsumerState<LeaveManagementScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(top: 15.h, start: 32.w, end: 32.w, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = ResponsiveHelper.isMobile(context);
                
                if (isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.leaveManagement,
                        style: TextStyle(
                          fontSize: 18.6.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          height: 30 / 18.6,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        localizations.manageEmployeeLeaveRequests,
                        style: TextStyle(
                          fontSize: 15.1.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          height: 24 / 15.1,
                        ),
                      ),
                      Gap(16.h),
                      SizedBox(
                        width: double.infinity,
                        child:                              AppButton.primary(
                               label: localizations.newLeaveRequest,
                               svgPath: Assets.icons.addIcon.path,
                               onPressed: () {
                                 NewLeaveRequestDialog.show(context);
                               },
                             ),
                      ),
                    ],
                  );
                }
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.leaveManagement,
                            style: TextStyle(
                              fontSize: 18.6.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              height: 30 / 18.6,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            localizations.manageEmployeeLeaveRequests,
                            style: TextStyle(
                              fontSize: 15.1.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              height: 24 / 15.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.w),
                             AppButton.primary(
                               label: localizations.newLeaveRequest,
                               svgPath: Assets.icons.addIcon.path,
                               onPressed: () {
                                 NewLeaveRequestDialog.show(context);
                               },
                             ),
                  ],
                );
              },
            ),
            Gap(24.h),
            // Leave Entitlements Section
            const LeaveEntitlementsSection(),
            Gap(24.h),
            // Filter Tabs
            LeaveFilterTabs(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
            Gap(8.h),
            // Leave Requests Table
            LeaveRequestsTable(
              filter: _selectedFilter,
            ),
          ],
        ),
      ),
    );
  }
}
