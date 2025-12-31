import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_detail_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCard extends StatelessWidget {
  final ShiftOverview shift;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onCopy;

  const ShiftCard({
    super.key,
    required this.shift,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
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
          // Header section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon placeholder based on shift name
                    _buildShiftIcon(shift.name),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shift.name,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          // Arabic Title Mock
                          Text(
                            _getArabicName(shift.name),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ShiftStatusBadge(isActive: shift.isActive),
                  ],
                ),
                SizedBox(height: 12.h),
                // Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    shift.code.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.infoText,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Details
                ShiftCardDetailRow(
                  label: 'Time',
                  value: '${shift.startTime} - ${shift.endTime}',
                ),
                ShiftCardDetailRow(
                  label: 'Duration',
                  value: '${shift.totalHours} hours',
                ),
                ShiftCardDetailRow(label: 'Break', value: '1 hour'), // Mocked
                ShiftCardDetailRow(
                  label: 'Type',
                  value: _getShiftType(shift.name),
                ), // Mocked
              ],
            ),
          ),

          const Spacer(),
          Divider(
            height: 1,
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          ),

          // Actions
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'View',
                    icon: Icons.visibility_outlined,
                    bgColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                    textColor: isDark
                        ? AppColors.infoTextDark
                        : AppColors.infoText,
                    onPressed: onView,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildActionButton(
                    label: 'Edit',
                    icon: Icons.edit_outlined,
                    bgColor: isDark
                        ? AppColors.successBgDark
                        : AppColors.successBg,
                    textColor: isDark
                        ? AppColors.successTextDark
                        : AppColors.successText,
                    onPressed: onEdit,
                  ),
                ),
                SizedBox(width: 8.w),
                _buildIconButton(
                  icon: Icons.copy_rounded,
                  bgColor: isDark ? AppColors.purpleBgDark : AppColors.purpleBg,
                  iconColor: isDark
                      ? AppColors.purpleTextDark
                      : AppColors.purpleText,
                  onPressed: onCopy,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftIcon(String name) {
    IconData iconData;
    Color bgColor;
    Color iconColor;

    if (name.toLowerCase().contains('day')) {
      iconData = Icons.light_mode;
      bgColor = const Color(0xFFFEF9C3);
      iconColor = const Color(0xFFCA8A04);
    } else if (name.toLowerCase().contains('night')) {
      iconData = Icons.dark_mode;
      bgColor = const Color(0xFFF3E8FF);
      iconColor = const Color(0xFF9333EA);
    } else if (name.toLowerCase().contains('morning')) {
      iconData = Icons.wb_sunny_outlined;
      bgColor = const Color(0xFFE0F2FE);
      iconColor = const Color(0xFF0284C7);
    } else {
      iconData = Icons.wb_twilight;
      bgColor = const Color(0xFFFFEDD5);
      iconColor = const Color(0xFFEA580C);
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(iconData, size: 20.sp, color: iconColor),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.sp, color: textColor),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 16.sp, color: iconColor),
      ),
    );
  }

  String _getArabicName(String name) {
    if (name.toLowerCase().contains('day')) return 'الدوام النهاري';
    if (name.toLowerCase().contains('night')) return 'الدوام الليلي';
    if (name.toLowerCase().contains('morning')) return 'دوام الصباح';
    if (name.toLowerCase().contains('evening')) return 'دوام المساء';
    return '';
  }

  String _getShiftType(String name) {
    if (name.toLowerCase().contains('night')) return 'Night';
    return 'Day';
  }
}
