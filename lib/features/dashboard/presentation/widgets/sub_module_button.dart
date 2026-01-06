// ============================================================
// SubModuleButton.dart ✅ UPDATED (accepts spec + responsive)
// ============================================================

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubModuleSizeSpec {
  final double iconBox;
  final double iconSize;
  final double badgeBox;
  final double badgeFont;

  final double topPadding;
  final double gapAfterIcon;
  final double gapBeforeSubtitle;

  final double titleFont;
  final double subtitleFont;

  final double titleHPad;
  final double subtitleHPad;

  const SubModuleSizeSpec({
    required this.iconBox,
    required this.iconSize,
    required this.badgeBox,
    required this.badgeFont,
    required this.topPadding,
    required this.gapAfterIcon,
    required this.gapBeforeSubtitle,
    required this.titleFont,
    required this.subtitleFont,
    required this.titleHPad,
    required this.subtitleHPad,
  });
}

class SubModuleButton extends StatefulWidget {
  final DashboardButton button;
  final VoidCallback onTap;

  /// ✅ NEW: responsive sizing config
  final SubModuleSizeSpec spec;

  const SubModuleButton({
    super.key,
    required this.button,
    required this.onTap,
    required this.spec,
  });

  @override
  State<SubModuleButton> createState() => _SubModuleButtonState();
}

class _SubModuleButtonState extends State<SubModuleButton> {
  bool _isHovered = false;

  void _clearHover() {
    if (_isHovered) setState(() => _isHovered = false);
  }

  Color _getGradientEndColor(Color startColor) {
    return const Color(0xFF615FFF);
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _clearHover(),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            border: Border.all(
              color: _isHovered ? const Color(0xFFE5E7EB) : const Color(0xFFF3F4F6),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.14 : 0.10),
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.14 : 0.10),
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: spec.topPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon + badge
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: spec.iconBox,
                      height: spec.iconBox,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2B7FFF),
                            _getGradientEndColor(widget.button.color),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 25,
                            offset: const Offset(0, 20),
                            spreadRadius: -5,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                            spreadRadius: -6,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: DigifyAsset(
                              assetPath: widget.button.icon,
                              width: spec.iconSize,
                              height: spec.iconSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (widget.button.badgeCount != null && widget.button.badgeCount! > 0)
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Container(
                          width: spec.badgeBox,
                          height: spec.badgeBox,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            border: Border.all(
                              color: AppColors.primaryLight,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                                spreadRadius: -3,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.button.badgeCount.toString(),
                              style: TextStyle(
                                fontSize: spec.badgeFont.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                height: 16.0 / 12.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: spec.gapAfterIcon),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spec.titleHPad),
                  child: Text(
                    widget.button.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: spec.titleFont.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101828),
                      height: 24 / 15.6,
                    ),
                  ),
                ),

                // Subtitle
                if (widget.button.subtitle != null && widget.button.subtitle!.isNotEmpty) ...[
                  SizedBox(height: spec.gapBeforeSubtitle),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spec.subtitleHPad),
                    child: Text(
                      widget.button.subtitle!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: spec.subtitleFont.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                        height: 16.8 / 11.8,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
