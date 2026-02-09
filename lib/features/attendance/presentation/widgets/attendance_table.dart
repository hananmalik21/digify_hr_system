import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AttendanceTable extends StatelessWidget {
  final List<AttendanceRecord> records;
  final bool isDark;

  const AttendanceTable({
    super.key,
    required this.records,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Info
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Records - ${DateFormat('d/M/yyyy').format(records.isNotEmpty ? records.first.date : DateTime.now())}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
                  ),
                ),
                Gap(4.h),
                Text(
                  'Showing ${records.length} employees',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Table Content
          LayoutBuilder(
            builder: (context, constraints) {
              return ScrollableSingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: SizedBox(
                    width: 1000.w > constraints.maxWidth ? 1000.w : constraints.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table Header Row
                        _buildTableHeader(context),
                        // Table Data Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: records.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                          ),
                          itemBuilder: (context, index) {
                            return _buildTableRow(context, records[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final headerStyle = context.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      color: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.5) : const Color(0xFFF9FAFB),
      child: Row(
        children: [
          SizedBox(width: 40.w), // Space for expand icon
          Expanded(flex: 3, child: Text('Employee', style: headerStyle)),
          Expanded(flex: 2, child: Text('Department', style: headerStyle)),
          Expanded(flex: 2, child: Text('Date', style: headerStyle)),
          Expanded(flex: 2, child: Text('Check In', style: headerStyle)),
          Expanded(flex: 2, child: Text('Check Out', style: headerStyle)),
          Expanded(flex: 2, child: Text('Status', style: headerStyle)),
          SizedBox(width: 80.w, child: Text('Actions', style: headerStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, AttendanceRecord record) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          // Expand Icon
          SizedBox(
            width: 40.w,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? AppColors.textTertiaryDark : const Color(0xFF9CA3AF),
              size: 20.r,
            ),
          ),
          // Employee
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    record.avatarInitials,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Gap(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.employeeName,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
                      ),
                    ),
                    Text(
                      record.employeeId,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : const Color(0xFF717182),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Department
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 16.r,
                  color: AppColors.primary,
                ),
                Gap(8.w),
                Text(
                  record.departmentName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
                  ),
                ),
              ],
            ),
          ),
          // Date
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('MMM d, yyyy').format(record.date),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
              ),
            ),
          ),
          // Check In
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.r,
                  color: AppColors.primary,
                ),
                Gap(8.w),
                Text(
                  record.checkIn ?? '-',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
                  ),
                ),
              ],
            ),
          ),
          // Check Out
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.r,
                  color: AppColors.primary,
                ),
                Gap(8.w),
                Text(
                  record.checkOut ?? '-',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B),
                  ),
                ),
              ],
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: _buildStatusChip(record.status),
          ),
          // Actions
          SizedBox(
            width: 80.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, size: 18.r, color: Colors.grey),
                Gap(12.w),
                Icon(Icons.location_on_outlined, size: 18.r, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Present':
        bgColor = const Color(0xFFEFF6FF);
        textColor = AppColors.primary;
        break;
      case 'Late':
        bgColor = const Color(0xFFFEF9C2);
        textColor = const Color(0xFF854D0E);
        break;
      case 'Absent':
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFF991B1B);
        break;
      case 'Early':
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF166534);
        break;
      case 'On Leave':
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
        break;
      case 'Official Work':
        bgColor = const Color(0xFFEFF6FF);
        textColor = AppColors.primary;
        break;
      case 'Business Trip':
        bgColor = const Color(0xFFEFF6FF);
        textColor = AppColors.primary;
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
    }

    return DigifyCapsule(
      label: status,
      backgroundColor: bgColor,
      textColor: textColor,
    );
  }
}
