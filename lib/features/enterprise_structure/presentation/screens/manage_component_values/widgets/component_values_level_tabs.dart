import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentValuesLevelTabs extends ConsumerWidget {
  const ComponentValuesLevelTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLevelsState = ref.watch(activeLevelsProvider);
    final cvState = ref.watch(componentValuesProvider);
    final screenState = ref.watch(manageComponentValuesScreenProvider);
    final screenNotifier = ref.read(manageComponentValuesScreenProvider.notifier);

    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final levelsError = activeLevelsState.errorMessage;
    final isLevelsLoading = activeLevelsState.isLoading;
    final levels = activeLevelsState.levels;
    final isTreeViewActive = cvState.isTreeView;
    final selectedLevelCode = screenState.selectedLevelCode;
    final treeViewLabel = localizations.treeView;

    final onTreeViewTap = screenNotifier.selectTreeView;
    final onLevelTap = screenNotifier.selectLevel;
    if (levelsError != null) {
      return Container(
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            levelsError,
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
        ),
      );
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    final displayLevels = isLevelsLoading
        ? List.generate(
            5,
            (index) => ActiveStructureLevel(
              levelId: index,
              structureId: '0',
              levelNumber: index + 1,
              levelCode: 'level_$index',
              levelName: 'Loading Level Name',
              isMandatory: false,
              isActive: true,
              displayOrder: index,
            ),
          )
        : levels;

    return Skeletonizer(
      enabled: isLevelsLoading,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(4.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: isMobile ? const AlwaysScrollableScrollPhysics() : null,
          child: Row(
            children: [
              _LevelTabChip(
                label: treeViewLabel,
                iconPath: isTreeViewActive ? Assets.icons.treeViewIconActive.path : Assets.icons.treeViewIcon.path,
                isActive: isTreeViewActive,
                isDark: isDark,
                onTap: onTreeViewTap,
              ),
              Gap(8.w),
              ...displayLevels.map((level) {
                final icons = getIconsForLevelCode(level.levelCode);
                final isActive = selectedLevelCode == level.levelCode;
                return Padding(
                  key: Key('tab_${level.levelCode}'),
                  padding: EdgeInsetsDirectional.only(end: 8.w),
                  child: _LevelTabChip(
                    label: level.levelName,
                    iconPath: icons['icon'] ?? Assets.icons.companyIcon.path,
                    isActive: isActive,
                    isDark: isDark,
                    onTap: () => onLevelTap(level),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelTabChip extends StatelessWidget {
  const _LevelTabChip({
    required this.label,
    required this.iconPath,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: iconPath,
                width: 16,
                height: 16,
                color: isActive ? AppColors.dashboardCard : AppColors.textSecondary,
              ),
              Gap(8.w),
              Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isActive ? AppColors.dashboardCard : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
