import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/info_banner_card.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/core/widgets/forms/date_selection_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Step 1 of Add Employee: Basic Information (name and primary contact details).
class AddEmployeeBasicInfoStep extends StatelessWidget {
  const AddEmployeeBasicInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.basicInfo.path,
          title: localizations.basicInformation,
          subtitle: localizations.addEmployeeBasicInfoSubtitle,
        ),
        Gap(24.h),
        InfoBannerCard(iconAssetPath: em.document.path, message: localizations.addEmployeeNameFieldsConfigured),
        Gap(24.h),
        _buildForm(context, localizations, isDark),
      ],
    );
  }

  Widget _buildForm(BuildContext context, AppLocalizations localizations, bool isDark) {
    final personIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.userIcon.path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
    final emailIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: Icon(Icons.email_outlined, size: 20.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
    );
    final phoneIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: Icon(Icons.phone_outlined, size: 20.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth > 500;
        final leftFields = [
          DigifyTextField(
            labelText: localizations.firstName,
            isRequired: true,
            prefixIcon: personIcon,
            hintText: localizations.firstName,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: localizations.lastName,
            isRequired: true,
            prefixIcon: personIcon,
            hintText: localizations.lastName,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: localizations.emailAddress,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: emailIcon,
            hintText: localizations.hintEmail,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: localizations.mobileNumber,
            keyboardType: TextInputType.phone,
            prefixIcon: phoneIcon,
            hintText: localizations.phoneHint,
          ),
        ];
        final rightFields = [
          DigifyTextField(
            labelText: localizations.middleName,
            prefixIcon: personIcon,
            hintText: localizations.middleName,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: localizations.firstName,
            isRequired: true,
            prefixIcon: personIcon,
            hintText: localizations.firstName,
            textDirection: TextDirection.rtl,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: localizations.lastName,
            isRequired: true,
            prefixIcon: personIcon,
            hintText: localizations.lastName,
            textDirection: TextDirection.rtl,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: localizations.phoneNumber,
            isRequired: true,
            keyboardType: TextInputType.phone,
            prefixIcon: phoneIcon,
            hintText: localizations.phoneHint,
          ),
          Gap(16.h),
          DateSelectionField(
            label: localizations.dateOfBirth,
            isRequired: true,
            date: null,
            onDateSelected: (_) {},
            labelIconPath: Assets.icons.basicInfoIcon.path,
          ),
        ];

        if (useTwoColumns) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: leftFields)),
              Gap(24.w),
              Expanded(child: Column(children: rightFields)),
            ],
          );
        }
        return Column(children: [...leftFields, ...rightFields]);
      },
    );
  }
}
