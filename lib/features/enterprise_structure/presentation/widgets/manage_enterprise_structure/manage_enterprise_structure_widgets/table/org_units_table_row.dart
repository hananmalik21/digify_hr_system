import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/config/manage_org_units_table_config.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgUnitsTableRow extends StatelessWidget {
  final OrgStructureLevel unit;
  final int index;
  final bool isDark;
  final AppLocalizations localizations;
  final Function(OrgStructureLevel)? onView;
  final Function(OrgStructureLevel)? onEdit;
  final Function(OrgStructureLevel)? onDelete;

  const OrgUnitsTableRow({
    super.key,
    required this.unit,
    required this.index,
    required this.isDark,
    required this.localizations,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(
      fontSize: 14.sp,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );

    final rowCells = <Widget>[];

    if (ManageOrgUnitsTableConfig.showIndex) {
      rowCells.add(_buildDataCell(Text('$index', style: textStyle), ManageOrgUnitsTableConfig.indexWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showOrgStructure) {
      rowCells.add(
        _buildDataCell(
          Text(unit.orgStructureName ?? '-', style: textStyle),
          ManageOrgUnitsTableConfig.orgStructureWidth.w,
        ),
      );
    }
    if (ManageOrgUnitsTableConfig.showEnterpriseId) {
      rowCells.add(
        _buildDataCell(
          Text(unit.enterpriseId.toString(), style: textStyle),
          ManageOrgUnitsTableConfig.enterpriseIdWidth.w,
        ),
      );
    }
    if (ManageOrgUnitsTableConfig.showLevelCode) {
      rowCells.add(
        _buildDataCell(Text(unit.levelCode, style: secondaryStyle), ManageOrgUnitsTableConfig.levelCodeWidth.w),
      );
    }
    if (ManageOrgUnitsTableConfig.showOrgUnitCode) {
      rowCells.add(
        _buildDataCell(Text(unit.orgUnitCode, style: textStyle), ManageOrgUnitsTableConfig.orgUnitCodeWidth.w),
      );
    }
    if (ManageOrgUnitsTableConfig.showNameEn) {
      rowCells.add(_buildDataCell(Text(unit.orgUnitNameEn, style: textStyle), ManageOrgUnitsTableConfig.nameEnWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showNameAr) {
      rowCells.add(
        _buildDataCell(
          unit.orgUnitNameAr.isNotEmpty
              ? Text(unit.orgUnitNameAr, style: textStyle, textDirection: TextDirection.rtl)
              : Text('-', style: secondaryStyle),
          ManageOrgUnitsTableConfig.nameArWidth.w,
        ),
      );
    }
    if (ManageOrgUnitsTableConfig.showParent) {
      rowCells.add(
        _buildDataCell(
          Text(unit.parentUnit?.name ?? '-', style: secondaryStyle),
          ManageOrgUnitsTableConfig.parentWidth.w,
        ),
      );
    }
    if (ManageOrgUnitsTableConfig.showManager) {
      rowCells.add(_buildDataCell(Text(unit.managerName, style: textStyle), ManageOrgUnitsTableConfig.managerWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showLocation) {
      rowCells.add(_buildDataCell(Text(unit.location, style: textStyle), ManageOrgUnitsTableConfig.locationWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showActive) {
      rowCells.add(_buildDataCell(_buildStatusBadge(), ManageOrgUnitsTableConfig.activeWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showLastUpdated) {
      rowCells.add(
        _buildDataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(unit.lastUpdatedDate, style: textStyle),
              Text('by HR Admin', style: secondaryStyle),
            ],
          ),
          ManageOrgUnitsTableConfig.lastUpdatedWidth.w,
        ),
      );
    }
    if (ManageOrgUnitsTableConfig.showActions) {
      rowCells.add(
        _buildDataCell(
          Row(
            spacing: 8.w,
            children: [
              DigifyAssetButton(
                assetPath: Assets.icons.blueEyeIcon.path,
                onTap: onView != null ? () => onView!(unit) : null,
              ),
              DigifyAssetButton(
                assetPath: Assets.icons.editIcon.path,
                onTap: onEdit != null ? () => onEdit!(unit) : null,
              ),
              DigifyAssetButton(
                assetPath: Assets.icons.redDeleteIcon.path,
                onTap: onDelete != null ? () => onDelete!(unit) : null,
              ),
            ],
          ),
          ManageOrgUnitsTableConfig.actionsWidth.w,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onView != null ? () => onView!(unit) : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
            ),
          ),
          child: Row(children: rowCells),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return DigifyCapsule(
      label: unit.isActive ? localizations.active.toUpperCase() : localizations.inactive.toUpperCase(),
      backgroundColor: unit.isActive ? AppColors.activeStatusBg : AppColors.inactiveStatusBg,
      textColor: unit.isActive ? AppColors.successText : AppColors.inactiveStatusText,
      borderColor: unit.isActive ? AppColors.activeStatusBorder : AppColors.inactiveStatusBorder,
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ManageOrgUnitsTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
