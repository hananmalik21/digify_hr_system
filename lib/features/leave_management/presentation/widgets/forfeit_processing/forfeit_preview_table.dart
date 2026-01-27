import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/forfeit_processing/components/forfeit_preview_table_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/forfeit_processing/components/forfeit_preview_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForfeitPreviewTable extends StatelessWidget {
  final List<ForfeitPreviewEmployee> employees;
  final AppLocalizations localizations;
  final bool isDark;

  const ForfeitPreviewTable({super.key, required this.employees, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollableSingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                ForfeitPreviewTableHeader(isDark: isDark, localizations: localizations),
                ...employees.map(
                  (employee) => ForfeitPreviewTableRow(employee: employee, localizations: localizations),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
