import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_work_schedule_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/work_schedule_assignment_module.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeWorkScheduleStep extends ConsumerWidget {
  const AddEmployeeWorkScheduleStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final workScheduleState = ref.watch(addEmployeeWorkScheduleProvider);
    final workScheduleNotifier = ref.read(addEmployeeWorkScheduleProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: Assets.icons.timeManagementMainIcon.path,
          title: localizations.timeManagementWorkSchedule,
          subtitle: localizations.timeManagementWorkScheduleSubtitle,
        ),
        WorkScheduleAssignmentModule(
          enterpriseId: enterpriseId,
          selectedWorkSchedule: workScheduleState.selectedWorkSchedule,
          onWorkScheduleChanged: workScheduleNotifier.setSelectedWorkSchedule,
        ),
        WorkScheduleStartEndModule(
          wsStart: workScheduleState.wsStart,
          wsEnd: workScheduleState.wsEnd,
          onWsStartChanged: workScheduleNotifier.setWsStart,
          onWsEndChanged: workScheduleNotifier.setWsEnd,
        ),
      ],
    );
  }
}
