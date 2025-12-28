import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Text(
              position.code,
              style: TextStyle(
                fontSize: 13.9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.9,
              ),
            ),
            117.53.w,
          ),
          _buildDataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.titleEnglish,
                  style: TextStyle(
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 20 / 13.7,
                  ),
                ),
                Text(
                  position.titleArabic,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
            162.79.w,
          ),
          _buildDataCell(
            Text(
              position.department,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            151.96.w,
          ),
          _buildDataCell(
            Text(
              position.jobFamily,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            146.86.w,
          ),
          _buildDataCell(
            Text(
              position.level,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.7,
              ),
            ),
            141.12.w,
          ),
          _buildDataCell(
            Text(
              '${position.grade.isNotEmpty ? 'Grade ${position.grade}' : ''}${position.grade.isNotEmpty && position.step.isNotEmpty ? ' / ' : ''}${position.step.isNotEmpty ? (position.step.toLowerCase().contains('step') ? position.step : 'Step ${position.step}') : ''}',
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.5,
              ),
            ),
            233.29.w,
          ),
          _buildDataCell(
            Text(
              position.reportsTo ?? '-',
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.7,
              ),
            ),
            140.07.w,
          ),
          _buildDataCell(
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${position.filled}',
                    style: TextStyle(
                      fontSize: 13.3.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 20 / 13.3,
                    ),
                  ),
                  TextSpan(
                    text: '/${position.headcount}',
                    style: TextStyle(
                      fontSize: 13.3.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 20 / 13.3,
                    ),
                  ),
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
            PositionStatusBadge(
              label: localizations.active.toUpperCase(),
              isActive: position.isActive,
            ),
            107.02.w,
          ),
          _buildDataCell(
            Row(
              children: [
                _buildActionIcon(
                  'assets/icons/blue_eye_icon.svg',
                  () => onView(position),
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  'assets/icons/edit_icon.svg',
                  () => onEdit(position),
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  'assets/icons/red_delete_icon.svg',
                  () => onDelete(position),
                ),
              ],
            ),
            112.03.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildActionIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgIconWidget(assetPath: assetPath, size: 16.sp),
    );
  }
}
