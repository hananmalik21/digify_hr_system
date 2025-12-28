import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/table/position_table_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/table/position_table_row.dart';
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PositionTableHeader(isDark: isDark, localizations: localizations),
            if (isLoading && positions.isEmpty)
              Skeletonizer(
                enabled: true,
                child: Column(
                  children: List.generate(
                    8,
                    (index) => PositionTableRow(
                      position: Position.empty().copyWith(
                        code: 'POS-000000',
                        titleEnglish: 'Position Title English Extended',
                        titleArabic: 'عربي مسمى وظيفة',
                        department: 'Department Name Engineering',
                        jobFamily: 'Technical Services',
                        level: 'Senior Professional',
                        grade: '12',
                        step: '5',
                        reportsTo: 'Management Position',
                        headcount: 10,
                        filled: 5,
                        vacant: 5,
                      ),
                      localizations: localizations,
                      onView: (_) {},
                      onEdit: (_) {},
                      onDelete: (_) {},
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
    );
  }
}
