import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_compensation_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationAllowancesModule extends ConsumerWidget {
  const CompensationAllowancesModule({super.key});

  static final DateTime _firstDate = DateTime(2000);
  static final DateTime _lastDate = DateTime(2030, 12, 31);

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
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeCompensationProvider);
    final notifier = ref.read(addEmployeeCompensationProvider.notifier);
    final dollarIcon = _prefixIcon(context, Assets.icons.leaveManagement.dollar.path, isDark);
    final hint = localizations.hintEnterAmount;

    final housing = DigifyTextField(
      labelText: localizations.housingAllowanceKwd,
      isRequired: true,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
      initialValue: state.housingKwd ?? '',
      onChanged: notifier.setHousingKwd,
    );
    final transportation = DigifyTextField(
      labelText: localizations.transportationKwd,
      isRequired: true,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
      initialValue: state.transportKwd ?? '',
      onChanged: notifier.setTransportKwd,
    );
    final food = DigifyTextField(
      labelText: localizations.foodAllowanceKwd,
      isRequired: true,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
      initialValue: state.foodKwd ?? '',
      onChanged: notifier.setFoodKwd,
    );
    final mobile = DigifyTextField(
      labelText: localizations.mobileAllowanceKwd,
      isRequired: true,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
      initialValue: state.mobileKwd ?? '',
      onChanged: notifier.setMobileKwd,
    );
    final other = DigifyTextField(
      labelText: localizations.otherAllowancesKwd,
      isRequired: true,
      prefixIcon: dollarIcon,
      hintText: hint,
      keyboardType: FieldFormat.currency,
      inputFormatters: FieldFormat.currencyAmount,
      initialValue: state.otherKwd ?? '',
      onChanged: notifier.setOtherKwd,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DigifyDateField(
                            label: localizations.startDate,
                            isRequired: true,
                            hintText: localizations.hintSelectDate,
                            initialDate: state.allowStart,
                            firstDate: _firstDate,
                            lastDate: _lastDate,
                            onDateSelected: notifier.setAllowStart,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: DigifyDateField(
                            label: localizations.endDate,
                            isRequired: true,
                            hintText: localizations.hintSelectDate,
                            initialDate: state.allowEnd,
                            firstDate: _firstDate,
                            lastDate: _lastDate,
                            onDateSelected: notifier.setAllowEnd,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [
                  housing,
                  transportation,
                  food,
                  mobile,
                  other,
                  DigifyDateField(
                    label: localizations.startDate,
                    isRequired: true,
                    hintText: localizations.hintSelectDate,
                    initialDate: state.allowStart,
                    firstDate: _firstDate,
                    lastDate: _lastDate,
                    onDateSelected: notifier.setAllowStart,
                  ),
                  DigifyDateField(
                    label: localizations.endDate,
                    isRequired: true,
                    hintText: localizations.hintSelectDate,
                    initialDate: state.allowEnd,
                    firstDate: _firstDate,
                    lastDate: _lastDate,
                    onDateSelected: notifier.setAllowEnd,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
