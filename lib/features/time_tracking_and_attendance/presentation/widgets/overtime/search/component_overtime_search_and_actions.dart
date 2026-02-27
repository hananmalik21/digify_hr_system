import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/app_shadows.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../gen/assets.gen.dart';
import 'overtime_search_bar.dart';
import 'overtime_status_dropdown.dart';

class OvertimeSearchAndActions extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const OvertimeSearchAndActions({
    super.key,
    required this.localizations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: OvertimeSearchBar(
              hintText: localizations.searchPositionsPlaceholder,
              isDark: isDark,
              width: double.infinity,
            ),
          ),
          Gap(16.w),
          OvertimeStatusDropdown(
            label: localizations.allStatus,
            isDark: isDark,
          ),
          Gap(16.w),
          AppButton(
            label: localizations.export,
            onPressed: () {},
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: AppColors.shiftExportButton,
          ),
        ],
      ),
    );
  }
}
