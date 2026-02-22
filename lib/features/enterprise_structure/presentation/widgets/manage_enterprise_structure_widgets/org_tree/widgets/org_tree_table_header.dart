import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgTreeTableHeader extends StatelessWidget {
  final bool isDark;

  const OrgTreeTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = context.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.categoryBadgeBorder : AppColors.categoryBadgeBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell(localizations.componentCode, 2, textTheme),
          _buildHeaderCell(localizations.componentName, 4, textTheme),
          _buildHeaderCell(localizations.arabicName, 3, textTheme),
          _buildHeaderCell(localizations.parentComponent, 3, textTheme),
          _buildHeaderCell(localizations.manager, 3, textTheme),
          _buildHeaderCell(localizations.location, 3, textTheme),
          _buildHeaderCell(localizations.status, 2, textTheme),
          _buildHeaderCell(localizations.lastUpdated, 3, textTheme),
          _buildHeaderCell(localizations.actions, 2, textTheme, isLast: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, int flex, TextTheme textTheme, {bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 16.w),
        child: Text(
          label.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
