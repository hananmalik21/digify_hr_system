import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/add_employee_basic_info_form.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/add_employee_name_fields_info_banner.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeBasicInfoStep extends StatelessWidget {
  const AddEmployeeBasicInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.basicInfo.path,
          title: localizations.basicInformation,
          subtitle: localizations.addEmployeeBasicInfoSubtitle,
        ),
        AddEmployeeNameFieldsInfoBanner(
          message: localizations.addEmployeeNameFieldsConfigured,
          boldPhrases: const ['Enterprise Structure', 'Name Structure Settings'],
          iconAssetPath: em.document.path,
        ),
        _BasicInfoFieldsCard(isDark: isDark, child: const AddEmployeeBasicInfoForm()),
      ],
    );
  }
}

class _BasicInfoFieldsCard extends StatelessWidget {
  const _BasicInfoFieldsCard({required this.child, required this.isDark});

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}
