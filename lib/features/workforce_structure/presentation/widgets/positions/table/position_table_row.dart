import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/position_badges.dart';

class PositionTableRow extends StatelessWidget {
  final Position position;
  final AppLocalizations localizations;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  const PositionTableRow({
    super.key,
    required this.position,
    required this.localizations,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(Text(position.code, style: textStyle), 117.53.w),
          _buildDataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(position.titleEnglish, style: textStyle),
                Text(
                  position.titleArabic,
                  textDirection: TextDirection.rtl,
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.tableHeaderText),
                ),
              ],
            ),
            162.79.w,
          ),
          _buildDataCell(Text(position.department, style: textStyle), 151.96.w),
          _buildDataCell(Text(position.jobFamily, style: textStyle), 146.86.w),
          _buildDataCell(Text(position.level, style: textStyle), 141.12.w),
          _buildDataCell(
            Text(
              '${position.grade.isNotEmpty ? 'Grade ${position.grade}' : ''}${position.grade.isNotEmpty && position.step.isNotEmpty ? ' / ' : ''}${position.step.isNotEmpty ? (position.step.toLowerCase().contains('step') ? position.step : 'Step ${position.step}') : ''}',
              style: textStyle,
            ),
            233.29.w,
          ),
          _buildDataCell(Text(position.reportsTo ?? '-', style: textStyle), 140.07.w),
          _buildDataCell(
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${position.filled}', style: textStyle),
                  TextSpan(text: '/${position.headcount}', style: textStyle),
                ],
              ),
            ),
            125.12.w,
          ),
          _buildDataCell(
            PositionVacancyBadge(
              vacancy: position.headcount - position.filled,
              vacantLabel: localizations.vacant,
              fullLabel: 'Full',
            ),
            108.22.w,
          ),
          _buildDataCell(
            PositionStatusBadge(label: localizations.active.toUpperCase(), isActive: position.isActive),
            107.02.w,
          ),
          _buildDataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8.w,
              children: [
                DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: () => onView(position)),
                DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: () => onEdit(position)),
                DigifyAssetButton(assetPath: Assets.icons.redDeleteIcon.path, onTap: () => onDelete(position)),
              ],
            ),
            130.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: child,
    );
  }
}
