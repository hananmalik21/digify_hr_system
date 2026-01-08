import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/feedback/shimmer_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Styled to match the workforce structure table
class OrgUnitsTableWidget extends StatelessWidget {
  final List<OrgStructureLevel> units;
  final bool isLoading;
  final bool isDark;
  final AppLocalizations localizations;
  final Function(OrgStructureLevel)? onView;
  final Function(OrgStructureLevel)? onEdit;
  final Function(OrgStructureLevel)? onDelete;

  const OrgUnitsTableWidget({
    super.key,
    required this.units,
    required this.isLoading,
    required this.isDark,
    required this.localizations,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Shimmer while loading first page (no data yet)
    if (isLoading && units.isEmpty) {
      return _buildTableShimmer(context);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = constraints.maxWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: tableWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableHeader(context),
                  if (units.isEmpty)
                    Container(
                      padding: EdgeInsets.all(40.h),
                      child: Center(
                        child: Text(
                          localizations.noResultsFound,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...units.asMap().entries.map((entry) => _buildTableRow(entry.value, entry.key + 1)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // Real table header/rows
  // =========================

  Widget _buildTableHeader(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB);

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell('#', 80.w),
          _buildHeaderCell('Org Structure', 140.w),
          _buildHeaderCell('Enterprise Id', 120.w),
          _buildHeaderCell('Level Code', 120.w),
          _buildHeaderCell('Org Unit Code', 140.w),
          _buildHeaderCell('Name (En)', 180.w),
          _buildHeaderCell('Name (Ar)', 180.w),
          _buildHeaderCell('Parent', 120.w),
          _buildHeaderCell('Active', 130.w),
          _buildHeaderCell('Actions', 112.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6A7282),
            height: 16 / 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(OrgStructureLevel unit, int index) {
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
              index.toString(),
              style: TextStyle(
                fontSize: 13.9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.9,
              ),
            ),
            80.w,
          ),
          _buildDataCell(
            Text(
              unit.orgStructureName ?? '-',
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            140.w,
          ),
          _buildDataCell(
            Text(
              unit.enterpriseId.toString(),
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            120.w,
          ),
          _buildDataCell(
            Text(
              unit.levelCode,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            120.w,
          ),
          _buildDataCell(
            Text(
              unit.orgUnitCode,
              style: TextStyle(
                fontSize: 13.9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.9,
              ),
            ),
            140.w,
          ),
          _buildDataCell(
            Text(
              unit.orgUnitNameEn,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.7,
              ),
            ),
            180.w,
          ),
          _buildDataCell(
            unit.orgUnitNameAr.isNotEmpty
                ? Text(
                    unit.orgUnitNameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 20 / 14,
                    ),
                  )
                : Text(
                    '-',
                    style: TextStyle(
                      fontSize: 13.7.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 20 / 13.7,
                    ),
                  ),
            180.w,
          ),
          _buildDataCell(
            Text(
              unit.parentUnit?.name ?? '-',
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.7,
              ),
            ),
            120.w,
          ),
          _buildDataCell(
            _buildStatusBadge(
              unit.isActive ? localizations.active.toUpperCase() : localizations.inactive.toUpperCase(),
              unit.isActive,
            ),
            130.w,
          ),
          _buildDataCell(
            Row(
              children: [
                _buildActionIcon('assets/icons/blue_eye_icon.svg', onView != null ? () => onView!(unit) : null),
                SizedBox(width: 8.w),
                _buildActionIcon('assets/icons/edit_icon.svg', onEdit != null ? () => onEdit!(unit) : null),
                SizedBox(width: 8.w),
                _buildActionIcon('assets/icons/red_delete_icon.svg', onDelete != null ? () => onDelete!(unit) : null),
              ],
            ),
            112.w,
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(String assetPath, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.5,
        child: DigifyAsset(assetPath: assetPath, width: 16, height: 16),
      ),
    );
  }

  Widget _buildStatusBadge(String label, bool isActive) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.successBg : AppColors.orangeBg,
          borderRadius: BorderRadius.circular(9999.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.8.sp,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.successText : AppColors.orangeText,
            height: 16 / 11.8,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Center(child: child),
    );
  }

  // =========================
  // Shimmer table (loading)
  // =========================

  Widget _buildTableShimmer(BuildContext context) {
    final isDarkTheme = context.isDark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = constraints.maxWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: tableWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildHeaderShimmer(isDarkTheme), ...List.generate(6, (_) => _buildRowShimmer())],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderShimmer(bool isDarkTheme) {
    return Container(
      color: isDarkTheme ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB),
      child: Row(
        children: [
          _headerCellShimmer(80),
          _headerCellShimmer(140),
          _headerCellShimmer(120),
          _headerCellShimmer(120),
          _headerCellShimmer(140),
          _headerCellShimmer(180),
          _headerCellShimmer(180),
          _headerCellShimmer(120),
          _headerCellShimmer(130),
          _headerCellShimmer(112),
        ],
      ),
    );
  }

  Widget _headerCellShimmer(double width) {
    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      child: ShimmerContainer(width: (width.w * 0.6).clamp(40.w, 140.w), height: 10.h, borderRadius: 6),
    );
  }

  Widget _buildRowShimmer() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          _cellShimmer(80),
          _cellShimmer(140),
          _cellShimmer(120),
          _cellShimmer(120),
          _cellShimmer(140),
          _cellShimmer(180),
          _cellShimmer(180),
          _cellShimmer(120),
          _statusCellShimmer(130),
          _actionsCellShimmer(112),
        ],
      ),
    );
  }

  Widget _cellShimmer(double width) {
    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: ShimmerContainer(width: (width.w * 0.7).clamp(50.w, width.w - 24.w), height: 12.h, borderRadius: 6),
    );
  }

  Widget _statusCellShimmer(double width) {
    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Center(
        child: ShimmerContainer(width: 64.w, height: 18.h, borderRadius: 999),
      ),
    );
  }

  Widget _actionsCellShimmer(double width) {
    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          ShimmerContainer(width: 16.sp, height: 16.sp, borderRadius: 4),
          SizedBox(width: 8.w),
          ShimmerContainer(width: 16.sp, height: 16.sp, borderRadius: 4),
          SizedBox(width: 8.w),
          ShimmerContainer(width: 16.sp, height: 16.sp, borderRadius: 4),
        ],
      ),
    );
  }
}
