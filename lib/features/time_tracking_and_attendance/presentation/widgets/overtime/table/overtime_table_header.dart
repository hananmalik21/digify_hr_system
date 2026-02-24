import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/theme_extensions.dart';

class OvertimeTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const OvertimeTableHeader({
    super.key,
    required this.isDark,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark
        ? AppColors.cardBackgroundDark
        : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    headerCells.addAll([
      _buildHeaderCell(context, 'EMPLOYEE'),
      _buildHeaderCell(context, 'DATE'),
      _buildHeaderCell(context, 'TYPE'),
      _buildHeaderCell(context, 'HOURS'),
      _buildHeaderCell(context, "RATE"),
      _buildHeaderCell(context, "AMOUNT"),
      _buildHeaderCell(context, "STATUS"),
      _buildHeaderCell(context, "ACTION"),
    ]);

    return Container(
      color: headerColor,
      width: context.screenWidth,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    return Flexible(
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 20.w,
          vertical: 12.h,
        ),

        child: Text(
          text.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.tableHeaderText,
          ),
        ),
      ),
    );
  }
}
