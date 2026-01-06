// ============================================================
// ModuleSelectionDialog.dart  ✅ UPDATED (responsive + spec)
// ============================================================

import 'dart:math' as math;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/sub_module_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

enum _Bp { mobile, tablet, desktop }

_Bp _bpFor(double w) {
  if (w < 600) return _Bp.mobile;
  if (w < 1024) return _Bp.tablet;
  return _Bp.desktop;
}

class ModuleSelectionDialog extends StatelessWidget {
  final SidebarItem module;
  final Color parentColor;

  const ModuleSelectionDialog({
    super.key,
    required this.module,
    required this.parentColor,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final children = module.children ?? [];
    final moduleLabel = SidebarConfig.getLocalizedLabel(module.labelKey, localizations);
    final cleanTitle = moduleLabel.replaceAll('\n', ' ');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final maxH = constraints.maxHeight;

            // ✅ Dialog sizing: responsive but NOT scaled with .w/.h
            final dialogW = math.min(maxW, 1024.0);
            final dialogH = math.min(maxH, 647.0);

            final bp = _bpFor(dialogW);

            // ✅ Fixed paddings/gaps like Figma (not scaled)
            final double outerPad = bp == _Bp.mobile ? 16.0 : 32.0;
            final double gap = bp == _Bp.mobile ? 16.0 : (bp == _Bp.tablet ? 20.0 : 24.0);

            // ✅ Card sizes by breakpoint (Figma-like)
            final double cardW = bp == _Bp.mobile ? 170.0 : (bp == _Bp.tablet ? 200.0 : 224.0);
            final double cardH = bp == _Bp.mobile ? 170.0 : (bp == _Bp.tablet ? 185.0 : 190.0);

            // available width inside padding
            final availableGridW = dialogW - (outerPad * 2);

            // columns based on cardW
            int cols = ((availableGridW + gap) / (cardW + gap)).floor();
            cols = cols.clamp(2, 4);

            final wrapAlign = cols >= 4 ? WrapAlignment.spaceBetween : WrapAlignment.start;

            // ✅ Spec passed into SubModuleButton (so icon/padding/text is responsive too)
            final spec = SubModuleSizeSpec(
              iconBox: bp == _Bp.mobile ? 60 : (bp == _Bp.tablet ? 72 : 80),
              iconSize: bp == _Bp.mobile ? 30 : (bp == _Bp.tablet ? 34 : 40),
              badgeBox: bp == _Bp.mobile ? 24 : (bp == _Bp.tablet ? 26 : 28),
              badgeFont: bp == _Bp.mobile ? 11 : 12,
              topPadding: bp == _Bp.mobile ? 18 : (bp == _Bp.tablet ? 20 : 22),
              gapAfterIcon: bp == _Bp.mobile ? 12 : (bp == _Bp.tablet ? 14 : 16),
              gapBeforeSubtitle: bp == _Bp.mobile ? 8 : 12,
              titleFont: bp == _Bp.mobile ? 14.5 : 15.6,
              subtitleFont: bp == _Bp.mobile ? 11.2 : 11.8,
              titleHPad: bp == _Bp.mobile ? 16 : (bp == _Bp.tablet ? 20 : 26),
              subtitleHPad: bp == _Bp.mobile ? 18 : (bp == _Bp.tablet ? 22 : 30),
            );

            // Header sizing
            final headerIconBox = bp == _Bp.mobile ? 64.0 : (bp == _Bp.tablet ? 72.0 : 80.0);
            final headerIconSize = bp == _Bp.mobile ? 32.0 : (bp == _Bp.tablet ? 36.0 : 40.0);

            return Container(
              width: dialogW,
              constraints: BoxConstraints(maxHeight: dialogH),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // =========================
                  // Header
                  // =========================
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFEFF6FF),
                          Color(0xFFEEF2FF),
                          Color(0xFFFAF5FF),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    padding: EdgeInsetsDirectional.only(
                      start: outerPad,
                      end: outerPad,
                      top: bp == _Bp.mobile ? 18.0 : 24.0,
                      bottom: bp == _Bp.mobile ? 18.0 : 24.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: bp == _Bp.mobile ? 14.0 : 20.0,
                            runSpacing: 12.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              // Icon box
                              Container(
                                width: headerIconBox,
                                height: headerIconBox,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF615FFF),
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 50,
                                      offset: const Offset(0, 25),
                                      spreadRadius: -12,
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
                                            Colors.white.withValues(alpha: 0.3),
                                            Colors.white.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: module.svgPath != null
                                          ? DigifyAsset(
                                        assetPath: module.svgPath!,
                                        width: headerIconSize,
                                        height: headerIconSize,
                                        color: Colors.white,
                                      )
                                          : Icon(
                                        Icons.grid_view_rounded,
                                        size: headerIconSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Title + badge
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: dialogW - 140),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      cleanTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: (bp == _Bp.mobile ? 14.5 : 15.5).sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF4A5565),
                                        height: 24 / 15.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDBEAFE),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Text(
                                        '${children.length} items',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1447E6),
                                          height: 16 / 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Close button
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                                spreadRadius: -3,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.r),
                              onTap: () => Navigator.of(context).pop(),
                              child: Center(
                                child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // Section title
                  // =========================
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFF0F4FF).withValues(alpha: 0.35),
                          Colors.white,
                        ],
                      ),
                    ),
                    padding: EdgeInsetsDirectional.only(
                      start: outerPad,
                      end: outerPad,
                      top: 18.0,
                      bottom: 10.0,
                    ),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      '$cleanTitle Modules',
                      style: TextStyle(
                        fontSize: 17.3.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2939),
                        height: 27 / 17.3,
                      ),
                    ),
                  ),

                  // =========================
                  // Grid
                  // =========================
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFF9FAFB).withValues(alpha: 0.5),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: children.isEmpty
                          ? Center(
                        child: Text(
                          'No items available',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        padding: EdgeInsets.all(outerPad),
                        child: Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          alignment: wrapAlign,
                          children: children.asMap().entries.map((entry) {
                            final index = entry.key;
                            final child = entry.value;

                            final childLabel = SidebarConfig.getLocalizedLabel(
                              child.labelKey,
                              localizations,
                            );

                            final btn = DashboardButton(
                              id: child.id,
                              icon: child.svgPath ?? 'assets/icons/default_icon.svg',
                              label: childLabel,
                              color: parentColor,
                              route: child.route ?? '',
                              isMultiLine: childLabel.contains('\n') || childLabel.length > 20,
                              badgeCount: index + 1,
                            );

                            return SizedBox(
                              width: cardW,
                              height: cardH,
                              child: SubModuleButton(
                                button: btn,
                                onTap: () {
                                  if (btn.route.isNotEmpty) {
                                    Navigator.of(context).pop();
                                    context.go(btn.route);
                                  }
                                },
                                spec: spec, // ✅ pass responsive sizing
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
