import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderLeftSection extends StatelessWidget {
  const HeaderLeftSection({
    super.key,
    required this.isMobile,
    required this.isDark,
    required this.onMenuTap,
    this.onLogoTap,
  });

  final bool isMobile;
  final bool isDark;
  final VoidCallback onMenuTap;
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onMenuTap,
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
            child: DigifyAsset(
              assetPath: Assets.icons.menuToggleIcon.path,
              width: isMobile ? 18 : 20,
              height: isMobile ? 18 : 20,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
            ),
          ),
        ),
        if (onLogoTap != null)
          InkWell(
            onTap: onLogoTap,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: DigifyAsset(
                assetPath: Assets.logo.digifyLogo.path,
                height: isMobile ? 40.h : 100.h,
                width: isMobile ? 100.w : 150.w,
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.all(6.r),
            child: DigifyAsset(
              assetPath: Assets.logo.digifyLogo.path,
              height: isMobile ? 40.h : 100.h,
              width: isMobile ? 100.w : 150.w,
            ),
          ),
      ],
    );
  }
}
