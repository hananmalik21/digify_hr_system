import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceLeavesCard extends StatelessWidget {
  final AppLocalizations localizations;
  final VoidCallback? onEyeIconTap;

  const AttendanceLeavesCard({super.key, required this.localizations, this.onEyeIconTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF101828);
    final tertiaryColor = isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282);

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 20)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.25.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2B7FFF), // #2b7fff
                          Color(0xFF615FFF), // #615fff
                        ],
                      ),
                      borderRadius: BorderRadius.circular(7.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DigifyAsset(
                      assetPath: Assets.icons.attendanceIcon.path,
                      width: 14,
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.attendanceLeaves,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 21 / 14,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(3.5.w),
                    constraints: const BoxConstraints(),
                    icon: DigifyAsset(assetPath: Assets.icons.arrowUp.path, width: 14, height: 14, color: textColor),
                    onPressed: () {},
                  ),
                  SizedBox(width: 3.5.w),
                  IconButton(
                    padding: EdgeInsets.all(3.5.w),
                    constraints: const BoxConstraints(),
                    icon: DigifyAsset(assetPath: Assets.icons.eyesIcon.path, width: 14, height: 14, color: textColor),
                    onPressed: onEyeIconTap,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 7.h),

          // Today's Attendance Section
          Text(
            localizations.todaysAttendance,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: tertiaryColor,
              height: 14 / 10.5,
              letterSpacing: 0,
            ),
          ),

          SizedBox(height: 7.h),

          // Attendance card
          Container(
            padding: EdgeInsetsDirectional.all(10.5.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5.25.w),
                  decoration: BoxDecoration(color: const Color(0xFF00C950), shape: BoxShape.circle),
                  child: DigifyAsset(
                    assetPath: Assets.icons.checkIconGreen.path,
                    width: 14,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check In: 08:45\nAM',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                          height: 14 / 10.5,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Status: ${localizations.statusOnTime}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                          height: 15 / 10,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 1.75.h),
                  decoration: BoxDecoration(color: const Color(0xFF00C950), borderRadius: BorderRadius.circular(999.r)),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 15 / 10,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 7.h),

          // My Upcoming Leaves Section
          Text(
            localizations.myUpcomingLeaves,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: tertiaryColor,
              height: 14 / 10.5,
              letterSpacing: 0,
            ),
          ),

          SizedBox(height: 7.h),

          // Leave card
          Container(
            padding: EdgeInsetsDirectional.all(10.5.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5.25.w),
                  decoration: BoxDecoration(color: const Color(0xFF2B7FFF), borderRadius: BorderRadius.circular(7.r)),
                  child: DigifyAsset(
                    assetPath: Assets.icons.calendarIcon.path,
                    width: 14,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.annualLeave,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                          height: 14 / 10.5,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Dec 28-25 (5\ndays)',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                          height: 15 / 10,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 1.75.h),
                  decoration: BoxDecoration(color: const Color(0xFF00C950), borderRadius: BorderRadius.circular(999.r)),
                  child: Text(
                    'Approved',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 15 / 10,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 7.h),

          // Team on Leave Today Section
          Text(
            localizations.teamOnLeaveToday,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: tertiaryColor,
              height: 14 / 10.5,
              letterSpacing: 0,
            ),
          ),

          SizedBox(height: 7.h),

          // Team members on leave
          _buildTeamMemberItem(context, 'AH', 'Ahmad Hassan', localizations.sickLeave, const Color(0xFFFF6900)),
          SizedBox(height: 7.h),
          _buildTeamMemberItem(context, 'MK', 'Mohammed Khan', localizations.emergencyLeave, const Color(0xFFAD46FF)),

          SizedBox(height: 16.h),

          // View full calendar link
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                localizations.viewFullCalendar,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF155DFC),
                  height: 14 / 10.5,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberItem(BuildContext context, String initials, String name, String leaveType, Color avatarColor) {
    final isDark = context.isDark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939);
    final tertiaryTextColor = isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282);

    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 14 / 10.5,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor,
                  height: 14 / 10.5,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                leaveType,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: tertiaryTextColor,
                  height: 15 / 10,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
