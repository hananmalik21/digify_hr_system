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

class EmergencyContactModule extends StatelessWidget {
  const EmergencyContactModule({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final personIcon = _prefixIcon(context, Assets.icons.userIcon.path, isDark);
    final relationshipIcon = _prefixIcon(context, Assets.icons.employeeListIcon.path, isDark);
    final phoneIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.leaveManagement.phone.path,
        width: 20.w,
        height: 20.h,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
    final emailIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.employeeManagement.mail.path,
        width: 20.w,
        height: 20.h,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
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
                assetPath: Assets.icons.warningIcon.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.emergencyContact,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              final contactName = DigifyTextField(
                labelText: localizations.contactName,
                prefixIcon: personIcon,
                hintText: localizations.hintContactName,
              );
              final relationship = DigifyTextField(
                labelText: localizations.relationship,
                prefixIcon: relationshipIcon,
                hintText: localizations.hintRelationship,
              );
              final phoneNumber = DigifyTextField(
                labelText: localizations.phoneNumber,
                keyboardType: TextInputType.phone,
                prefixIcon: phoneIcon,
                hintText: localizations.hintPhone,
              );
              final emailAddress = DigifyTextField(
                labelText: localizations.emailAddress,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: emailIcon,
                hintText: localizations.hintEmail,
              );
              if (useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: contactName),
                        Gap(14.w),
                        Expanded(child: relationship),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: phoneNumber),
                        Gap(14.w),
                        Expanded(child: emailAddress),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [contactName, relationship, phoneNumber, emailAddress],
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
