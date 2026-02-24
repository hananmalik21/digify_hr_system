import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/configs/reporting_table_config.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportingTableRow extends StatelessWidget {
  final ReportingPosition position;
  final bool isDark;
  final AppLocalizations localizations;
  final Function(ReportingPosition)? onView;
  final Function(ReportingPosition)? onEdit;

  const ReportingTableRow({
    super.key,
    required this.position,
    required this.isDark,
    required this.localizations,
    this.onView,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);

    final rowCells = <Widget>[];

    if (ReportingTableConfig.showCode) {
      rowCells.add(
        _buildDataCell(
          Text(
            position.positionCode.toUpperCase(),
            style: textStyle?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ReportingTableConfig.codeWidth.w,
        ),
      );
    }
    if (ReportingTableConfig.showTitle) {
      rowCells.add(
        _buildDataCell(
          Text(position.titleEnglish, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ReportingTableConfig.titleWidth.w,
        ),
      );
    }
    if (ReportingTableConfig.showDepartment) {
      rowCells.add(
        _buildDataCell(
          Text(position.department.toUpperCase(), style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ReportingTableConfig.departmentWidth.w,
        ),
      );
    }
    if (ReportingTableConfig.showLevel) {
      rowCells.add(
        _buildDataCell(
          Text(position.level, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ReportingTableConfig.levelWidth.w,
        ),
      );
    }
    if (ReportingTableConfig.showGrade) {
      rowCells.add(
        _buildDataCell(
          Text(position.gradeStep, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ReportingTableConfig.gradeWidth.w,
        ),
      );
    }
    if (ReportingTableConfig.showReportsTo) {
      final isTopLevel = position.reportsToTitle == null || position.reportsToTitle!.trim().isEmpty;
      rowCells.add(
        _buildDataCell(
          isTopLevel
              ? DigifyCapsule(
                  label: "TOP LEVEL",
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  textColor: AppColors.primary,
                  borderColor: AppColors.primary.withValues(alpha: 0.2),
                )
              : Text(position.reportsToTitle!, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ReportingTableConfig.reportsToWidth.w,
        ),
      );
    }
    if (ReportingTableConfig.showStatus) {
      rowCells.add(_buildDataCell(_buildStatusCapsule(), ReportingTableConfig.statusWidth.w));
    }
    if (ReportingTableConfig.showActions) {
      rowCells.add(
        _buildDataCell(
          ReportingActionButtons(position: position, onView: onView, onEdit: onEdit),
          ReportingTableConfig.actionsWidth.w,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(children: rowCells),
    );
  }

  Widget _buildStatusCapsule() {
    final isActive = position.status.toLowerCase() == 'active';
    return DigifyCapsule(
      label: (isActive ? localizations.active : localizations.inactive).toUpperCase(),
      backgroundColor: isActive ? AppColors.activeStatusBg : AppColors.inactiveStatusBg,
      textColor: isActive ? AppColors.successText : AppColors.inactiveStatusText,
      borderColor: isActive ? AppColors.activeStatusBorder : AppColors.inactiveStatusBorder,
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ReportingTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }
}
