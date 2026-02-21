import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/config/manage_org_units_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgUnitsTableHeader extends StatelessWidget {
  final bool isDark;

  const OrgUnitsTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (ManageOrgUnitsTableConfig.showIndex) {
      headerCells.add(_buildHeaderCell(context, '#', ManageOrgUnitsTableConfig.indexWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showOrgStructure) {
      headerCells.add(_buildHeaderCell(context, 'Org Structure', ManageOrgUnitsTableConfig.orgStructureWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showEnterpriseId) {
      headerCells.add(_buildHeaderCell(context, 'Enterprise Id', ManageOrgUnitsTableConfig.enterpriseIdWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showLevelCode) {
      headerCells.add(_buildHeaderCell(context, 'Level Code', ManageOrgUnitsTableConfig.levelCodeWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showOrgUnitCode) {
      headerCells.add(_buildHeaderCell(context, 'Org Unit Code', ManageOrgUnitsTableConfig.orgUnitCodeWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showNameEn) {
      headerCells.add(_buildHeaderCell(context, 'Name (En)', ManageOrgUnitsTableConfig.nameEnWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showNameAr) {
      headerCells.add(_buildHeaderCell(context, 'Name (Ar)', ManageOrgUnitsTableConfig.nameArWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showParent) {
      headerCells.add(_buildHeaderCell(context, 'Parent', ManageOrgUnitsTableConfig.parentWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showActive) {
      headerCells.add(_buildHeaderCell(context, 'Active', ManageOrgUnitsTableConfig.activeWidth.w));
    }
    if (ManageOrgUnitsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, 'Actions', ManageOrgUnitsTableConfig.actionsWidth.w));
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ManageOrgUnitsTableConfig.cellPaddingHorizontal.w,
        vertical: 14.h,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText, fontWeight: FontWeight.w500),
      ),
    );
  }
}
