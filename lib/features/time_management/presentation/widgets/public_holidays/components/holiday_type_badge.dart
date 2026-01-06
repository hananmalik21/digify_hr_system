import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HolidayTypeBadge extends StatelessWidget {
  final HolidayType type;
  final HolidayPaymentStatus paymentStatus;

  const HolidayTypeBadge({super.key, required this.type, required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTypeBadge(context, isDark),
        SizedBox(width: 8.w),
        _buildPaymentBadge(context, isDark),
      ],
    );
  }

  Widget _buildTypeBadge(BuildContext context, bool isDark) {
    final (label, bgColor, textColor) = switch (type) {
      HolidayType.fixed => (
        'FIXED',
        isDark ? const Color(0xFF1E3A5F) : const Color(0xFFE0E7FF),
        isDark ? const Color(0xFF93C5FD) : const Color(0xFF3730A3),
      ),
      HolidayType.islamic => (
        'ISLAMIC',
        isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
      ),
    };

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.6.sp, fontWeight: FontWeight.w500, color: textColor, fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildPaymentBadge(BuildContext context, bool isDark) {
    final (label, bgColor, textColor) = switch (paymentStatus) {
      HolidayPaymentStatus.paid => (
        'PAID',
        isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5),
        isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
      ),
      HolidayPaymentStatus.unpaid => (
        'UNPAID',
        isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2),
        isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
      ),
    };

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.6.sp, fontWeight: FontWeight.w500, color: textColor, fontFamily: 'Inter'),
      ),
    );
  }
}
