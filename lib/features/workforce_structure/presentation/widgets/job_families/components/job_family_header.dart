import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/add_position_button.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamilyHeader extends StatelessWidget {
  final AppLocalizations localizations;

  const JobFamilyHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localizations.jobFamilies,
          style: TextStyle(
            fontSize: 15.6.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 24 / 15.6,
          ),
        ),
        AddButton(
          onTap: () => JobFamilyFormDialog.show(context),
          customLabel: localizations.addJobFamily,
        ),
      ],
    );
  }
}
