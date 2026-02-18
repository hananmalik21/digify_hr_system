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
    this.isSidebarExpanded = false,
    this.onLogoTap,
  });

  final bool isMobile;
  final bool isDark;
  final bool isSidebarExpanded;
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
            child: isSidebarExpanded
                ? DigifyAsset(
                    assetPath: Assets.icons.closeIcon.path,
                    width: 20.w,
                    height: 20.h,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.lightDark,
                  )
                : DigifyAsset(
                    assetPath: Assets.icons.menuToggleIcon.path,
                    height: 20.h,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.lightDark,
                  ),
          ),
        ),
        if (!isSidebarExpanded) ...[
          if (onLogoTap != null)
            InkWell(
              onTap: onLogoTap,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: DigifyAsset(
                  assetPath: isDark ? Assets.logo.digifyLogoDark.path : Assets.logo.digifyLogo.path,
                  height: 25.h,
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(6.r),
              child: DigifyAsset(
                assetPath: isDark ? Assets.logo.digifyLogoDark.path : Assets.logo.digifyLogo.path,
                height: 20.h,
              ),
            ),
        ],
      ],
    );
  }
}
