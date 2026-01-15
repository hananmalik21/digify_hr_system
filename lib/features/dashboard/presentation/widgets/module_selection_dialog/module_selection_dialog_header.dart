import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ModuleSelectionDialogHeader extends StatelessWidget {
  final SidebarItem module;
  final int childrenCount;
  final DialogSizing sizing;

  const ModuleSelectionDialogHeader({
    super.key,
    required this.module,
    required this.childrenCount,
    required this.sizing,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final moduleLabel = SidebarConfig.getLocalizedLabel(module.labelKey, localizations);
    final cleanTitle = moduleLabel.replaceAll('\n', ' ');

    final headerIconBox = 80.0;
    final headerIconSize = 40.0;
    final topPadding = sizing.breakpoint == DialogBreakpoint.mobile ? 18.0 : 24.0;
    final bottomPadding = sizing.breakpoint == DialogBreakpoint.mobile ? 18.0 : 24.0;
    final spacing = sizing.breakpoint == DialogBreakpoint.mobile ? 14.0 : 20.0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.infoBg, AppColors.infoBg, AppColors.purpleBg],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
      ),
      padding: EdgeInsetsDirectional.only(
        start: sizing.outerPadding,
        end: sizing.outerPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              spacing: spacing,
              runSpacing: 12.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildIcon(headerIconBox, headerIconSize),
                _buildTitleAndBadge(cleanTitle, childrenCount, sizing.dialogWidth, context),
              ],
            ),
          ),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildIcon(double iconBox, double iconSize) {
    return SizedBox(
      width: iconBox,
      height: iconBox,
      child: Container(
        decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(24.r)),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: DigifyAsset(
            assetPath: module.svgPath ?? '',
            width: iconSize,
            height: iconSize,
            color: AppColors.cardBackground,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndBadge(String title, int count, double dialogWidth, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: dialogWidth - 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(fontSize: 15.4.sp, color: AppColors.textSecondary),
          ),
          Gap(8.h),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(9999)),
            child: Text(
              '$count items',
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.roleBadgeText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.8),
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
          child: Center(child: Icon(Icons.close, size: 20, color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}
