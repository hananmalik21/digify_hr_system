import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EnterpriseStructureDialogHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback? onClose;

  const EnterpriseStructureDialogHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          DigifyAsset(
            assetPath: iconPath,
            width: 20,
            height: 20,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
          ),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 24 / 15,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                    height: 20 / 13,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: DigifyAsset(
                assetPath: Assets.icons.closeIcon.path,
                width: 24,
                height: 24,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              ),
            ),
        ],
      ),
    );
  }
}
