import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:flutter/material.dart';

class LeaveBalancesHeader extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalancesHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(title: localizations.leaveBalance, description: localizations.leaveBalanceDescription);
  }
}
