import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/table/position_table_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/table/position_table_row.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/table/position_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkforcePositionsTable extends StatelessWidget {
  final AppLocalizations localizations;
  final List<Position> positions;
  final bool isDark;
  final bool isLoading;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  const WorkforcePositionsTable({
    super.key,
    required this.localizations,
    required this.positions,
    required this.isDark,
    this.isLoading = false,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PositionTableHeader(isDark: isDark, localizations: localizations),
              if (isLoading && positions.isEmpty)
                PositionTableSkeleton(localizations: localizations)
              else if (positions.isEmpty && !isLoading)
                SizedBox(
                  width: 1200.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Center(
                      child: Text(
                        localizations.noResultsFound,
                        style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                )
              else
                ...positions.map(
                  (position) => PositionTableRow(
                    position: position,
                    localizations: localizations,
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
