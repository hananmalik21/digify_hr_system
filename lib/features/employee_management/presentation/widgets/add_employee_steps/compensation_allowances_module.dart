import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationAllowancesModule extends StatelessWidget {
  const CompensationAllowancesModule({super.key});

  static Widget _prefixIcon(BuildContext context, String path, bool isDark) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final dollarIcon = _prefixIcon(context, Assets.icons.leaveManagement.dollar.path, isDark);
    final hint = localizations.hintEnterAmount;

    final housing = DigifyTextField(
      labelText: localizations.housingAllowanceKwd,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
    );
    final transportation = DigifyTextField(
      labelText: localizations.transportationKwd,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
    );
    final food = DigifyTextField(
      labelText: localizations.foodAllowanceKwd,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
    );
    final mobile = DigifyTextField(
      labelText: localizations.mobileAllowanceKwd,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
    );
    final other = DigifyTextField(
      labelText: localizations.otherAllowancesKwd,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
    );

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18.h,
        children: [
          Text(
            localizations.allowances,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              if (useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: housing),
                        Gap(14.w),
                        Expanded(child: transportation),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: food),
                        Gap(14.w),
                        Expanded(child: mobile),
                      ],
                    ),
                    other,
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [housing, transportation, food, mobile, other],
              );
            },
          ),
        ],
      ),
    );
  }
}
