import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelsTable extends StatelessWidget {
  final List<JobLevel> jobLevels;

  const JobLevelsTable({super.key, required this.jobLevels});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            _buildTableHeader(),
            ...jobLevels.map((level) => JobLevelRow(level: level)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Row(
        children: [
          _buildHeaderCell('Level Name', 244.57.w),
          _buildHeaderCell('Code', 133.38.w),
          _buildHeaderCell('Description', 446.61.w),
          _buildHeaderCell('Grade Range', 248.44.w),
          _buildHeaderCell('Total Positions', 216.64.w),
          _buildHeaderCell(
            'Actions',
            170.w,
            // alignment: Alignment.centerLeft,
            // textAlign: TextAlign.centerLeft,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text,
    double width, {
    Alignment alignment = Alignment.centerLeft,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 12.h,
      ),
      alignment: alignment,
      child: Text(
        text.toUpperCase(),
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6A7282),
          height: 16 / 12,
        ),
      ),
    );
  }
}
