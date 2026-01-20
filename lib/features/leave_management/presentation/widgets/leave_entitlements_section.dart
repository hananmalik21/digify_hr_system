import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LeaveEntitlementsSection extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveEntitlementsSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: localizations.kuwaitLaborLawLeaveEntitlements,
      description: localizations.manageEmployeeLeaveRequests,
      trailing: AppButton.primary(
        label: localizations.newLeaveRequest,
        svgPath: Assets.icons.addDivisionIcon.path,
        onPressed: () => NewLeaveRequestDialog.show(context),
      ),
    );
  }
}
