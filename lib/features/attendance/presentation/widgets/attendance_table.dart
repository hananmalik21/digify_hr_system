import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/assets/digify_asset.dart';
import '../../../../gen/assets.gen.dart';

class AttendanceTable extends StatefulWidget {
  final List<AttendanceRecord> records;
  final bool isDark;

  const AttendanceTable({super.key, required this.records, required this.isDark});

  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  int? _expandedIndex; // Only one row can be expanded at a time

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null; // Collapse if already expanded
      } else {
        _expandedIndex = index; // Expand this row, collapse others
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            color: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Records - ${DateFormat('d/M/yyyy').format(widget.records.isNotEmpty ? widget.records.first.date : DateTime.now())}',
                  style: context.textTheme.titleSmall?.copyWith(color: widget.isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle),
                ),
                Gap(4.h),
                Text(
                  'Showing ${widget.records.length} employees',
                  style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400, color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
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
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: SizedBox(
                    width: 1000.w > constraints.maxWidth ? 1000.w : constraints.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table Header Row
                        Container(width: double.infinity, height: 1, color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                        _buildTableHeader(context),
                        Container(width: double.infinity, height: 1, color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                        // Table Data Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.records.length,
                          separatorBuilder: (context, index) => Divider(height: 1, color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                          itemBuilder: (context, index) {
                            final record = widget.records[index];
                            final isExpanded = _expandedIndex == index;
                            return Column(
                              children: [_buildTableRow(context, record, index, isExpanded), if (isExpanded && record.attendance != null) _buildExpandedContent(context, record.attendance!)],
                            );
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
    final headerStyle = context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: widget.isDark ? AppColors.textSecondaryDark : const Color(0xFF364153));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 11.h),
      color: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          SizedBox(width: 43.w), // Space for expand icon
          Expanded(flex: 3, child: Text('Employee', style: headerStyle)),
          Expanded(flex: 2, child: Text('Department', style: headerStyle)),
          Expanded(flex: 2, child: Text('Date', style: headerStyle)),
          Expanded(flex: 2, child: Text('Check In', style: headerStyle)),
          Expanded(flex: 2, child: Text('Check Out', style: headerStyle)),

          SizedBox(
            width: 150.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text('Status', style: headerStyle),
            ),
          ),

          SizedBox(
            width: 50.w,
            child: Text('Actions', style: headerStyle, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, AttendanceRecord record, int index, bool isExpanded) {
    return InkWell(
      onTap: () => _toggleExpansion(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expand Icon
            SizedBox(
              width: 40.w,
              child: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: widget.isDark ? AppColors.textTertiaryDark : AppColors.dialogCloseIcon, size: 20.r),
            ),
            // Employee
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.jobRoleBg,
                    child: Text(
                      record.avatarInitials,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.statIconBlue, fontFamily: 'Inter'),
                    ),
                  ),
                  Gap(6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.employeeName, style: context.textTheme.bodyMedium?.copyWith(color: widget.isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle)),
                      Gap(2.h),
                      Text(
                        record.employeeId,
                        style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: widget.isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText),
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
                  DigifyAsset(assetPath: Assets.icons.attendance.enterprise.path, width: 10, height: 10, color: AppColors.primary),
                  Gap(7.w),
                  Text(record.departmentName, style: context.textTheme.bodyMedium?.copyWith(color: widget.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
                ],
              ),
            ),
            // Date
            Expanded(
              flex: 2,
              child: Text(DateFormat('MMM d, yyyy').format(record.date), style: context.textTheme.bodyMedium?.copyWith(color: widget.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
            ),
            // Check In
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16.r, color: AppColors.primary),
                  Gap(4.w),
                  Text(record.checkIn ?? '-', style: context.textTheme.bodyMedium?.copyWith(color: widget.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
                ],
              ),
            ),
            // Check Out
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16.r, color: AppColors.primary),
                  Gap(4.w),
                  Text(record.checkOut ?? '-', style: context.textTheme.bodyMedium?.copyWith(color: widget.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
                ],
              ),
            ),

            // Status
            SizedBox(
              width: 150.w,
              child: Row(mainAxisSize: MainAxisSize.min, children: [Gap(10.w), _buildStatusChip(record.status)]),
            ),

            // Actions
            SizedBox(
              width: 50.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.edit_outlined, size: 18.r, color: Colors.grey),
                  Icon(Icons.location_on_outlined, size: 18.r, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
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

    return DigifyCapsule(label: status, backgroundColor: bgColor, textColor: textColor);
  }

  Widget _buildExpandedContent(BuildContext context, Attendance attendance) {
    return Container(
      color: widget.isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3) : const Color(0xFFF9FAFB),
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          Expanded(child: _buildScheduleCard(context, attendance)),
          Gap(16.w),
          Expanded(child: _buildActualAttendanceCard(context, attendance)),
          Gap(16.w),
          Expanded(child: _buildLocationNotesCard(context, attendance)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, Attendance attendance) {
    // Default schedule: 8:00 AM to 4:00 PM (8 hours)
    final scheduleStart = DateTime(attendance.date.year, attendance.date.month, attendance.date.day, 8, 0);
    final scheduleEnd = DateTime(attendance.date.year, attendance.date.month, attendance.date.day, 16, 0);
    final duration = 8; // hours

    return _buildDetailCard(
      context,
      title: 'Schedule Information',
      icon: Icons.calendar_today_outlined,
      children: [
        _buildDetailRow(context, 'Schedule Date', DateFormat('EEE, MMM d, yyyy').format(attendance.date)),
        Gap(12.h),
        _buildDetailRow(context, 'Schedule Start', DateFormat('MMM d @ HH:mm').format(scheduleStart), icon: Icons.access_time),
        Gap(12.h),
        _buildDetailRow(context, 'Schedule End', DateFormat('MMM d @ HH:mm').format(scheduleEnd), icon: Icons.access_time),
        Gap(12.h),
        _buildDetailRow(context, 'Duration', '$duration hours'),
      ],
    );
  }

  Widget _buildActualAttendanceCard(BuildContext context, Attendance attendance) {
    final checkInTime = attendance.clockIn != null ? DateFormat('HH:mm').format(attendance.clockIn!) : '-';
    final checkOutTime = attendance.clockOut != null ? DateFormat('HH:mm').format(attendance.clockOut!) : '-';

    // Calculate hours worked
    String hoursWorked = '-';
    int? overtimeHours;
    if (attendance.clockIn != null && attendance.clockOut != null) {
      final duration = attendance.clockOut!.difference(attendance.clockIn!);
      final totalMinutes = duration.inMinutes;
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      hoursWorked = '${hours}h ${minutes}m';

      // Calculate overtime (assuming 8 hours is standard)
      final standardHours = 8;
      if (hours > standardHours) {
        overtimeHours = hours - standardHours;
      }
    }

    return _buildDetailCard(
      context,
      title: 'Actual Attendance',
      icon: Icons.show_chart_outlined,
      children: [
        _buildDetailRow(context, 'Check In Time', checkInTime, icon: Icons.access_time),
        Gap(12.h),
        _buildDetailRow(context, 'Check Out Time', checkOutTime, icon: Icons.access_time),
        Gap(12.h),
        _buildDetailRow(context, 'Hours Worked', hoursWorked, highlight: true),
        if (overtimeHours != null && overtimeHours > 0) ...[Gap(12.h), _buildDetailRow(context, 'Overtime Hours', '${overtimeHours}h', icon: Icons.access_time, highlight: true)],
      ],
    );
  }

  Widget _buildLocationNotesCard(BuildContext context, Attendance attendance) {
    final checkInLocation = attendance.checkInLocation;
    final checkOutLocation = attendance.checkOutLocation;
    final locationName = checkInLocation?.city ?? 'Kuwait City HQ';

    return _buildDetailCard(
      context,
      title: 'Location & Notes',
      icon: Icons.location_on_outlined,
      showViewMapButton: checkInLocation != null || checkOutLocation != null,
      children: [
        _buildDetailRow(context, 'Location', locationName),
        if (checkInLocation != null) ...[
          Gap(12.h),
          _buildDetailRow(
            context,
            'Check-In GPS',
            '${checkInLocation.address ?? locationName}${checkInLocation.city != null ? ' - ${checkInLocation.city}' : ''}',
            showCoordinates: checkInLocation.latitude != null && checkInLocation.longitude != null,
            coordinates: checkInLocation.latitude != null && checkInLocation.longitude != null
                ? '${checkInLocation.latitude!.toStringAsFixed(6)}, ${checkInLocation.longitude!.toStringAsFixed(6)}'
                : null,
          ),
        ],
        if (checkOutLocation != null) ...[
          Gap(12.h),
          _buildDetailRow(
            context,
            'Check-Out GPS',
            '${checkOutLocation.address ?? locationName}${checkOutLocation.city != null ? ' - ${checkOutLocation.city}' : ''}',
            showCoordinates: checkOutLocation.latitude != null && checkOutLocation.longitude != null,
            coordinates: checkOutLocation.latitude != null && checkOutLocation.longitude != null
                ? '${checkOutLocation.latitude!.toStringAsFixed(6)}, ${checkOutLocation.longitude!.toStringAsFixed(6)}'
                : null,
          ),
        ],
        if (attendance.notes != null && attendance.notes!.isNotEmpty) ...[Gap(12.h), _buildDetailRow(context, 'Notes', attendance.notes!)],
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children, bool showViewMapButton = false}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18.r, color: AppColors.primary),
                  Gap(8.w),
                  Text(
                    title,
                    style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: widget.isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B)),
                  ),
                ],
              ),
              if (showViewMapButton)
                TextButton(
                  onPressed: () {
                    // TODO: Implement map view
                  },
                  child: Text(
                    'View on Map',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
          Gap(16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {IconData? icon, bool highlight = false, bool showCoordinates = false, String? coordinates}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(icon, size: 14.r, color: AppColors.textSecondary),
              ),
              Gap(6.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$label: ',
                        style: context.textTheme.bodyMedium?.copyWith(color: widget.isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565), fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                            color: highlight ? AppColors.primary : (widget.isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showCoordinates && coordinates != null) ...[
                    Gap(4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12.r, color: Colors.red),
                        Gap(4.w),
                        Text(
                          coordinates,
                          style: context.textTheme.labelSmall?.copyWith(color: widget.isDark ? AppColors.textSecondaryDark : const Color(0xFF717182), fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
