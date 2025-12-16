import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: 88.h,
              start: 32.w,
              end: 32.w,
              bottom: 24.h,
            ),
            child: Container(
              padding: EdgeInsetsDirectional.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                  colors: isDark
                      ? [
                          AppColors.cardBackgroundGreyDark,
                          AppColors.infoBgDark,
                          AppColors.cardBackgroundGreyDark,
                        ]
                      : const [
                          Color(0xFFF3F4F6),
                          Color(0xFFEFF6FF),
                          Color(0xFFF3F4F6),
                        ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildIconGrid(context, localizations)),
                  SizedBox(width: 24.w),
                  SizedBox(
                    width: 272.w,
                    child: Column(
                      children: [
                        _buildTasksEventsCard(context, localizations),
                        SizedBox(height: 24.h),
                        _buildAttendanceLeavesCard(context, localizations),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconGrid(BuildContext context, AppLocalizations localizations) {
    final buttons = [
      _DashboardButton(
        icon: 'assets/icons/dashboard_main_icon.svg',
        label: localizations.dashboard,
        color: AppColors.primaryLight,
        route: '/dashboard',
      ),
      _DashboardButton(
        icon: 'assets/icons/employees_main_icon.svg',
        label: localizations.employees,
        color: const Color(0xFF00C950),
        route: '/employees',
      ),
      _DashboardButton(
        icon: 'assets/icons/time_management_main_icon.svg',
        label: localizations.timeManagement,
        color: const Color(0xFFFF6900),
        route: '/time-management',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/leave_management_main_icon.svg',
        label: localizations.leaveManagement,
        color: const Color(0xFF00B8DB),
        route: '/leave-management',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/attendance_main_icon.svg',
        label: localizations.attendance,
        color: const Color(0xFFFE9A00),
        route: '/attendance',
      ),
      _DashboardButton(
        icon: 'assets/icons/payroll_main_icon.svg',
        label: localizations.payroll,
        color: const Color(0xFF00BC7D),
        route: '/payroll',
      ),
      _DashboardButton(
        icon: 'assets/icons/compliance_main_icon.svg',
        label: localizations.compliance,
        color: const Color(0xFFFB2C36),
        route: '/compliance',
      ),
      _DashboardButton(
        icon: 'assets/icons/workforce_structure_main_icon.svg',
        label: localizations.workforceStructure,
        color: const Color(0xFF00BBA7),
        route: '/workforce-structure',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/enterprise_structure_main_icon.svg',
        label: localizations.enterpriseStructure,
        color: const Color(0xFF615FFF),
        route: '/enterprise-structure',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/reports_main_icon.svg',
        label: localizations.reports,
        color: const Color(0xFF62748E),
        route: '/reports',
      ),
      _DashboardButton(
        icon: 'assets/icons/eos_calculator_main_icon.svg',
        label: localizations.eosCalculator,
        color: const Color(0xFF8E51FF),
        route: '/eos-calculator',
      ),
      _DashboardButton(
        icon: 'assets/icons/government_forms_main_icon.svg',
        label: localizations.governmentForms,
        color: const Color(0xFFFF2056),
        route: '/government-forms',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/hr_operations_main_icon.svg',
        label: localizations.hrOperations,
        color: const Color(0xFF7CCF00),
        route: '/hr-operations',
      ),
      _DashboardButton(
        icon: 'assets/icons/dei_dashboard_main_icon.svg',
        label: localizations.deiDashboard,
        color: const Color(0xFFE12AFB),
        route: '/dei-dashboard',
      ),
      _DashboardButton(
        icon: 'assets/icons/module_catalogue_main_icon.svg',
        label: localizations.moduleCatalogue,
        color: const Color(0xFFAD46FF),
        route: '/module-catalogue',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/product_intro_main_icon.svg',
        label: localizations.productIntroduction,
        color: const Color(0xFFF6339A),
        route: '/product-intro',
        isMultiLine: true,
      ),
      _DashboardButton(
        icon: 'assets/icons/settings_main_icon.svg',
        label: localizations.settings,
        color: const Color(0xFF6A7282),
        route: '/settings',
      ),
    ];

    return Wrap(
      spacing: 0
          .w, // Buttons are positioned at 0, 189, 378, etc. - each container is 189px wide
      runSpacing: 11.75.h,
      children: buttons.asMap().entries.map((entry) {
        final index = entry.key;
        final button = entry.value;
        return SizedBox(
          width: 189.w, // Each button container is 189px wide
          child: _buildIconButton(context, button, index),
        );
      }).toList(),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    _DashboardButton button,
    int index,
  ) {
    return _HoverableIconButton(
      key: ValueKey('dashboard-button-$index'),
      button: button,
      onTap: () => context.go(button.route),
    );
  }

  Widget _buildTasksEventsCard(BuildContext context, AppLocalizations localizations) {
    final isDark = context.isDark;
    final textColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF101828);
    final tertiaryColor = isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282);
    
    return Container(
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgIconWidget(
                    assetPath: 'assets/icons/tasks_events_icon.svg',
                    size: 20.sp,
                    color: textColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    localizations.tasksEvents,
                    style: TextStyle(
                      fontSize: 15.6.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 24 / 15.6,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(4.r),
                    constraints: const BoxConstraints(),
                    icon: SvgIconWidget(
                      assetPath: 'assets/icons/add_icon.svg',
                      size: 16.sp,
                      color: textColor,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    padding: EdgeInsets.all(4.r),
                    constraints: const BoxConstraints(),
                    icon: SvgIconWidget(
                      assetPath: 'assets/icons/more_icon.svg',
                      size: 20.sp,
                      color: textColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            localizations.myTasks,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: tertiaryColor,
              height: 16 / 12,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 12.h),
          _buildTaskItem(
            context,
            localizations.reviewLeaveRequests,
            localizations.dueToday,
            false,
          ),
          SizedBox(height: 12.h),
          _buildTaskItem(
            context,
            localizations.processMonthlyPayroll,
            localizations.dueIn3Days,
            false,
          ),
          SizedBox(height: 12.h),
          _buildTaskItem(
            context,
            localizations.updateEmployeeRecords,
            localizations.completed,
            true,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(
              localizations.upcomingEvents,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: tertiaryColor,
                height: 16 / 12,
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildEventItem(
            context,
            'DEC',
            '15',
            localizations.teamMeeting,
            '10:00 AM - 11:00 AM',
            isDark ? AppColors.infoBgDark : const Color(0xFFEFF6FF),
            isDark ? AppColors.infoTextDark : AppColors.primary,
          ),
          SizedBox(height: 12.h),
          _buildEventItem(
            context,
            'DEC',
            '20',
            localizations.payrollProcessing,
            localizations.allDay,
            isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
            isDark ? AppColors.successTextDark : const Color(0xFF00A63E),
          ),
          SizedBox(height: 11.h),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsetsDirectional.only(top: 2.75.h),
              ),
              child: Text(
                localizations.viewAllTasksEvents,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF155DFC),
                  height: 20 / 13.6,
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
          width: 16.w,
          height: 16.h,
          margin: EdgeInsetsDirectional.only(top: 4.h),
          decoration: BoxDecoration(
            color: checkboxBg,
            border: Border.all(
              color: isCompleted ? completedColor : borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2.5.r),
          ),
          child: isCompleted
              ? Icon(Icons.check, size: 12.sp, color: Colors.white)
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 20 / 13.6,
                  letterSpacing: 0,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.8.sp,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor,
                  height: 16 / 11.8,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 12.48.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              Text(
                month,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 16 / 12,
                  letterSpacing: 0,
                ),
              ),
              Text(
                day,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 28 / 18,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w500,
                  color: context.isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                  height: 20 / 13.7,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: context.isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
                  height: 16 / 12,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceLeavesCard(BuildContext context, AppLocalizations localizations) {
    final isDark = context.isDark;
    final textColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF101828);
    final tertiaryColor = isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282);
    final secondaryColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565);
    
    return Container(
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgIconWidget(
                    assetPath: 'assets/icons/attendance_leaves_icon.svg',
                    size: 20.sp,
                    color: textColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    localizations.attendanceLeaves,
                    style: TextStyle(
                      fontSize: 15.6.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 24 / 15.6,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(4.r),
                    constraints: const BoxConstraints(),
                    icon: SvgIconWidget(
                      assetPath: 'assets/icons/calendar_icon.svg',
                      size: 16.sp,
                      color: textColor,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    padding: EdgeInsets.all(4.r),
                    constraints: const BoxConstraints(),
                    icon: SvgIconWidget(
                      assetPath: 'assets/icons/more_icon.svg',
                      size: 20.sp,
                      color: textColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            localizations.todaysAttendance,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: tertiaryColor,
              height: 16 / 12,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsetsDirectional.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C950),
                    shape: BoxShape.circle,
                  ),
                  child: SvgIconWidget(
                    assetPath: 'assets/icons/check_in_icon.svg',
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.checkInTime,
                        style: TextStyle(
                          fontSize: 13.9.sp,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          height: 20 / 13.9,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        localizations.statusOnTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: secondaryColor,
                          height: 16 / 12,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C950),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    localizations.active,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 16 / 12,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(
              localizations.myUpcomingLeaves,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: tertiaryColor,
                height: 16 / 12,
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsetsDirectional.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B7FFF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SvgIconWidget(
                    assetPath: 'assets/icons/leave_calendar_icon.svg',
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.annualLeave,
                        style: TextStyle(
                          fontSize: 13.8.sp,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          height: 20 / 13.8,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        localizations.leaveDates,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: secondaryColor,
                          height: 16 / 12,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C950),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    localizations.approved,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 16 / 12,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(
              localizations.teamOnLeaveToday,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: tertiaryColor,
                height: 16 / 12,
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildTeamMemberItem(
            context,
            'AH',
            localizations.ahmadHassan,
            localizations.sickLeave,
            const Color(0xFFFF6900),
          ),
          SizedBox(height: 8.h),
          _buildTeamMemberItem(
            context,
            'MK',
            localizations.mohammedKhan,
            localizations.emergencyLeave,
            const Color(0xFFAD46FF),
          ),
          SizedBox(height: 11.h),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsetsDirectional.only(top: 2.75.h),
              ),
              child: Text(
                localizations.viewFullCalendar,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  height: 20 / 13.6,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberItem(
    BuildContext context,
    String initials,
    String name,
    String leaveType,
    Color avatarColor,
  ) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 20 / 14,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E2939),
                  height: 20 / 13.7,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                leaveType,
                style: TextStyle(
                  fontSize: 11.8.sp,
                  fontWeight: FontWeight.w400,
                  color: context.isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
                  height: 16 / 11.8,
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

class _DashboardButton {
  final String icon;
  final String label;
  final Color color;
  final String route;
  final bool isMultiLine;

  _DashboardButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.isMultiLine = false,
  });
}

class _HoverableIconButton extends StatefulWidget {
  final _DashboardButton button;
  final VoidCallback onTap;

  const _HoverableIconButton({
    super.key,
    required this.button,
    required this.onTap,
  });

  @override
  State<_HoverableIconButton> createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<_HoverableIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (mounted) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() => _isHovered = false);
        }
      },
      hitTestBehavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: widget.button.isMultiLine ? 28.5.w : 38.5.w,
            vertical: 16.h,
          ),
                  decoration: BoxDecoration(
                color: _isHovered 
                    ? (context.isDark ? AppColors.cardBackgroundDark : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14.r),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: widget.button.color,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, -4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, -4),
                            ),
                          ],
                  ),
                  child: Center(
                    child: SvgIconWidget(
                      assetPath: widget.button.icon,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: widget.button.isMultiLine ? 12.h : 11.75.h),
                  Text(
                    widget.button.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.button.isMultiLine ? 13.6.sp : 13.7.sp,
                      fontWeight: FontWeight.w400,
                      color: context.isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                      height: 17.5 / 13.7,
                      letterSpacing: 0,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
