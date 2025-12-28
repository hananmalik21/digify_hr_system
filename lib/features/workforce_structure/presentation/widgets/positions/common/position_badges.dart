import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionStatusBadge extends StatelessWidget {
  final String label;
  final bool isActive;

  const PositionStatusBadge({
    super.key,
    required this.label,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF15803D) : const Color(0xFF6B7280),
          height: 16 / 12,
        ),
      ),
    );
  }
}

class PositionVacancyBadge extends StatelessWidget {
  final int vacancy;
  final String vacantLabel;
  final String fullLabel;

  const PositionVacancyBadge({
    super.key,
    required this.vacancy,
    required this.vacantLabel,
    required this.fullLabel,
  });

  @override
  Widget build(BuildContext context) {
    final hasVacancy = vacancy > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: hasVacancy ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        textAlign: TextAlign.center,
        hasVacancy ? '$vacancy $vacantLabel' : fullLabel,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: hasVacancy ? const Color(0xFFB45309) : const Color(0xFF15803D),
          height: 16 / 12,
        ),
      ),
    );
  }
}
