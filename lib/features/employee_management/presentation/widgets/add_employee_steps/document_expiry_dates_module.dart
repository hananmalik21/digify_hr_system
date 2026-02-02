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

class DocumentExpiryDatesModule extends StatelessWidget {
  const DocumentExpiryDatesModule({super.key});

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
    final em = Assets.icons.employeeManagement;
    final documentIcon = _prefixIcon(context, em.document.path, isDark);
    final calendarPath = Assets.icons.leaveManagementMainIcon.path;

    final civilIdExpiry = DigifyDateField(
      label: localizations.civilIdExpiry,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
    );
    final visaNumber = DigifyTextField(
      labelText: localizations.visaNumber,
      prefixIcon: documentIcon,
      hintText: localizations.hintVisaNumber,
    );
    final workPermitNumber = DigifyTextField(
      labelText: localizations.workPermitNumber,
      prefixIcon: documentIcon,
      hintText: localizations.hintWorkPermitNumber,
    );
    final passportExpiry = DigifyDateField(
      label: localizations.passportExpiry,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
    );
    final visaExpiry = DigifyDateField(
      label: localizations.visaExpiry,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
    );
    final workPermitExpiry = DigifyDateField(
      label: localizations.workPermitExpiry,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
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
          Row(
            children: [
              DigifyAsset(
                assetPath: em.document.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.documentExpiryDates,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
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
                        Expanded(child: civilIdExpiry),
                        Gap(14.w),
                        Expanded(child: passportExpiry),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: visaNumber),
                        Gap(14.w),
                        Expanded(child: visaExpiry),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: workPermitNumber),
                        Gap(14.w),
                        Expanded(child: workPermitExpiry),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [civilIdExpiry, passportExpiry, visaNumber, visaExpiry, workPermitNumber, workPermitExpiry],
              );
            },
          ),
        ],
      ),
    );
  }
}
