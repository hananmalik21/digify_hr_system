import 'dart:developer';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget for displaying org units data in a table
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
    debugPrint('OrgUnitsTableWidget: isLoading=$isLoading, units count=${units.length}');

    if (isLoading && units.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.h),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

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
            _buildTableHeader(context, isDark),
            if (units.isEmpty)
              Container(
                padding: EdgeInsets.all(40.h),
                child: Center(
                  child: Text(
                    localizations.noResultsFound,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...units.map((unit) {
                return _buildTableRow(unit, isDark);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isDark) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB);
    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell('ORG UNIT ID', 120.w),
          _buildHeaderCell('ORG STRUCTURE ID', 140.w),
          _buildHeaderCell('ENTERPRISE ID', 120.w),
          _buildHeaderCell('LEVEL CODE', 120.w),
          _buildHeaderCell('ORG UNIT CODE', 140.w),
          _buildHeaderCell('NAME (EN)', 180.w),
          _buildHeaderCell('NAME (AR)', 180.w),
          _buildHeaderCell('PARENT', 120.w),
          _buildHeaderCell('ACTIVE', 130.w),
          // _buildHeaderCell('MANAGER', 150.w),
          // _buildHeaderCell('MANAGER EMAIL', 200.w),
          // _buildHeaderCell('MANAGER PHONE', 150.w),
          // _buildHeaderCell('LOCATION', 150.w),
          // _buildHeaderCell('CITY', 120.w),
          // _buildHeaderCell('ADDRESS', 200.w),
          // _buildHeaderCell('DESCRIPTION', 250.w),
          // _buildHeaderCell('CREATED BY', 120.w),
          // _buildHeaderCell('CREATED DATE', 180.w),
          // _buildHeaderCell('LAST UPDATED BY', 150.w),
          // _buildHeaderCell('LAST UPDATED DATE', 180.w),
          // _buildHeaderCell('LAST UPDATE LOGIN', 150.w),
          _buildHeaderCell('ACTIONS', 112.w),
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
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6A7282),
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildTableRow(OrgStructureLevel unit, bool isDark) {
    log("id is ${unit.parentUnit}");
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.cardBorder,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Text(
              unit.orgUnitId.toString(),
              style: TextStyle(
                fontSize: 13.9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.9,
              ),
            ),
            120.w,
          ),
          _buildDataCell(
            Text(
              unit.orgStructureId.toString(),
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
              unit?.parentUnit?.name?? '-',
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
            _buildStatusBadge(unit.isActive ? localizations.active.toUpperCase() : localizations.inactive.toUpperCase(), unit.isActive),
            130.w,
          ),
          // _buildDataCell(
          //   Text(
          //     unit.managerName.isNotEmpty ? unit.managerName : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textPrimary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   150.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.managerEmail.isNotEmpty ? unit.managerEmail : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   200.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.managerPhone.isNotEmpty ? unit.managerPhone : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   150.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.location.isNotEmpty ? unit.location : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   150.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.city.isNotEmpty ? unit.city : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   120.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.address.isNotEmpty ? unit.address : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   200.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.description.isNotEmpty ? unit.description : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          //   250.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.createdBy.isNotEmpty ? unit.createdBy : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   120.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.createdDate.isNotEmpty
          //         ? (unit.createdDate.length > 10 ? unit.createdDate.substring(0, 10) : unit.createdDate)
          //         : '-',
          //     style: TextStyle(
          //       fontSize: 13.7.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.7,
          //     ),
          //   ),
          //   180.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.lastUpdatedBy.isNotEmpty ? unit.lastUpdatedBy : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   150.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.lastUpdatedDate.isNotEmpty
          //         ? (unit.lastUpdatedDate.length > 10 ? unit.lastUpdatedDate.substring(0, 10) : unit.lastUpdatedDate)
          //         : '-',
          //     style: TextStyle(
          //       fontSize: 13.7.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.7,
          //     ),
          //   ),
          //   180.w,
          // ),
          // _buildDataCell(
          //   Text(
          //     unit.lastUpdateLogin.isNotEmpty ? unit.lastUpdateLogin : '-',
          //     style: TextStyle(
          //       fontSize: 13.6.sp,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.textSecondary,
          //       height: 20 / 13.6,
          //     ),
          //   ),
          //   150.w,
          // ),
          _buildDataCell(
            Row(
              children: [
                _buildActionIcon(
                  'assets/icons/blue_eye_icon.svg',
                  onView != null ? () => onView!(unit) : null,
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  'assets/icons/edit_icon.svg',
                  onEdit != null ? () => onEdit!(unit) : null,
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  'assets/icons/red_delete_icon.svg',
                  onDelete != null ? () => onDelete!(unit) : null,
                ),
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
        child: SvgIconWidget(
          assetPath: assetPath,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, bool isActive) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 3.h,
        ),
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
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }
}
