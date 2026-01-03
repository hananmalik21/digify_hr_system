import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksEventsCard extends StatelessWidget {
  final AppLocalizations localizations;
  final VoidCallback? onEyeIconTap;

  const TasksEventsCard({
    super.key,
    required this.localizations,
    this.onEyeIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF101828);
    final tertiaryColor = isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282);

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardBackgroundDark.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? AppColors.cardBorderDark.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 8),
          ),
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
                      child: SvgIconWidget(
                        assetPath: 'assets/icons/tasks_icon.svg',
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 7.w),
                    Text(
                      localizations.tasksEvents,
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
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(3.5.w),
                      constraints: const BoxConstraints(),
                      icon: SvgIconWidget(
                        assetPath: 'assets/icons/arrow_up.svg',
                        size: 14.sp,
                        color: textColor,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 3.5.w),
                    IconButton(
                      padding: EdgeInsets.all(3.5.w),
                      constraints: const BoxConstraints(),
                      icon: SvgIconWidget(
                        assetPath: 'assets/icons/eyes_icon.svg',
                        size: 14.sp,
                        color: textColor,
                      ),
                      onPressed: onEyeIconTap,
                    ),
                  ],
                ),
              ],
          ),

          SizedBox(height: 7.h),

          // My Tasks Section
          Text(
              localizations.myTasks,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: tertiaryColor,
                height: 14 / 10.5,
                letterSpacing: 0,
              ),
            ),

            SizedBox(height: 7.h),

          // Task items
          _buildTaskItem(
            context,
            localizations.reviewLeaveRequests,
            localizations.dueToday,
            false,
          ),
          SizedBox(height: 7.h),
          _buildTaskItem(
            context,
            localizations.processMonthlyPayroll,
            localizations.dueIn3Days,
            false,
          ),
          SizedBox(height: 7.h),
          _buildTaskItem(
            context,
            localizations.updateEmployeeRecords,
            localizations.completed,
            true,
          ),

          SizedBox(height: 7.h),

          // Upcoming Events Section
          Text(
              localizations.upcomingEvents,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: tertiaryColor,
                height: 14 / 10.5,
                letterSpacing: 0,
              ),
            ),

          SizedBox(height: 7.h),

          // Event items
          _buildEventItem(
            context,
            'DEC',
            '15',
            localizations.teamMeeting,
            '10:00 AM - 11:00 AM',
            isDark ? AppColors.infoBgDark : const Color(0xFFEFF6FF),
            isDark ? AppColors.infoTextDark : const Color(0xFF155DFC),
          ),
          SizedBox(height: 7.h),
          _buildEventItem(
            context,
            'DEC',
            '20',
            localizations.payrollProcessing,
            localizations.allDay,
            isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
            isDark ? AppColors.successTextDark : const Color(0xFF00A63E),
          ),

          SizedBox(height: 16.h),

          // View all link
          Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  localizations.viewAllTasksEvents,
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

  Widget _buildTaskItem(
    BuildContext context,
    String title,
    String subtitle,
    bool isCompleted,
  ) {
    final isDark = context.isDark;
    final completedColor = AppColors.primary;
    final borderColor = isDark ? AppColors.borderGreyDark : const Color(0xFF767676);

    final textColor = isCompleted
        ? (isDark ? AppColors.textPlaceholderDark : const Color(0xFF99A1AF))
        : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939));

    final subtitleColor = isCompleted
        ? (isDark ? AppColors.textPlaceholderDark : const Color(0xFF99A1AF))
        : (isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282));

    final checkboxBg = isCompleted
        ? completedColor
        : (isDark ? AppColors.cardBackgroundDark : Colors.white);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12.25.w,
          height: 12.25.h,
          margin: EdgeInsetsDirectional.only(top: 1.75.h),
          decoration: BoxDecoration(
            color: checkboxBg,
            border: Border.all(
              color: isCompleted ? completedColor : borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2.5.r),
          ),
          child: isCompleted
              ? Icon(
                  Icons.check,
                  size: 10.sp,
                  color: Colors.white,
                )
              : null,
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 14 / 10.5,
                  letterSpacing: 0,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor,
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

  Widget _buildEventItem(
    BuildContext context,
    String month,
    String day,
    String title,
    String time,
    Color bgColor,
    Color textColor,
  ) {
    final isDark = context.isDark;
    final primaryTextColor =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939);
    final tertiaryTextColor =
        isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 9.39.w,
            vertical: 3.5.h,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Column(
            children: [
              Text(
                month,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 15 / 10,
                  letterSpacing: 0,
                ),
              ),
              Text(
                day,
                style: TextStyle(
                  fontSize: 12.3.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 17.5 / 12.3,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
                time,
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

