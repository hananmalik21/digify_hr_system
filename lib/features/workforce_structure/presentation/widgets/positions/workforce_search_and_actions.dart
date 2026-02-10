import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/search/workforce_search_bar.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/search/workforce_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:gap/gap.dart';

class WorkforceSearchAndActions extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const WorkforceSearchAndActions({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          WorkforceSearchBar(
            hintText: localizations.searchPositionsPlaceholder,
            isDark: isDark,
            width: double.infinity,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              WorkforceStatusDropdown(label: localizations.allStatus, isDark: isDark),
              AppButton(
                label: localizations.import,
                onPressed: () {},
                svgPath: Assets.icons.bulkUploadIconFigma.path,
                backgroundColor: AppColors.shiftUploadButton,
              ),
              AppButton(
                label: localizations.export,
                onPressed: () {},
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
