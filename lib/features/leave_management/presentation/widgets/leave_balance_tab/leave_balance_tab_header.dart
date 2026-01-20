import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalanceTabHeader extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const LeaveBalanceTabHeader({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: localizations.myLeaveBalance,
      description: localizations.myLeaveBalanceDescription,
      trailing: Row(
        children: [
          AppButton(
            label: localizations.applyLeave,
            svgPath: Assets.icons.leaveManagementIcon.path,
            type: AppButtonType.primary,
            backgroundColor: AppColors.primary,
            onPressed: () {},
          ),
          Gap(11.w),
          AppButton(
            label: localizations.requestEncashment,
            svgPath: Assets.icons.leaveManagement.dollar.path,
            type: AppButtonType.primary,
            backgroundColor: AppColors.greenButton,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
