import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveEntitlementsSection extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveEntitlementsSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.kuwaitLaborLawLeaveEntitlements,
                style: context.textTheme.titleSmall?.copyWith(fontSize: 19.sp, color: AppColors.dialogTitle),
              ),
              Gap(3.h),
              Text(
                localizations.manageEmployeeLeaveRequests,
                style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        AppButton.primary(
          label: localizations.newLeaveRequest,
          svgPath: Assets.icons.addDivisionIcon.path,
          onPressed: () => NewLeaveRequestDialog.show(context),
        ),
      ],
    );
  }
}
