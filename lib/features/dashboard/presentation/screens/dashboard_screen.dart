import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _initialized = false;
  late List<_DashboardButton> _buttons;

  bool _showSideCards = true;

  void _toggleSideCards() {
    if (!mounted) return;
    setState(() => _showSideCards = !_showSideCards);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;

    final canonical = <_DashboardButton>[
      _DashboardButton(
        id: 'dashboard',
        icon: 'assets/icons/dashboard_main_icon.svg',
        label: loc.dashboard,
        color: AppColors.primaryLight,
        route: '/dashboard',
      ),
      _DashboardButton(
        id: 'employees',
        icon: 'assets/icons/employees_main_icon.svg',
        label: loc.employees,
        color: const Color(0xFF00C950),
        route: '/employees',
      ),
      _DashboardButton(
        id: 'time-management',
        icon: 'assets/icons/time_management_main_icon.svg',
        label: loc.timeManagement,
        color: const Color(0xFFFF6900),
        route: '/time-management',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'leave-management',
        icon: 'assets/icons/leave_management_main_icon.svg',
        label: loc.leaveManagement,
        color: const Color(0xFF00B8DB),
        route: '/leave-management',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'attendance',
        icon: 'assets/icons/attendance_main_icon.svg',
        label: loc.attendance,
        color: const Color(0xFFFE9A00),
        route: '/attendance',
      ),
      _DashboardButton(
        id: 'payroll',
        icon: 'assets/icons/payroll_main_icon.svg',
        label: loc.payroll,
        color: const Color(0xFF00BC7D),
        route: '/payroll',
      ),
      _DashboardButton(
        id: 'compliance',
        icon: 'assets/icons/compliance_main_icon.svg',
        label: loc.compliance,
        color: const Color(0xFFFB2C36),
        route: '/compliance',
      ),
      _DashboardButton(
        id: 'workforce-structure',
        icon: 'assets/icons/workforce_structure_main_icon.svg',
        label: loc.workforceStructure,
        color: const Color(0xFF00BBA7),
        route: '/workforce-structure',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'enterprise-structure',
        icon: 'assets/icons/enterprise_structure_main_icon.svg',
        label: loc.enterpriseStructure,
        color: const Color(0xFF615FFF),
        route: '/enterprise-structure',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'reports',
        icon: 'assets/icons/reports_main_icon.svg',
        label: loc.reports,
        color: const Color(0xFF62748E),
        route: '/reports',
      ),
      _DashboardButton(
        id: 'eos-calculator',
        icon: 'assets/icons/eos_calculator_main_icon.svg',
        label: loc.eosCalculator,
        color: const Color(0xFF8E51FF),
        route: '/eos-calculator',
      ),
      _DashboardButton(
        id: 'government-forms',
        icon: 'assets/icons/government_forms_main_icon.svg',
        label: loc.governmentForms,
        color: const Color(0xFFFF2056),
        route: '/government-forms',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'hr-operations',
        icon: 'assets/icons/hr_operations_main_icon.svg',
        label: loc.hrOperations,
        color: const Color(0xFF7CCF00),
        route: '/hr-operations',
      ),
      _DashboardButton(
        id: 'dei-dashboard',
        icon: 'assets/icons/dei_dashboard_main_icon.svg',
        label: loc.deiDashboard,
        color: const Color(0xFFE12AFB),
        route: '/dei-dashboard',
      ),
      _DashboardButton(
        id: 'module-catalogue',
        icon: 'assets/icons/module_catalogue_main_icon.svg',
        label: loc.moduleCatalogue,
        color: const Color(0xFFAD46FF),
        route: '/module-catalogue',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'product-intro',
        icon: 'assets/icons/product_intro_main_icon.svg',
        label: loc.productIntroduction,
        color: const Color(0xFFF6339A),
        route: '/product-intro',
        isMultiLine: true,
      ),
      _DashboardButton(
        id: 'settings',
        icon: 'assets/icons/settings_main_icon.svg',
        label: loc.settings,
        color: const Color(0xFF6A7282),
        route: '/settings',
      ),
    ];

    if (!_initialized) {
      _buttons = canonical;
      _initialized = true;
      return;
    }

    final byId = {for (final b in canonical) b.id: b};
    _buttons = _buttons.map((old) {
      final fresh = byId[old.id];
      if (fresh == null) return old;
      return old.copyWith(label: fresh.label);
    }).toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _buttons.removeAt(oldIndex);
      _buttons.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: EdgeInsetsDirectional.only(
                    top: 16.h,
                    start: 16.w,
                    end: 16.w,
                    bottom: 16.h,
                  ),
                  tablet: EdgeInsetsDirectional.only(
                    top: 24.h,
                    start: 24.w,
                    end: 24.w,
                    bottom: 24.h,
                  ),
                  web: EdgeInsetsDirectional.only(
                    top: 10.h,
                    start: 32.w,
                    end: 32.w,
                    bottom: 24.h,
                  ),
                ),
                child: Container(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: EdgeInsetsDirectional.all(16.w),
                    tablet: EdgeInsetsDirectional.all(20.w),
                    web: EdgeInsetsDirectional.all(24.w),
                  ),
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
                  child: ResponsiveHelper.isMobile(context)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDraggableIconGrid(context),
                      SizedBox(height: 24.h),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.97, end: 1.0).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _showSideCards
                            ? Column(
                          key: const ValueKey('sideCardsOn'),
                          children: [
                            _buildTasksEventsCard(context, localizations),
                            SizedBox(height: 16.h),
                            _buildAttendanceLeavesCard(context, localizations),
                          ],
                        )
                            : const SizedBox(key: ValueKey('sideCardsOff')),
                      ),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDraggableIconGrid(context)),
                      SizedBox(width: ResponsiveHelper.isTablet(context) ? 16.w : 24.w),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.97, end: 1.0).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _showSideCards
                            ? SizedBox(
                          key: const ValueKey('sideColOn'),
                          width: ResponsiveHelper.isTablet(context) ? 200.w : 272.w,
                          child: Column(
                            children: [
                              _buildTasksEventsCard(context, localizations),
                              SizedBox(height: 24.h),
                              _buildAttendanceLeavesCard(context, localizations),
                            ],
                          ),
                        )
                            : const SizedBox(key: ValueKey('sideColOff')),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 12.h,
              right: 12.w,
              child: IgnorePointer(
                ignoring: _showSideCards,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.92, end: 1.0).animate(anim),
                      child: child,
                    ),
                  ),
                  child: _showSideCards
                      ? const SizedBox.shrink(key: ValueKey('eyeOff'))
                      : _buildFloatingDashboardIcon(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Updated: responsive on mobile (>=2 per row), tablet (no overflow), web (dynamic)
  Widget _buildDraggableIconGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isMobile = maxW < 600;
        final isTablet = maxW >= 600 && maxW < 1024;

        final spec = _gridSpecForWidth(context, maxW);

        return ReorderableWrap(
          spacing: spec.spacing,
          runSpacing: isMobile ? 20.h : (isTablet ? 24.h : 32.h),
          alignment: WrapAlignment.start,
          needsLongPressDraggable: spec.needsLongPress,
          onReorder: _onReorder,
          children: List.generate(_buttons.length, (index) {
            final btn = _buttons[index];
            return SizedBox(
              key: ValueKey('dash-${btn.id}'),
              width: spec.tileW,
              height: spec.tileH,
              child: _HoverableIconButton(
                button: btn,
                onTap: () => context.go(btn.route),
              ),
            );
          }),
        );
      },
    );
  }

  // ✅ Updated grid spec:
  // - Mobile: ALWAYS 2 columns
  // - Tablet: 2..4 columns dynamically, taller tiles to prevent overflow
  // - Web: 3..6 columns dynamically
  _GridSpec _gridSpecForWidth(BuildContext context, double maxW) {
    final bool isMobile = maxW < 600;
    final bool isTablet = maxW >= 600 && maxW < 1024;
    final bool isWeb = maxW >= 1024;

    final double spacing = 16.w;

    // ---- MOBILE: ALWAYS 2 COLUMNS ----
    if (isMobile) {
      const int columns = 2;
      final double usable = maxW - spacing; // 1 gap between 2 tiles
      final double tileW = (usable / columns).clamp(150.0, 185.0).toDouble();
      final double tileH = (tileW * 0.95).clamp(155.0, 180.0).toDouble();

      return _GridSpec(
        columns: columns,
        spacing: spacing,
        tileW: tileW,
        tileH: tileH,
        needsLongPress: true,
      );
    }

    // ---- TABLET / WEB: dynamic columns based on width ----
    final double minTileW = isTablet ? 170.0 : 180.0;
    final double maxTileW = isTablet ? 220.0 : 240.0;

    int columns = ((maxW + spacing) / (minTileW + spacing)).floor();

    if (isTablet) {
      columns = columns.clamp(2, 4);
    } else if (isWeb) {
      columns = columns.clamp(3, 6);
    }

    final double usable = maxW - (spacing * (columns - 1));
    final double tileW = (usable / columns).clamp(minTileW, maxTileW).toDouble();

    // ✅ Tablet gets more vertical space (fixes Bottom overflow)
    final double tileH = isTablet
        ? (tileW * 1.05).clamp(190.0, 215.0).toDouble()
        : (tileW * 0.90).clamp(165.0, 185.0).toDouble();

    return _GridSpec(
      columns: columns,
      spacing: spacing,
      tileW: tileW,
      tileH: tileH,
      needsLongPress: false,
    );
  }

  // ✅ Floating icon builder (unchanged)
  Widget _buildFloatingDashboardIcon(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggleSideCards,
        child: Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4F46E5), Color(0xFF2563EB)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: SvgIconWidget(
              assetPath: 'assets/icons/eyes_icon.svg',
              size: 24.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- Cards (your existing code) ----------------------
  // Keep your existing _buildTasksEventsCard, _buildAttendanceLeavesCard, etc.
  // (No changes required for responsiveness issues you showed.)

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
                  Container(
                    padding: EdgeInsets.all(7.h),
                    decoration: BoxDecoration(
                      color: AppColors.sidebarActiveParent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/tasks_icon.svg',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    localizations.tasksEvents,
                    style: TextStyle(
                      fontSize: 15.6.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 24 / 15.6,
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
                      assetPath: 'assets/icons/arrow_up.svg',
                      size: 20.sp,
                      color: textColor,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    padding: EdgeInsets.all(4.r),
                    constraints: const BoxConstraints(),
                    icon: SvgIconWidget(
                      assetPath: 'assets/icons/eyes_icon.svg',
                      size: 16.sp,
                      color: textColor,
                    ),
                    onPressed: _toggleSideCards,
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
            ),
          ),
          SizedBox(height: 12.h),
          _buildTaskItem(context, localizations.reviewLeaveRequests, localizations.dueToday, false),
          SizedBox(height: 12.h),
          _buildTaskItem(context, localizations.processMonthlyPayroll, localizations.dueIn3Days, false),
          SizedBox(height: 12.h),
          _buildTaskItem(context, localizations.updateEmployeeRecords, localizations.completed, true),
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
              style: TextButton.styleFrom(padding: EdgeInsetsDirectional.only(top: 2.75.h)),
              child: Text(
                localizations.viewAllTasksEvents,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF155DFC),
                  height: 20 / 13.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, String title, String subtitle, bool isCompleted) {
    final isDark = context.isDark;
    final completedColor = AppColors.primary;
    final borderColor = isDark ? AppColors.borderGreyDark : const Color(0xFF767676);

    final textColor = isCompleted
        ? (isDark ? AppColors.textPlaceholderDark : const Color(0xFF99A1AF))
        : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939));

    final subtitleColor = isCompleted
        ? (isDark ? AppColors.textPlaceholderDark : const Color(0xFF99A1AF))
        : (isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282));

    final checkboxBg = isCompleted ? completedColor : (isDark ? AppColors.cardBackgroundDark : Colors.white);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          margin: EdgeInsetsDirectional.only(top: 4.h),
          decoration: BoxDecoration(
            color: checkboxBg,
            border: Border.all(color: isCompleted ? completedColor : borderColor, width: 1),
            borderRadius: BorderRadius.circular(2.5.r),
          ),
          child: isCompleted ? Icon(Icons.check, size: 12.sp, color: Colors.white) : null,
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
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.48.w, vertical: 8.h),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10.r)),
          child: Column(
            children: [
              Text(
                month,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor, height: 16 / 12),
              ),
              Text(
                day,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: textColor, height: 28 / 18),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceLeavesCard(BuildContext context, AppLocalizations localizations) {
    // (Use your existing implementation here; unchanged)
    // You already have it in your file; no responsiveness issue from that card in screenshot.
    return const SizedBox.shrink();
  }
}

// -------------------- Grid spec model --------------------

class _GridSpec {
  final int columns;
  final double spacing;
  final double tileW;
  final double tileH;
  final bool needsLongPress;

  const _GridSpec({
    required this.columns,
    required this.spacing,
    required this.tileW,
    required this.tileH,
    required this.needsLongPress,
  });
}

// -------------------- Button model --------------------

class _DashboardButton {
  final String id;
  final String icon;
  final String label;
  final Color color;
  final String route;
  final bool isMultiLine;

  _DashboardButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.isMultiLine = false,
  });

  _DashboardButton copyWith({String? label}) {
    return _DashboardButton(
      id: id,
      icon: icon,
      label: label ?? this.label,
      color: color,
      route: route,
      isMultiLine: isMultiLine,
    );
  }
}

// -------------------- Hover tile (UPDATED to remove tablet overflow) --------------------

class _HoverableIconButton extends StatefulWidget {
  final _DashboardButton button;
  final VoidCallback onTap;

  const _HoverableIconButton({required this.button, required this.onTap});

  @override
  State<_HoverableIconButton> createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<_HoverableIconButton> {
  bool _isHovered = false;
  bool _isDragging = false;

  void _setHovered(bool v) {
    if (!mounted || _isDragging) return;
    setState(() => _isHovered = v);
  }

  @override
  Widget build(BuildContext context) {
    const Color hoverBg = Colors.white;

    return LongPressDraggable<String>(
      data: widget.button.id,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        if (!mounted) return;
        setState(() {
          _isDragging = true;
          _isHovered = false;
        });
      },
      onDragEnd: (_) {
        if (!mounted) return;
        setState(() => _isDragging = false);
      },
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.90,
          child: IntrinsicWidth(
            child: _buildTile(context, hoverBg, forceHover: true),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _buildTile(context, hoverBg),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        hitTestBehavior: HitTestBehavior.opaque,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isDragging ? null : widget.onTap,
          child: _buildTile(context, hoverBg),
        ),
      ),
    );
  }

  // ✅ Updated tile:
  // - Tablet overflow fixed using Flexible for label
  // - Tablet icon slightly smaller to give text more space
  Widget _buildTile(BuildContext context, Color hoverBg, {bool forceHover = false}) {
    final bool activeHover = forceHover || (_isHovered && !_isDragging);
    final bool isTablet = ResponsiveHelper.isTablet(context);

    final double iconBox = isTablet ? 72.w : 80.w;
    final double iconSize = isTablet ? 36.sp : 40.sp;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: activeHover ? 1 : 0),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        final bg = Color.lerp(Colors.transparent, hoverBg, t)!;

        final double liftY = -6.0 * t;
        final double boxScale = 1.0 + (0.06 * t);
        final double iconScale = 1.0 + (0.10 * t);
        final double rotate = (0.03 * t);

        final shadow1 = BoxShadow(
          color: Colors.black.withValues(alpha: 0.10 * t),
          blurRadius: 26 * t,
          offset: Offset(0, 10 * t),
        );
        final shadow2 = BoxShadow(
          color: Colors.black.withValues(alpha: 0.06 * t),
          blurRadius: 10 * t,
          offset: Offset(0, 2 * t),
        );

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: (t == 0 || _isDragging) ? [] : [shadow1, shadow2],
          ),
          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, liftY),
                child: Transform.rotate(
                  angle: rotate,
                  child: Transform.scale(
                    scale: boxScale,
                    child: Container(
                      width: iconBox,
                      height: iconBox,
                      decoration: BoxDecoration(
                        color: widget.button.color,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Center(
                        child: Transform.scale(
                          scale: iconScale,
                          child: SvgIconWidget(
                            assetPath: widget.button.icon,
                            size: iconSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // ✅ FIXED: prevents "BOTTOM OVERFLOWED" on tablet
              Flexible(
                child: Text(
                  widget.button.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
