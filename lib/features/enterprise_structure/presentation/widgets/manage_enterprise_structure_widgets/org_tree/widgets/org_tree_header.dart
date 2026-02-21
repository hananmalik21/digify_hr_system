import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrgTreeHeader extends StatelessWidget {
  final VoidCallback onExpandAll;
  final VoidCallback onCollapseAll;
  final bool isDark;

  const OrgTreeHeader({super.key, required this.onExpandAll, required this.onCollapseAll, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsetsDirectional.all(16),
        tablet: const EdgeInsetsDirectional.all(20),
        web: const EdgeInsetsDirectional.all(24),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.organizationalTreeStructure,
            style: TextStyle(
              fontSize: isTablet ? 14.5.sp : 15.4.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 1.5,
            ),
          ),
          Row(
            children: [
              AppButton(
                label: localizations.expandAll,
                onPressed: onExpandAll,
                type: AppButtonType.secondary,
                height: 36.h,
                fontSize: isTablet ? 14.sp : 15.1.sp,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              const Gap(8),
              AppButton(
                label: localizations.collapseAll,
                onPressed: onCollapseAll,
                type: AppButtonType.secondary,
                height: 36.h,
                fontSize: isTablet ? 14.sp : 15.1.sp,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
