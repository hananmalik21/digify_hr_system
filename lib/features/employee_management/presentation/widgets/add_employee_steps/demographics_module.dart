import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DemographicsModule extends StatelessWidget {
  const DemographicsModule({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final lm = Assets.icons.leaveManagement;
    final peopleIcon = _prefixIcon(context, Assets.icons.employeeListIcon.path, isDark);
    final globeIcon = _prefixIcon(context, lm.globe.path, isDark);
    final shieldIcon = _prefixIcon(context, lm.shield.path, isDark);

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
          Row(
            children: [
              DigifyAsset(
                assetPath: em.demographics.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.demographics,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              final row1 = [
                DigifyTextField(
                  labelText: localizations.gender,
                  isRequired: true,
                  prefixIcon: peopleIcon,
                  hintText: localizations.hintGender,
                ),
                DigifyTextField(
                  labelText: localizations.nationality,
                  isRequired: true,
                  prefixIcon: globeIcon,
                  hintText: localizations.hintNationality,
                ),
              ];
              final row2 = [
                DigifyTextField(
                  labelText: localizations.maritalStatus,
                  prefixIcon: peopleIcon,
                  hintText: localizations.hintMaritalStatus,
                ),
                DigifyTextField(
                  labelText: localizations.religion,
                  prefixIcon: shieldIcon,
                  hintText: localizations.hintReligion,
                ),
              ];
              if (useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: row1[0]),
                        Gap(14.w),
                        Expanded(child: row1[1]),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: row2[0]),
                        Gap(14.w),
                        Expanded(child: row2[1]),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [row1[0], row1[1], row2[0], row2[1]],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _prefixIcon(BuildContext context, String path, bool isDark) {
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
}
