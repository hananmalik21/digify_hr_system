import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/add_position_button.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelsHeader extends StatelessWidget {
  const JobLevelsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localizations.jobLevels,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 24 / 15.5,
          ),
        ),
        AddButton(
          customLabel: localizations.addJobLevel,
          onTap: () {
            JobLevelFormDialog.show(context, onSave: (level) {});
          },
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        ),
      ],
    );
  }
}
