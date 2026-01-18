import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalancesHeader extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalancesHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          localizations.leaveBalance,
          style: context.textTheme.titleSmall?.copyWith(fontSize: 19.sp, color: AppColors.dialogTitle),
        ),
        Gap(3.h),
        Text(
          localizations.leaveBalanceDescription,
          style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
