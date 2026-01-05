import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentTableHeader extends StatelessWidget {
  const ScheduleAssignmentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final headerColor = isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB);

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell('Assigned To', 274.86.w),
          _buildHeaderCell('Schedule', 297.46.w),
          _buildHeaderCell('Start Date', 139.55.w),
          _buildHeaderCell('End Date', 136.6.w),
          _buildHeaderCell('Status', 117.47.w),
          _buildHeaderCell('Assigned By', 197.22.w),
          _buildHeaderCell('Actions', 135.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xFF6A7282), height: 16 / 12),
      ),
    );
  }
}
