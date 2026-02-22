import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HierarchyLevelsWidget extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final List<String> levels;
  final int levelCount;

  const HierarchyLevelsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.levels,
    required this.levelCount,
  });

  static List<String> get _iconPool => [
    Assets.icons.companyIconPurple.path,
    Assets.icons.businessUnitIconPurple.path,
    Assets.icons.businessUnitSmallIcon.path,
    Assets.icons.departmentIconPurple.path,
    Assets.icons.sectionIconPurple.path,
  ];

  String _resolveIconByIndex(int index) {
    return _iconPool[index % _iconPool.length];
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText;
    final levelStyle = context.textTheme.labelMedium?.copyWith(color: AppColors.primary);
    final mutedStyle = context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: labelColor);
    final arrowColor = isDark ? AppColors.textPlaceholderDark : AppColors.sidebarCategoryText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${localizations.hierarchy}:', style: context.textTheme.bodyMedium?.copyWith(color: labelColor)),
        Gap(8.w),
        Wrap(
          runSpacing: 6.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: levels.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                    border: Border.all(color: AppColors.ingobgBorder),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DigifyAsset(
                        assetPath: _resolveIconByIndex(index),
                        width: 14,
                        height: 14,
                        color: AppColors.primary,
                      ),
                      Gap(4.w),
                      Text(level, style: levelStyle),
                    ],
                  ),
                ),
                if (index < levels.length - 1) ...[
                  Gap(8.w),
                  DigifyAsset(assetPath: Assets.icons.enterpriseStructure.rightArrow.path, color: arrowColor),
                  Gap(8.w),
                ],
              ],
            );
          }).toList(),
        ),
        Gap(8.w),
        Text('($levelCount ${localizations.levels})', style: mutedStyle),
      ],
    );
  }
}
