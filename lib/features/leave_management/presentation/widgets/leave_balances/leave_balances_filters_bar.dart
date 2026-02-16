import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalancesFiltersBar extends StatelessWidget {
  final AppLocalizations localizations;
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onExport;
  final VoidCallback? onRefresh;

  const LeaveBalancesFiltersBar({
    super.key,
    required this.localizations,
    required this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onExport,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: searchController,
            hintText: 'Search by name or employee number...',
            filled: false,
            borderColor: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                label: localizations.export,
                onPressed: onExport,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
              AppButton(
                label: '${localizations.refresh} Balances',
                onPressed: onRefresh,
                svgPath: Assets.icons.refreshGray.path,
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
