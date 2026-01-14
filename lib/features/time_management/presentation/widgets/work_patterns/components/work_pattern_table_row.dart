import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/data/custom_status_cell.dart';
import 'package:digify_hr_system/features/time_management/data/config/work_patterns_table_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_action_buttons.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/components/work_pattern_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternTableRow extends StatelessWidget {
  final WorkPattern workPattern;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WorkPatternTableRow({super.key, required this.workPattern, this.onView, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (WorkPatternsTableConfig.showCode)
            _buildDataCell(
              Text(
                workPattern.patternCode,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              WorkPatternsTableConfig.codeWidth.w,
            ),
          if (WorkPatternsTableConfig.showName)
            _buildDataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    workPattern.patternNameEn,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  if (workPattern.patternNameAr.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      workPattern.patternNameAr,
                      textDirection: TextDirection.rtl,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              WorkPatternsTableConfig.nameWidth.w,
            ),
          if (WorkPatternsTableConfig.showType)
            _buildDataCell(WorkPatternTypeBadge(type: workPattern.patternType), WorkPatternsTableConfig.typeWidth.w),
          if (WorkPatternsTableConfig.showWorkingDays)
            _buildDataCell(
              Text(
                '${workPattern.workingDays} ${workPattern.workingDays == 1 ? 'day' : 'days'}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              WorkPatternsTableConfig.workingDaysWidth.w,
            ),
          if (WorkPatternsTableConfig.showRestDays)
            _buildDataCell(
              Text(
                '${workPattern.restDays} ${workPattern.restDays == 1 ? 'day' : 'days'}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              WorkPatternsTableConfig.restDaysWidth.w,
            ),
          if (WorkPatternsTableConfig.showHoursPerWeek)
            _buildDataCell(
              Text(
                '${workPattern.totalHoursPerWeek}h',
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              WorkPatternsTableConfig.hoursPerWeekWidth.w,
            ),
          if (WorkPatternsTableConfig.showStatus)
            _buildDataCell(
              CustomStatusCell(
                isActive: workPattern.status == PositionStatus.active,
                activeLabel: 'ACTIVE',
                inactiveLabel: 'INACTIVE',
              ),
              WorkPatternsTableConfig.statusWidth.w,
            ),
          if (WorkPatternsTableConfig.showActions)
            _buildDataCell(
              WorkPatternActionButtons(onView: onView, onEdit: onEdit, onDelete: onDelete),
              WorkPatternsTableConfig.actionsWidth.w,
            ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: child,
    );
  }
}
