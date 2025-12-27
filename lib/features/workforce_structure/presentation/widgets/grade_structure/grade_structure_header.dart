import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/add_position_button.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeStructureHeader extends StatelessWidget {
  const GradeStructureHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localizations.gradeStructure,
          style: TextStyle(
            fontSize: 15.8.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 24 / 15.8,
          ),
        ),
        AddButton(
          customLabel: localizations.addGrade,
          onTap: () {
            GradeFormDialog.show(context, onSave: (grade) {});
          },
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        ),
      ],
    );
  }
}
