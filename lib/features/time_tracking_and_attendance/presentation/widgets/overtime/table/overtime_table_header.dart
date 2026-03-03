import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../data/config/overtime_table_config.dart';

class OvertimeTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const OvertimeTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    headerCells.add(Gap(40.w));
    if (OvertimeTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, 'EMPLOYEE', OvertimeTableConfig.employeeWidth.w));
    }
    if (OvertimeTableConfig.showDate) {
      headerCells.add(_buildHeaderCell(context, 'DATE', OvertimeTableConfig.dateWidth.w));
    }
    if (OvertimeTableConfig.showType) {
      headerCells.add(_buildHeaderCell(context, 'TYPE', OvertimeTableConfig.typeWidth.w));
    }
    if (OvertimeTableConfig.showHours) {
      headerCells.add(_buildHeaderCell(context, 'HOURS', OvertimeTableConfig.hoursWidth.w));
    }
    if (OvertimeTableConfig.showRate) {
      headerCells.add(_buildHeaderCell(context, "RATE", OvertimeTableConfig.rateWidth.w));
    }
    if (OvertimeTableConfig.showAmount) {
      headerCells.add(_buildHeaderCell(context, "AMOUNT", OvertimeTableConfig.amountWidth.w));
    }
    if (OvertimeTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, "STATUS", OvertimeTableConfig.statusWidth.w));
    }
    if (OvertimeTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, "ACTION", OvertimeTableConfig.actionsWidth.w));
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {TextAlign textAlign = TextAlign.left}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: OvertimeTableConfig.cellPaddingHorizontal.w, vertical: 14.h),
      alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        textAlign: textAlign,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }
}
