import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderNotificationIcon extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final bool isDark;

  const HeaderNotificationIcon({super.key, required this.count, this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DigifyAssetButton(
          onTap: onTap,
          assetPath: Assets.icons.header.notificationBell.path,
          width: 30.sp,
          height: 30.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
          padding: 6.r,
        ),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2.r),
              constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
              decoration: BoxDecoration(
                color: AppColors.deleteIconRed,
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground, width: 2.w),
              ),
              alignment: Alignment.center,
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: context.textTheme.headlineMedium?.copyWith(fontSize: 10.sp, color: AppColors.cardBackground),
              ),
            ),
          ),
      ],
    );
  }
}
