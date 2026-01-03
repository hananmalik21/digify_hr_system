import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardBackground extends StatelessWidget {
  final bool isDark;

  const DashboardBackground({super.key, required this.isDark});

  Widget _blurOval({
    required double width,
    required double height,
    required List<Color> colors,
    required double blurX,
    required double blurY,
    double opacity = 0.18,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
            ),
          ),

          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
              child: Container(
                color: (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground).withValues(alpha: opacity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: isDark
              ? [AppColors.cardBackgroundGreyDark, AppColors.infoBgDark, AppColors.cardBackgroundGreyDark]
              : const [Color(0xFFF3F4F6), Color(0xFFEFF6FF), Color(0xFFF3F4F6)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _blurOval(
              width: 336.w,
              height: 336.h,
              blurX: 40,
              blurY: 40,
              opacity: isDark ? 0.10 : 0.16,
              colors: [
                const Color(0xFF51A2FF).withValues(alpha: 0.22),
                const Color(0xFFC27AFF).withValues(alpha: 0.22),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _blurOval(
              width: 336.w,
              height: 336.h,
              blurX: 32,
              blurY: 32,
              opacity: isDark ? 0.10 : 0.16,
              colors: [
                const Color(0xFFFB64B6).withValues(alpha: 0.22),
                const Color(0xFFFF8904).withValues(alpha: 0.22),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: _blurOval(
                width: 336.w,
                height: 336.h,
                blurX: 100,
                blurY: 100,
                opacity: isDark ? 0.08 : 0.12,
                colors: [
                  const Color(0xFF05DF72).withValues(alpha: 0.14),
                  const Color(0xFF00D3F2).withValues(alpha: 0.14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
