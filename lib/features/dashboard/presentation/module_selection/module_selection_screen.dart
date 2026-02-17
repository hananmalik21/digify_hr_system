import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/features/dashboard/presentation/module_selection/module_selection_helpers.dart';
import 'package:digify_hr_system/features/dashboard/presentation/module_selection/module_selection_sizing.dart';
import 'package:digify_hr_system/features/dashboard/presentation/module_selection/widgets/module_selection_grid.dart';
import 'package:digify_hr_system/features/dashboard/presentation/module_selection/widgets/module_selection_header.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ModuleSelectionScreen extends ConsumerWidget {
  final String moduleId;

  const ModuleSelectionScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final sidebarItems = SidebarConfig.getMenuItems();
    final module = resolveModuleForSelection(moduleId, sidebarItems);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.backgroundDark : AppColors.background;

    if (module == null || module.children == null || module.children!.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: Text(localizations.noResultsFound, style: theme.textTheme.bodyLarge)),
      );
    }

    final children = module.children!;
    final parentColor = parentColorForModule(moduleId, localizations);
    final contentWidth = MediaQuery.sizeOf(context).width.clamp(320.0, 1800.0);
    final isMobile = contentWidth < 600;
    final sizing = DialogSizing.calculate(contentWidth, MediaQuery.sizeOf(context).height);
    final pagePadding = EdgeInsetsDirectional.only(
      top: isMobile ? 20.h : 45.5.h,
      start: isMobile ? 12.w : 24.w,
      end: isMobile ? 12.w : 24.w,
      bottom: 14.h,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            DashboardBackground(isDark: isDark),
            SingleChildScrollView(
              padding: pagePadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ModuleSelectionHeader(module: module, childrenCount: children.length, parentColor: parentColor),
                      Gap(24.h),
                      ModuleSelectionGrid(children: children, parentColor: parentColor, sizing: sizing),
                      Gap(24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
