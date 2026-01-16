import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_entitlements_section.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_filter_tabs.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_requests_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveRequestTab extends StatelessWidget {
  const LeaveRequestTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.only(start: 32.w, end: 32.w, bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveEntitlementsSection(localizations: localizations),
          Gap(24.h),
          LeaveFilterTabs(),
          Gap(16.h),
          LeaveRequestsTable(),
        ],
      ),
    );
  }
}
