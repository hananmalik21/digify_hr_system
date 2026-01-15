// ============================================================
// SubModuleButton.dart ✅ UPDATED (accepts spec + responsive)
// ============================================================

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
  final DialogBreakpoint breakpoint;

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
    required this.breakpoint,
  });
}

class SubModuleButton extends StatefulWidget {
  final DashboardButton button;
  final VoidCallback onTap;

  /// ✅ NEW: responsive sizing config
  final SubModuleSizeSpec spec;

  const SubModuleButton({super.key, required this.button, required this.onTap, required this.spec});

  @override
  State<SubModuleButton> createState() => _SubModuleButtonState();
}

class _SubModuleButtonState extends State<SubModuleButton> {
  bool _isHovered = false;

  void _clearHover() {
    if (_isHovered) setState(() => _isHovered = false);
  }

  Color _getGradientEndColor(Color startColor) {
    return AppColors.purple;
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
        child: Card(
          elevation: _isHovered ? 4 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          color: AppColors.cardBackground,
          child: Padding(
            padding: EdgeInsets.all(
              spec.breakpoint == DialogBreakpoint.mobile
                  ? 16.0
                  : (spec.breakpoint == DialogBreakpoint.tablet ? 20.0 : 24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
                          colors: [AppColors.primaryLight, _getGradientEndColor(widget.button.color)],
                        ),
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
                                  AppColors.cardBackground.withValues(alpha: 0.2),
                                  AppColors.cardBackground.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: DigifyAsset(
                              assetPath: widget.button.icon,
                              width: spec.iconSize,
                              height: spec.iconSize,
                              color: AppColors.cardBackground,
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
                            border: Border.all(color: AppColors.primaryLight, width: 2),
                            shape: BoxShape.circle,
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

                Gap(spec.gapAfterIcon.h),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spec.titleHPad),
                  child: Text(
                    widget.button.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontSize: spec.titleFont.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dialogTitle,
                      height: 24 / 15.6,
                    ),
                  ),
                ),

                // Subtitle
                if (widget.button.subtitle != null && widget.button.subtitle!.isNotEmpty) ...[
                  Gap(16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spec.subtitleHPad),
                    child: Text(
                      widget.button.subtitle!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: spec.subtitleFont.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inactiveStatusText,
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
