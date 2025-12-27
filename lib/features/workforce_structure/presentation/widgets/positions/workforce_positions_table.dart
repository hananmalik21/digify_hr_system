import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforcePositionsTable extends StatelessWidget {
  final AppLocalizations localizations;
  final List<Position> positions;
  final bool isDark;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  const WorkforcePositionsTable({
    super.key,
    required this.localizations,
    required this.positions,
    required this.isDark,
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
            _buildTableHeader(),
            ...positions.map((position) => _buildTableRow(position)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final headerColor = isDark
        ? AppColors.cardBackgroundDark
        : const Color(0xFFF9FAFB);
    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(localizations.positionCode, 117.53.w),
          _buildHeaderCell(localizations.title, 162.79.w),
          _buildHeaderCell(localizations.department, 151.96.w),
          _buildHeaderCell(localizations.jobFamily, 146.86.w),
          _buildHeaderCell(localizations.jobLevel, 141.12.w),
          _buildHeaderCell(localizations.gradeStep, 133.29.w),
          _buildHeaderCell(localizations.step, 100.w),
          _buildHeaderCell(localizations.reportsTo, 140.07.w),
          _buildHeaderCell(localizations.headcount, 125.12.w),
          _buildHeaderCell(localizations.vacancy, 108.22.w),
          _buildHeaderCell(localizations.status, 107.02.w),
          _buildHeaderCell(localizations.actions, 112.03.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 12.h,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6A7282),
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildTableRow(Position position) {
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
              position.grade,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.5,
              ),
            ),
            133.29.w,
          ),
          _buildDataCell(
            Text(
              position.step,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.5,
              ),
            ),
            100.w,
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
            RichText(
              text: TextSpan(
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
          _buildDataCell(_buildVacancyBadge(position), 108.22.w),
          _buildDataCell(
            _buildStatusBadge(localizations.active.toUpperCase()),
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
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildVacancyBadge(Position position) {
    final vacancy = position.headcount - position.filled;
    final hasVacancy = vacancy > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: hasVacancy ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        hasVacancy ? '$vacancy ${localizations.vacant}' : 'Full',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: hasVacancy ? const Color(0xFFB45309) : const Color(0xFF15803D),
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF15803D),
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildActionIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgIconWidget(assetPath: assetPath, size: 16.sp),
    );
  }
}
