import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dashboard_button_model.dart';

class DashboardModuleButton extends StatefulWidget {
  final DashboardButton button;
  final VoidCallback onTap;
  final bool isDragging;

  const DashboardModuleButton({super.key, required this.button, required this.onTap, required this.isDragging});

  @override
  State<DashboardModuleButton> createState() => _DashboardModuleButtonState();
}

class _DashboardModuleButtonState extends State<DashboardModuleButton> {
  bool _isHovered = false;

  void _clearHover() {
    if (_isHovered) setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.button;
    final bool canShowHover = _isHovered && !widget.isDragging;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!widget.isDragging) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!widget.isDragging) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) => _clearHover(),
        onPanDown: (_) => _clearHover(),
        onLongPressStart: (_) => _clearHover(),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: canShowHover ? 1.05 : 1.0,
          curve: Curves.easeOutBack,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            offset: canShowHover ? const Offset(0, -0.02) : Offset.zero,
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: canShowHover ? context.themeCardBackground : null,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: _buildContent(button, canShowHover),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(DashboardButton button, bool canShowHover) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: button.color,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: button.color.withValues(alpha: canShowHover ? 0.4 : 0.3),
                    blurRadius: canShowHover ? 15 : 10,
                    offset: Offset(0, canShowHover ? 6 : 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white.withValues(alpha: 0.25), Colors.white.withValues(alpha: 0.0)],
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      turns: canShowHover ? 0.02 : 0.0,
                      child: DigifyAsset(assetPath: button.icon, width: 28, height: 28, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            if (button.badgeCount != null && button.badgeCount! > 0)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(color: AppColors.brandRed, shape: BoxShape.circle),
                  constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                  child: Center(
                    child: Text(
                      '${button.badgeCount}',
                      style: TextStyle(color: Colors.white, fontSize: 8.5.sp, fontWeight: FontWeight.bold, height: 1),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Gap(6.h),
        SizedBox(
          height: 30.h,
          child: Text(
            button.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.labelLarge.copyWith(
              fontSize: 11.sp,
              color: canShowHover ? AppColors.primary : context.themeTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
