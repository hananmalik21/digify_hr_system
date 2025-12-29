import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/search/workforce_search_bar.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/search/workforce_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class WorkforceSearchAndActions extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback onAddPosition;

  const WorkforceSearchAndActions({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.onAddPosition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          WorkforceSearchBar(
            hintText: localizations.searchPositionsPlaceholder,
            isDark: isDark,
          ),
          WorkforceStatusDropdown(
            label: localizations.allStatus,
            isDark: isDark,
          ),
          AppButton(
            label: localizations.addPosition,
            onPressed: onAddPosition,
            svgPath: Assets.icons.addDivisionIcon.path,
            padding: EdgeInsets.zero,
          ),
          AppButton(
            label: localizations.import,
            onPressed: () {},
            svgPath: Assets.icons.bulkUploadIconFigma.path,
            backgroundColor: const Color(0xFFE7F2FF),
            foregroundColor: const Color(0xFF155DFC),
            padding: EdgeInsets.zero,
          ),
          AppButton(
            label: localizations.export,
            onPressed: () {},
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: const Color(0xFF4A5565),
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
