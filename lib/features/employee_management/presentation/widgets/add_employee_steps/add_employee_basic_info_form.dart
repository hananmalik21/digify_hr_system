import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeBasicInfoForm extends ConsumerWidget {
  const AddEmployeeBasicInfoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeBasicInfoProvider);
    final notifier = ref.read(addEmployeeBasicInfoProvider.notifier);

    final personIcon = _buildPrefixIcon(
      context,
      DigifyAsset(
        assetPath: Assets.icons.userIcon.path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
    final emailIcon = _buildPrefixIcon(
      context,
      DigifyAsset(
        assetPath: Assets.icons.employeeManagement.mail.path,
        width: 20.w,
        height: 20.h,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
    final phoneIcon = _buildPrefixIcon(
      context,
      DigifyAsset(
        assetPath: Assets.icons.leaveManagement.phone.path,
        width: 20.w,
        height: 20.h,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );

    final form = state.form;
    final formKey = ValueKey<int>(state.formGenerationId);

    return KeyedSubtree(
      key: formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth > 500;
          final leftFields = _buildLeftColumn(context, localizations, personIcon, emailIcon, form, notifier);
          final rightFields = _buildRightColumn(context, localizations, personIcon, phoneIcon, form, notifier);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (useTwoColumns)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Column(children: leftFields)),
                    Gap(24.w),
                    Expanded(child: Column(children: rightFields)),
                  ],
                )
              else
                Column(children: [...leftFields, ...rightFields]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrefixIcon(BuildContext context, Widget icon) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: icon,
    );
  }

  List<Widget> _buildLeftColumn(
    BuildContext context,
    AppLocalizations l10n,
    Widget personIcon,
    Widget emailIcon,
    CreateEmployeeBasicInfoRequest form,
    AddEmployeeBasicInfoNotifier notifier,
  ) {
    return [
      DigifyTextField(
        labelText: l10n.firstName,
        isRequired: true,
        prefixIcon: personIcon,
        hintText: l10n.hintFirstName,
        initialValue: form.firstNameEn,
        onChanged: notifier.setFirstNameEn,
      ),
      Gap(16.h),
      DigifyTextField(
        labelText: l10n.lastName,
        isRequired: true,
        prefixIcon: personIcon,
        hintText: l10n.hintLastName,
        initialValue: form.lastNameEn,
        onChanged: notifier.setLastNameEn,
      ),
      Gap(16.h),
      DigifyTextField(
        labelText: l10n.middleName,
        prefixIcon: personIcon,
        hintText: l10n.hintMiddleName,
        initialValue: form.middleNameEn,
        onChanged: notifier.setMiddleNameEn,
      ),
      Gap(16.h),
      DigifyTextField(
        labelText: l10n.emailAddress,
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: emailIcon,
        hintText: l10n.hintEmail,
        initialValue: form.email,
        onChanged: notifier.setEmail,
      ),
      Gap(16.h),
      DigifyDateField(
        label: l10n.dateOfBirth,
        hintText: l10n.hintDateOfBirth,
        isRequired: true,
        firstDate: DateTime(1900),
        initialDate: form.dateOfBirth,
        onDateSelected: notifier.setDateOfBirth,
      ),
    ];
  }

  List<Widget> _buildRightColumn(
    BuildContext context,
    AppLocalizations l10n,
    Widget personIcon,
    Widget phoneIcon,
    CreateEmployeeBasicInfoRequest form,
    AddEmployeeBasicInfoNotifier notifier,
  ) {
    return [
      DigifyTextField(
        labelText: l10n.firstNameArabic,
        isRequired: true,
        prefixIcon: personIcon,
        hintText: l10n.hintFirstNameArabic,
        textDirection: ui.TextDirection.rtl,
        initialValue: form.firstNameAr,
        onChanged: notifier.setFirstNameAr,
        inputFormatters: FieldFormat.arabicOnlyFormatters,
      ),
      Gap(16.h),
      DigifyTextField(
        labelText: l10n.lastNameArabic,
        prefixIcon: personIcon,
        hintText: l10n.hintLastNameArabic,
        textDirection: ui.TextDirection.rtl,
        initialValue: form.lastNameAr,
        onChanged: notifier.setLastNameAr,
        inputFormatters: FieldFormat.arabicOnlyFormatters,
        isRequired: true,
      ),
      Gap(16.h),
      DigifyTextField(
        labelText: l10n.middleNameArabic,
        prefixIcon: personIcon,
        hintText: l10n.hintMiddleNameArabic,
        initialValue: form.middleNameAr,
        onChanged: notifier.setMiddleNameAr,
        textDirection: ui.TextDirection.rtl,
        inputFormatters: FieldFormat.arabicOnlyFormatters,
      ),
      Gap(16.h),
      DigifyTextField(
        labelText: l10n.phoneNumber,
        isRequired: true,
        keyboardType: TextInputType.phone,
        prefixIcon: phoneIcon,
        hintText: l10n.hintPhone,
        initialValue: form.phoneNumber,
        onChanged: notifier.setPhoneNumber,
        inputFormatters: FieldFormat.phoneFormatters,
      ),
    ];
  }
}
