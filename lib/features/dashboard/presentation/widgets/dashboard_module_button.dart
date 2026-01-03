import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          offset: canShowHover ? const Offset(0, -0.03) : Offset.zero,
          child: Container(
            padding: EdgeInsets.all(20.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: canShowHover ? Colors.white.withValues(alpha: 0.95) : Colors.transparent,
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(color: canShowHover ? const Color(0xFFE5E7EB) : Colors.transparent, width: 1.5),
                boxShadow: canShowHover
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : const [],
              ),
              child: _buildContent(button, canShowHover),
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
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: button.color,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 10)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 4)),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.0)],
                  ),
                ),
              ),
              Center(
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  turns: canShowHover ? 0.01 : 0.0,
                  child: DigifyAsset(assetPath: button.icon, width: 28, height: 28, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: button.isMultiLine ? 7.h : 6.565.h),
        Text(
          button.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w600,
            color: canShowHover ? const Color(0xFF1D4ED8) : const Color(0xFF1E2939),
            height: 13.13 / 10.5,
          ),
        ),
      ],
    );
  }
}
